library(shiny)
library(shinydashboard)
shinyUI( 
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
      
      uiOutput("page")
      
    )
  )
  
)