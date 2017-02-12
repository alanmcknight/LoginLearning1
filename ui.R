library(shiny)
library(shinydashboard)
shinyUI( 
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(),
    dashboardBody(
      tags$head(includeScript("GTM.js")),
      uiOutput("page")
    )
  )
  
)