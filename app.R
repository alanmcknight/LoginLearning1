library(shinyjs)
library(googleAuthR)
library(googleID)

options(googleAuthR.scopes.selected = c("https://www.googleapis.com/auth/userinfo.email",
                                        "https://www.googleapis.com/auth/userinfo.profile"))
options("googleAuthR.webapp.client_id" = "769713801246-qk2qhqpqt1k0g8rurm0jkomg73kggj1i.apps.googleusercontent.com")
options("googleAuthR.webapp.client_secret" = "VTMwnOGWKame7JZPFlV4G7v0")

ui <- navbarPage(
  title = "App Name",
  windowTitle = "Browser window title",
  tabPanel("Tab 1",
           useShinyjs(),
           sidebarLayout(
             sidebarPanel(
               p("Welcome!"),
               googleAuthUI("gauth_login")
             ),
             mainPanel(
               textOutput("display_username"),
               textOutput("display_username2")
             )
           )
  ),
  tabPanel("Tab 2",
           p("Layout for tab 2")
  )
)

server <- function(input, output, session) {
  ## Global variables needed throughout the app
  rv <- reactiveValues(
    login = FALSE
  )
  
  ## Authentication
  accessToken <- callModule(googleAuth, "gauth_login",
                            login_class = "btn btn-primary",
                            logout_class = "btn btn-primary")
  userDetails <- reactive({
    validate(
      need(accessToken(), "not logged in")
    )
    rv$login <- TRUE
    with_shiny(get_user_info, shiny_access_token = accessToken())
  })
  
  ## Users
  googleAuthR::gar_auth()
  user <- get_user_info()
  the_list <- whitelist(user, c("mcknightalan@gmail.com", "another@email.com", "yet@anotheremail.com"))
  
  output$display_username <- renderText({
    validate(
      need(userDetails(), "getting user details")
    )
    if(the_list){
      a<- "You are on the list."
    }else{
      a <- "If you're not on the list, you're not getting in."
    }
    a
  })
  
  ## Display user's Google display name after successful login
  output$display_username2 <- renderText({
    validate(
      need(userDetails(), "getting user details")
    )
    userDetails()$displayName
  })
  
  ## Workaround to avoid shinyaps.io URL problems
  observe({
    if (rv$login) {
      shinyjs::onclick("gauth_login-googleAuthUi",
                       shinyjs::runjs("window.location.href = 'https://yourdomain.shinyapps.io/appName';"))
    }
  })
}

shinyApp(ui = ui, server = server)