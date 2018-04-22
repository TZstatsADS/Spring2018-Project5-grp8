#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Prediction"),
  skin = "blue",
  
  dashboardSidebar(
    width = 260,
    sidebarMenu(id="tabs",
                menuItem("Welcome",tabName = "Welcome1", icon = icon("book")),
                menuItem("Introduction",  icon = icon("file-text-o"),
                         menuSubItem("Read Me",tabName = "ReadMe"),
                         menuSubItem("About Team"),tabName = "AboutTeam"),
                menuItem("Algorithms Evaluation", tabName = "Evaluation",icon = icon("bar-chart-o")),
                menuItem("Multiple Predictions",tabName = "MultiplePrediction",icon = icon("credit-card")),
                menuItem("Single Prediction",tabName = "SinglePrediction",icon = icon("cc-visa"))
                ),
    hr()
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "Welcome1",
              mainPanel(
                img(src = "welcome.png",height=500,width=500)
              )),
      
      tabItem(tabName = "Evaluation",
              fluidRow(
                tabBox(width = 12,
                       tabPanel(title = "Algorithms Introductions",width = 12),
                       tabPanel(title = "Algorithms Evaluation",width = 12)
                       )
              )),
      
      tabItem(tabName = "MultiplePrediction",
              fluidRow(
                tabBox(width = 6,
                       fileInput(inputId = "test", label = "Choose Your Testing Data Table (CSV file)"),
                       submitButton("Submit",width = "100%")),
                tabBox(width = 12,
                       tabPanel(title = "Test Data",solidHeader = T,
                                dataTableOutput("testtable"),
                                tags$style(type="text/css", '#myTable tfoot {display:none;}')),
                       tabPanel(title = "Prediction",solidHeader = T,
                                dataTableOutput("predtable")))
              )),
      
      tabItem(tabName = "SinglePrediction",
              radioButtons("gender", label = "Gender",
                           choices = list("Male" = 1,"Female" = 2),selected = 2, inline = T),
              radioButtons("marriage",label = "Marriage",
                           choices = list("Married"=1,"Unmarried"=2), selected = 2,inline = T),
              
              div(style = "height: 58px;",
                  numericInput(inputId = "bill1",label = "Bill last 6 months",value = 0)),
              div(style = "height: 30px;",
                  numericInput(inputId = "bill2",label = NULL,value = 0)),
              div(style = "height: 30px;",
                  numericInput(inputId = "bill3",label = NULL,value = 0)),
              div(style = "height: 30px;",
                  numericInput(inputId = "bill4",label = NULL,value = 0)),
              div(style = "height: 30px;",
                  numericInput(inputId = "bill5",label = NULL,value = 0)),
              div(style = "height: 50px;",
                  numericInput(inputId = "bill6",label = NULL,value = 0)),
              
              div(style = "height: 58px;",
                  numericInput(inputId = "payment1",label = "Payment last 6 months",value = 0)),
              div(style = "height: 30px;",
                  numericInput(inputId = "payment2",label = NULL,value = 0)),
              div(style = "height: 30px;",
                  numericInput(inputId = "payment3",label = NULL,value = 0)),
              div(style = "height: 30px;",
                  numericInput(inputId = "payment4",label = NULL,value = 0)),
              div(style = "height: 30px;",
                  numericInput(inputId = "payment5",label = NULL,value = 0)),
              div(style = "height: 50px;",
                  numericInput(inputId = "payment6",label = NULL,value = 0)),
              submitButton("Predict"))
    )
  )
)

