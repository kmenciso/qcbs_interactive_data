library(shinydashboard)
library(DT)
library(shinyjs)
library(data.table)
library(googleVis)


shinyServer(function(input, output, session) {
  
  # Enable the Submit button when all mandatory fields are filled out
  observe({
    mandatory_filled <-
      vapply(fieldsMandatory,
             function(x) {
               !is.null(input[[x]]) && input[[x]] != ""
             },
             logical(1))
    mandatory_filled <- all(mandatory_filled)
    # toggle state of sumbit button based on mandatory_filled, T = show/F = hide
    shinyjs::toggleState(id = "submit", condition = mandatory_filled)
  })
  
  # once we've submitted an entry and the reload button is pressed
  # we load the data again with the new entry
  reloadDt <- reactive({
    # observe any changes to reload
    input$reload
    isolate({
      # only when input$reload is changed do you load the data again
      dt <- loadData()
    })
    
  })
  
  formData <- reactive({
    input$submit
    isolate({
      # get the inputs from the form and put it into an empty data.table
      j_text <- paste(paste(fieldsAll, " = input$", fieldsAll, sep = ""), collapse = ",")
      dt_text <- sprintf("data.table(%s)", j_text)
      dt <- eval(parse(text = dt_text))
      dt
    })

  })    
  
  mergeData <- reactive({
    # merge old data and new entry 
    old_dt <- loadData()
    new_dt <- formData()
    
    dt <- rbind(old_dt, new_dt)
    
  })
  
  # country widget
  output$country_widget <- renderUI({
    dt <- data.table(loadData())
    country_choices <- dt[, unique(as.character(country))]
    
    selectInput("country",
                label = "Country",
                choices = country_choices)
  })
  
  # html data output
  output$data <- renderDataTable({
    input$reload
    isolate({
      loadData()
    })

  })
  
  # html plot output
  output$plot <- renderGvis({
    plant_dt <- loadData()
    
    # if reload button is pressed, reload plant data
    input$reload
    isolate({
      plant_dt <- loadData()
    })
    
    # format data into format for gvisColumnChart()
    plant_dt <- dcast.data.table(data = plant_dt,
                                 formula = plant ~ treatment,
                                 value = "stem_length",
                                 fun.aggregate = mean,
                                 na.rm = T)
    # adding tooltip
    plant_dt[, `:=`(control.html.tooltip = "countries: BR, US, CA, FR",
                    treatment1.html.tooltip = "countries: BR, US, CA, FR",
                    treatment2.html.tooltip = "countries: BR, US, CA, FR",
                    treatment3.html.tooltip = "countries: BR, US, CA, FR")]
    setcolorder(plant_dt,
                c("plant",
                  "control",
                  "control.html.tooltip",
                  "treatment1",
                  "treatment1.html.tooltip",
                  "treatment2",
                  "treatment2.html.tooltip",
                  "treatment3",
                  "treatment3.html.tooltip"))
    
    gvis_plot <- gvisColumnChart(plant_dt,
                                 x = "plant",
                                 y = names(plant_dt)[-1],
                                 options = list(
                                   width = 700,
                                   height = 550,
                                   vAxes = "[{title: 'Stem Length(cm)'}]",
                                   hAxes = "[{title: 'Plant'}]",
                                   tooltip="{isHtml:'True'}"
                                 ))
  })
  
  # When the Submit button is clicked, submit the response
  observeEvent(input$submit, {

    # User-experience stuff
    shinyjs::disable("submit")
    shinyjs::show("submit_msg")
    shinyjs::hide("error")

    # Save the data (show an error message in case of error)
    tryCatch({
      # use reactive MergeData() to update the plant_dt.csv file
      saveData(mergeData())
      shinyjs::reset("form")
      shinyjs::hide("form")
      shinyjs::show("thankyou_msg")
    },
    error = function(err) {
      # if there is an error show an error message
      shinyjs::html("error_msg", err$message)
      shinyjs::show(id = "error", anim = TRUE, animType = "fade")
    },
    finally = {
      # show the submit message
      shinyjs::enable("submit")
      shinyjs::hide("submit_msg")
    })
  })
  
  # submit another response
  observeEvent(input$submit_another, {
    shinyjs::show("form")
    shinyjs::hide("thankyou_msg")
  })
  
     
  }
)
