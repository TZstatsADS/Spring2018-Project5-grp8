#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(e1071)

# preprocessing test dataframe
transform_df <- function(df){
  colnames(df) <- c("X1","X2","X4","X5","X12","X13","X14","X15","X16","X17","X18","X19","X20","X21","X22","X23")  
  
  df$X2_1 <- ifelse(df$X2==1,1,0)
  df$X2_2 <- ifelse(df$X2==2,1,0)
  df$X4_1 <- ifelse(df$X4==1,1,0)
  df$X4_2 <- ifelse(df$X4==2,1,0)
  df <- df[,-c(2:3)]
  
  scaled_df <- scale(df)
  return(scaled_df)
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  load("./model_linear.rda")
  load("./model_RBF.rda")
  
  # Inputs
  bill1 <- reactive({bill1 <- input$bill1})
  bill2 <- reactive({bill2 <- input$bill2})
  bill3 <- reactive({bill3 <- input$bill3})
  bill4 <- reactive({bill4 <- input$bill4})
  bill5 <- reactive({bill5 <- input$bill5})
  bill6 <- reactive({bill6 <- input$bill6})
  
  payment1 <- reactive({payment <- input$payment1})
  payment2 <- reactive({payment <- input$payment2})
  payment3 <- reactive({payment <- input$payment3})
  payment4 <- reactive({payment <- input$payment4})
  payment5 <- reactive({payment <- input$payment5})
  payment6 <- reactive({payment <- input$payment6})
  
  
  marriage <- reactive({marriage <- input$marriage})
  gender <- reactive({gender <- input$gender})
  
  filedata <- eventReactive(input$test,{
    read.csv(input$test$datapath)
  })
  
  
  # Outputs
  output$testtable <- renderDataTable(
    {
      filedata()
      
      #colnames(tbl) <- c("LIMIT_BAL","SEX","MARRIAGE",
      #                   "AGE","BILL_AMT1","BILL_AMT2",
      #                   "BILL_AMT3","BILL_AMT4","BILL_AMT5",
      #                   "BILL_AMT6","PAY_AMT1","PAY_AMT2",
      #                   "PAY_AMT3","PAY_AMT4","PAY_AMT5",
      #                   "PAY_AMT6")
      #tbl
    },options = list(orderClasses = TRUE,
                     iDisplayLength = 5, 
                     lengthMenu = c(5, 10, 15, 20),
                     autoWidth = TRUE)
  )
  
  output$predtable <- renderDataTable({
    data_scaled <- transform_df(filedata()[,-1])
    pred_lin <- predict(model_linear,data_scaled)
    pred <- data.frame("ID" = 1:nrow(filedata()),"Linear SVM"=pred_lin)
    pred
  })
  
  
})
