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
library(xgboost)

dashboardPage(
  dashboardHeader(title = "Prediction"),
  skin = "blue",
  
  dashboardSidebar(
    width = 260,
    sidebarMenu(id = "tabs",
                menuItem("Welcome",tabName = "Welcome1", icon = icon("book")),
                menuItem("Introduction",  icon = icon("file-text-o"),
                         menuSubItem("Read Me",tabName = "ReadMe"),
                         menuSubItem("About Team",tabName = "AboutTeam")),
                menuItem("Algorithms Evaluation", tabName = "Evaluation",icon = icon("bar-chart-o")),
                menuItem("Multiple Predictions",tabName = "MultiplePrediction",icon = icon("credit-card")),
                menuItem("Individual Prediction",tabName = "SinglePrediction",icon = icon("cc-visa"))
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
                       tabPanel(title = "Tutorial",solidHeader = T,
                                p("To make multiple prediction, a data frame consisting the relevant information of credit card clients you want to predict is required. The data frame should include 16 explanatory variables as follows."),
                                p("X1: Amount of the given credit (NT dollar): it includes both the individual consumer credit and his/her family (supplementary) credit."),
                                p("X2: Gender (1 = male; 2 = female)."),
                                p("X3: Education (1 = graduate school; 2 = university; 3 = high school; 4 = others)."),
                                p("X4: Marital status (1 = married; 2 = single)."),
                                p("X5: Age (year)."),
                                p("X6-X11: History of past 6 months payment. (-1 = pay duly; 1~8 = payment delay for 1~8 months; 9 = payment delay for 9 months or above)."),
                                p("X12-X17: Amount of bill statement (NT dollar) of the past six months."),
                                p("X18-X23: Amount of payment (NT dollar) of the past six months."),
                                p("Example:"),
                                img(src = "example.png",height=100,width=1000)),
                       tabPanel(title = "Test Data",solidHeader = T,
                                dataTableOutput("testtable"),
                                tags$style(type="text/css", '#myTable tfoot {display:none;}')),
                       tabPanel(title = "Prediction",solidHeader = T,
                                dataTableOutput("predtable")))
              )),
      
      tabItem(tabName = "SinglePrediction",
              fluidRow(
                tabBox(width = 6,
                         radioButtons("gender", label = "Gender",
                                      choices = c("Male" = 1,"Female" = 2),selected = 2, inline = T),
                         radioButtons("marriage",label = "Marriage",
                                      choices = c("Married"=1,"Unmarried"=2), selected = 2,inline = T),
                         radioButtons("education",label = "Education",
                                      choices = c("Graduate or above" = 1, "University" = 2,
                                                     "High School" = 3, "Others" = 4),inline = T),
                         numericInput(inputId = "credit",label = "Amount of given credit",value = 0,min = 0),
                         numericInput(inputId = "age",label = "Age",value = 30,min = 1,max = 120),
                  
                         div(style = "height: 58px;",
                             selectInput(inputId = "past1", label = "History of past 6 months payment",
                                         choices = c("Pay Duly" = -1, 
                                                        "Payment delay for 1 month" = 1,
                                                        "Payment delay for 2 months" = 2,
                                                        "Payment delay for 3 months" = 3,
                                                        "Payment delay for 4 months" = 4,
                                                        "Payment delay for 5 months" = 5,
                                                        "Payment delay for 6 months" = 6,
                                                        "Payment delay for 7 months" = 7,
                                                        "Payment delay for 8 months" = 8,
                                                        "Payment delay for 9 months or above" = 9))),
                         div(style = "height: 30px;",
                             selectInput(inputId = "past2", label = NULL,
                                         choices = c("Pay Duly" = -1, 
                                                        "Payment delay for 1 month" = 1,
                                                        "Payment delay for 2 months" = 2,
                                                        "Payment delay for 3 months" = 3,
                                                        "Payment delay for 4 months" = 4,
                                                        "Payment delay for 5 months" = 5,
                                                        "Payment delay for 6 months" = 6,
                                                        "Payment delay for 7 months" = 7,
                                                        "Payment delay for 8 months" = 8,
                                                        "Payment delay for 9 months or above" = 9))),
                         div(style = "height: 30px;",
                             selectInput(inputId = "past3", label = NULL,
                                         choices = c("Pay Duly" = -1, 
                                                        "Payment delay for 1 month" = 1,
                                                        "Payment delay for 2 months" = 2,
                                                        "Payment delay for 3 months" = 3,
                                                        "Payment delay for 4 months" = 4,
                                                        "Payment delay for 5 months" = 5,
                                                        "Payment delay for 6 months" = 6,
                                                        "Payment delay for 7 months" = 7,
                                                        "Payment delay for 8 months" = 8,
                                                        "Payment delay for 9 months or above" = 9))),
                         div(style = "height: 30px;",
                             selectInput(inputId = "past4", label = NULL,
                                         choices = c("Pay Duly" = -1, 
                                                        "Payment delay for 1 month" = 1,
                                                        "Payment delay for 2 months" = 2,
                                                        "Payment delay for 3 months" = 3,
                                                        "Payment delay for 4 months" = 4,
                                                        "Payment delay for 5 months" = 5,
                                                        "Payment delay for 6 months" = 6,
                                                        "Payment delay for 7 months" = 7,
                                                        "Payment delay for 8 months" = 8,
                                                        "Payment delay for 9 months or above" = 9))),
                         
                         div(style = "height: 30px;",
                             selectInput(inputId = "past5", label = NULL,
                                         choices = c("Pay Duly" = -1, 
                                                        "Payment delay for 1 month" = 1,
                                                        "Payment delay for 2 months" = 2,
                                                        "Payment delay for 3 months" = 3,
                                                        "Payment delay for 4 months" = 4,
                                                        "Payment delay for 5 months" = 5,
                                                        "Payment delay for 6 months" = 6,
                                                        "Payment delay for 7 months" = 7,
                                                        "Payment delay for 8 months" = 8,
                                                        "Payment delay for 9 months or above" = 9))),
                         div(style = "height: 50px;",
                             selectInput(inputId = "past6", label = NULL,
                                         choices = c("Pay Duly" = -1, 
                                                        "Payment delay for 1 month" = 1,
                                                        "Payment delay for 2 months" = 2,
                                                        "Payment delay for 3 months" = 3,
                                                        "Payment delay for 4 months" = 4,
                                                        "Payment delay for 5 months" = 5,
                                                        "Payment delay for 6 months" = 6,
                                                        "Payment delay for 7 months" = 7,
                                                        "Payment delay for 8 months" = 8,
                                                        "Payment delay for 9 months or above" = 9)))
                         
                         
                         ),
                tabBox(width = 6,
                       div(style = "height: 58px;",
                           numericInput(inputId = "bill1",label = "Amount of bill statement last 6 months",value = 0)),
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
                           numericInput(inputId = "payment1",label = "Amount of payment last 6 months",value = 0)),
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
                       actionButton("predict",label = "Predict"))
              ),
              tabBox(width = 12,
                     tabPanel(title = "Tutorial",
                              p("Please fulfill the information for the customer.")),
                     tabPanel(title = "Prediction",
                              strong("Will this customer make default payment next month?\n\n"),
                              textOutput("predind")))

    )
  )
))

