library(shinydashboard)
library(DT)


shinyUI(
  fluidPage(
    # enable use of shinyjs
    shinyjs::useShinyjs(),
    # input custom css sheet (appCSS from global.R)
    shinyjs::inlineCSS(appCSS),
    titlePanel("Lab 1: Plants"),
    
    fluidRow(
      # page is split into 1 row and two columns,
      # fluidRow has a max width of 12 
      column(4,
             # first column has width of 4
             div(
               # the same as div in HTML (wraps all the items within: children)
               id = "form",
               
               textInput("student_number", labelMandatory("Student Number"), ""),
               textInput("student_name", labelMandatory("Student Name"), ""),
               textInput("plant", labelMandatory("Plant ID")),
               
               selectInput("country",
                           label = "Country",
                           choices = c("US", "BR", "CA", "FR")),
               selectInput("treatment",
                           label = "Treatment",
                           choices = list("Control" = "control",
                                          "Treatment 1" = "treatment1",
                                          "Treatment 2" = "treatment2",
                                          "Treatment 3" = "treatment3")),
               numericInput("stem_length",
                            label = "Stem Length (cm):",
                            value = 0,
                            min = 0,
                            max = 100),
               actionButton("submit", "Submit", class = "btn-primary"),
               
               shinyjs::hidden(
                 # initial state of error message is hidden, only triggered when
                 # tryCatch registers an error
                 span(id = "submit_msg", "Submitting..."),
                 div(id = "error",
                     div(br(), tags$b("Error: "), span(id = "error_msg"))
                 )
               )
             ),
             
             shinyjs::hidden(
               # initial state of submit message is hidden, only triggered after
               # tryCatch 
               div(
                 id = "thankyou_msg",
                 h3("Thanks, your response was submitted successfully!"),
                 actionLink("submit_another", "Submit another response")
               )
             )
      ),
      column(7,
             tabsetPanel(tabPanel("Plot",
                                  htmlOutput("plot"),
                                  value = "plot"),
                         tabPanel("Table", 
                                  br(),
                                  actionButton("reload", "Reload", class = "btn-primary"), 
                                  br(),
                                  br(),
                                  dataTableOutput("data"),
                                  value = "table"),
                         id = "tsp")
      )
    )
  )
)
