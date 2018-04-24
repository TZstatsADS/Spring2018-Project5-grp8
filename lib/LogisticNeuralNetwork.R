library(caret)
library(reshape2)
library(ggplot2)
library(pROC)
library(nnet)


# Establish common downstream variables
classColumn <- "Y"
badIndicator <- 1
goodIndicator <- 0
montonicConstraint <- "No"

# Training data
dataTrainingSample <- read.csv("train.csv")
dataTrainingSample <- dataTrainingSample[1:5999,]
dataTrainingSample <- as.data.frame(dataTrainingSample)

# Testing data
dataTestingSample <- read.csv("test.csv")
dataTestingSample <- as.data.frame(dataTestingSample)

# Get totals for downstream 
numberOfObservations <- nrow(dataTrainingSample)
numberOfBads <- nrow(dataTrainingSample[dataTrainingSample[,classColumn]==badIndicator,])
numberOfGoods <- numberOfObservations-numberOfBads

# Create tons of model combinations
Variables <- c("X1", 
              "X2",
              "X3",
              "X4",
              "X5",
              "X6",
              "X7",
              "X8",
              "X9",
              "X10",
              "X11",
              "X12", 
              "X13", 
              "X14", 
              "X15", 
              "X16", 
              "X17", 
              "X18", 
              "X19", 
              "X20", 
              "X21", 
              "X22", 
              "X23")

logisticSummary <- matrix(0, nrow = 1, ncol = 14)
colnames(logisticSummary) <- c("Variables", "Formula", "Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "AUC", "P < 0.05")
logisticSummary <- as.data.frame(logisticSummary)

logisticModels <- NULL

for (i in (1:length(Variables)))
{
  Vars <- 1
  temp <- logisticSummary
  
  FORMULA <- paste0(classColumn, " ~ ", Variables[i])
  MODEL <- glm(as.formula(FORMULA), data=dataTrainingSample, family=binomial(link="logit"))
  PREDICTED <- plogis(predict(MODEL, dataTestingSample))
  
  temp[1,"AUC"] <- auc(dataTestingSample[,classColumn],PREDICTED)
  temp[1,"P < 0.05"] <- length(which(as.numeric(coef(summary(MODEL))[,4]) < 0.05))-(Vars+1)
  
  if (temp[1,"P < 0.05"]==0)
  {
    temp[1,"Variables"] <- 1
    temp[1,"Var1"] <- Variables[i]
    temp[1, "Formula"] <- FORMULA
    
    logisticModels <- rbind(logisticModels, temp)
    
    variablesSublist1 <- Variables[which(Variables%in%c(Variables[i])==FALSE)]
    
    for (j in (1:length(variablesSublist1)))
    {
      temp <- logisticSummary
      Vars <- 2
      
      FORMULA <- paste0(classColumn, " ~ ", Variables[i], " + ", variablesSublist1[j])
      MODEL <- glm(as.formula(FORMULA), data=dataTrainingSample, family=binomial(link="logit"))
      PREDICTED <- plogis(predict(MODEL, dataTestingSample))
      
      temp[1,"AUC"] <- auc(dataTestingSample[,classColumn],PREDICTED)
      temp[1,"P < 0.05"] <- length(which(as.numeric(coef(summary(MODEL))[,4]) < 0.05))-(Vars+1)
      
      if (temp[1,"P < 0.05"]==0)
      {
        temp[1,"Variables"] <- 2
        temp[1,"Var1"] <- Variables[i]
        temp[1,"Var2"] <- variablesSublist1[j]
        temp[1, "Formula"] <- FORMULA
        
        logisticModels <- rbind(logisticModels, temp)
        
        variablesSublist2 <- Variables[which(Variables%in%c(Variables[i], variablesSublist1[j])==FALSE)]
        
        for (k in (1:length(variablesSublist2)))
        {
          temp <- logisticSummary
          Vars <- 3
          
          FORMULA <- paste0(classColumn, " ~ ", Variables[i], " + ", variablesSublist1[j], " + ", variablesSublist2[k])
          MODEL <- glm(as.formula(FORMULA), data=dataTrainingSample, family=binomial(link="logit"))
          PREDICTED <- plogis(predict(MODEL, dataTestingSample))
          
          temp[1,"AUC"] <- auc(dataTestingSample[,classColumn],PREDICTED)
          temp[1,"P < 0.05"] <- length(which(as.numeric(coef(summary(MODEL))[,4]) < 0.05))-(Vars+1)
          
          if (temp[1,"P < 0.05"]==0)
          {
            temp[1,"Variables"] <- 3
            temp[1,"Var1"] <- Variables[i]
            temp[1,"Var2"] <- variablesSublist1[j]
            temp[1,"Var3"] <- variablesSublist2[k]
            temp[1, "Formula"] <- FORMULA
            
            logisticModels <- rbind(logisticModels, temp)
            
          }
          
        }
        
      }
      
    }
  }
}

# Order from least to most predictive 
logisticModels <- logisticModels[order(logisticModels$AUC),]

# This is required for the nnet package
dataTestingSample$Y <- as.factor(dataTestingSample$Y)

# Finally, just plug in everything to a neural network
FORMULA <- logisticModels[nrow(logisticModels), "Formula"]
MODEL <- nnet(as.formula(FORMULA), data=dataTrainingSample, size = 2, rang = 0.1,decay = 5e-4, maxit = 200)
dataTestingSample$PREDICTION <- predict(MODEL, dataTestingSample[,-which(colnames(dataTestingSample)=="Y")])

dataTestingSample$PREDICTION[dataTestingSample$PREDICTION>0.5]<-1
dataTestingSample$PREDICTION[dataTestingSample$PREDICTION<=0.5]<-0
dataTestingSample$PREDICTION == dataTestingSample$Y
sum(dataTestingSample$PREDICTION == dataTestingSample$Y)/nrow(dataTestingSample)

library(InformationValue)
plotROC(as.matrix(dataTestingSample[,classColumn]), dataTestingSample$PREDICTION)

library(devtools)
plot.nnet(MODEL)

Reference:
https://gist.githubusercontent.com/Peque/41a9e20d6687f2f3108d/raw/85e14f3a292e126f1454864427e3a189c2fe33f3/nnet_plot_update.r
