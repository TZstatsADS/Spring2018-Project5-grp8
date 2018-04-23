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
                         menuSubItem("About Team",tabName = "AboutTeam")),
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
                h1("Credit Card Default Prediction App"),
                img(src = "welcome.png",height=500,width=500)
                
              )),
      tabItem(tabName = "ReadMe",
              mainPanel(
                p("Welcome to use this credit card default prediction app. Our app helps you to predict whether a credit card client will default in the next month."),
                p("Our app includes three main components."),
                strong("Intro"),
                p("Gives you a general idea of how this app works."),
                strong("Prediction"),
                p("The core function interface where two types of predictions (individual and multiple) are provided. Given the requested information of certain credit card client, the default payment prediction (Yes = 1, No = 0) will be made."),
                strong("Appendix"),
                p("More detailed description about the technical part. Principles of 5 different algorithms employed and the performance comparison between them are illustrated; while reference and the original data source are given as well.")
              )),
      tabItem(tabName = "AboutTeam",
              mainPanel(
                p("Dear user, it is our honor to provide you this app to make default prediction of credit card clients. If you have any question or suggestion while using our app, please feel free to conduct us. The contact information are as follows."),
                p(""),
                p("Jiang, Chenfei  cj2526@columbia.edu"),
                p("Utomo, Michael  mu2251@columbia.edu"),
                p("Yao, Jingtian  jy2867@columbia.edu")
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
              submitButton("Predict"),
              mainPanel(
                p("To make multiple prediction, a data frame consisting the relevant information of credit card clients you want to predict is required. The data frame should include 16 explanatory variables as follows."),
                p("X1: Amount of the given credit (NT dollar): it includes both the individual consumer credit and his/her family (supplementary) credit."),
                p("X2: Gender (1 = male; 2 = female)."),
                p("X3: Marital status (1 = married; 2 = single)."),
                p("X4: Age (year)."),
                p("X5-X10: Amount of bill statement (NT dollar) of the past six months."),
                p("X11-X16: Amount of payment (NT dollar) of the past six months."),
                p("Eg:"),
                img(src = "example.png",height=50,width=500)
              ))
    )
  )
)

