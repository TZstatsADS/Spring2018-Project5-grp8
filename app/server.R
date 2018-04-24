#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(xgboost)
library(randomForest)

# Functions
pred_switch <- function(pred){
  return(ifelse(pred==1,"Yes","No"))
}


shinyServer(function(input, output) {
  
  # Load models
  load("./model_xgb.rda")
  load("./model_rf.rda")
  
  # Inputs
  
  past1 <- reactive({past1 <- input$past1})
  past2 <- reactive({past2 <- input$past2})
  past3 <- reactive({past3 <- input$past3})
  past4 <- reactive({past4 <- input$past4})
  past5 <- reactive({past5 <- input$past5})
  past6 <- reactive({past6 <- input$past6})
  
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
  
  credit <- reactive({credit <- input$credit})
  age <- reactive({age <- input$age})
  marriage <- reactive({marriage <- input$marriage})
  gender <- reactive({gender <- input$gender})
  education <- reactive({education <- input$education})
  
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
    test_Dmat <- xgb.DMatrix(as.matrix(filedata()[,-1]))
    pred_xgb <- predict(model,test_Dmat)
    pred_rf <- predict(final_rf,filedata()[,-1])
    pred <- data.frame("ID" = 1:nrow(filedata()),"Xgboost"=pred_switch(pred_xgb),"Random_Forest"=pred_switch(pred_rf))
    pred
  })
  
  output$predind <- renderText({
    obs_vec <- c(credit(),gender(),education(),marriage(),age(),
                 past1(),past2(),past3(),past4(),past5(),past6(),
                 bill1(),bill2(),bill3(),bill4(),bill5(),bill6(),
                 payment1(),payment2(),payment3(),payment4(),payment5(),payment6())
    obs_vec <- as.numeric(obs_vec)
    obs_mat <- t(as.matrix(obs_vec))
    obs_Dmat <- xgb.DMatrix(as.matrix(obs_mat))
    pred_xgb_ind <- predict(model,obs_Dmat)
    pred_switch(pred_xgb_ind)
  })
  
  
  eventReactive(input$predict,{
    
    })

  
})
