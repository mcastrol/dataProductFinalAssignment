#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Wage linear regression analysis and prediction"),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("predictor", "Choose a predictor:", choices = c("year", "age", "education","race")),
      sliderInput("year",  "Year to predict", min = 2000, max = 2012, value = 2006),                              
      sliderInput("age",  "Age", min = 18, max = 80, value = 42),
      selectInput("education",  "Education", choices = c("<HS Grad", "Hs Grad", "Some College","Advanced Degree")),
      selectInput("race",  "Race", choices = c("White","Black", "Asian", "Other"))
    ),
    
    
    # Show a plot of the generated distribution
    mainPanel(
        plotOutput("regression"),
        tags$b('Predicted Wage ($):'),
        tags$b(textOutput("wagepredicted")),
        br(),
        br(),
        h4('Instructions'),
        helpText("This application is for see the linear regression of Wage respect to year, age, education and race"),
        helpText("You have to choose a predictor and the app gives you the Adj.R2, interceptor, the slope and pvalue"),
        helpText("Moreover, you can predict the wage ($) of a person by entering the year, age, education and race")

    )
  )
))
