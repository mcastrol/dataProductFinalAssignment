#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$wagepredicted<-renderText({predictWage(input$year, input$age,input$education, input$race)})
  
  output$regression <- renderPlot({
    library(ggplot2)
    library(ISLR)
    data(Wage)
    ggplotRegression <- function (fit,predictor) {
      
      require(ggplot2)
      
      ggplot(fit$model, aes_string(x = names(fit$model)[2], y = names(fit$model)[1])) + 
        geom_point() +
        stat_smooth(method = "lm", col = "red") +
        labs(title = paste("Wage by",predictor, ": Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                           "Intercept =",signif(fit$coef[[1]],5 ),
                           " Slope =",signif(fit$coef[[2]], 5),
                           " P =",signif(summary(fit)$coef[2,4], 5)))
    }
    
    switch(input$predictor,
           "year" = fit<-lm(Wage$logwage~Wage$year),
           "age" = fit<-lm(Wage$logwage~Wage$age),
           "education" = fit<-lm(Wage$logwage~Wage$education),
           "race" = fit<-lm(Wage$logwage~Wage$race))
    ggplotRegression(fit,input$predictor)
  })
})

predictWage <- function (year, age, education, race) 
{
  fit<-lm(wage~year+age+as.integer(education)+as.integer(race),Wage)
  switch(education,
         "<HS Grad" = ed<-as.integer(1),
          "Hs Grad" = ed<-as.integer(2),
          "Some College" = ed<-as.integer(3),
          "Advanced Degree" = ed<-as.integer(4))
  switch(race,
         "White" = r<-as.integer(1),
         "Black" = r<-as.integer(2),
         "Asian" = r<-as.integer(3),
         "Other" = r<-as.integer(4))
  
  newdata=data.frame(year=as.integer(year), age=as.integer(age),education=as.integer(ed), race=as.integer(r))
  pred<-predict(fit,newdata=newdata, interval="confidence")
  return(pred[1,1])
}

