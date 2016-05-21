# which fields get saved 
fieldsAll <- c("student_number", 
               "student_name", 
               "plant", 
               "country", 
               "treatment",
               "stem_length")

# which fields are mandatory
fieldsMandatory <- c("student_number", 
                     "student_name",
                     "plant")

# add an asterisk to an input label
labelMandatory <- function(label) {
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

# save the results to a file
saveData <- function(data) {
  fileName <- "plant_data.csv"
  
  write.csv(x = data, file = file.path(fileName),
            row.names = FALSE, quote = TRUE)
}

# load all responses into a data.frame
loadData <- function() {
  files <-  data.table(read.csv(file = "plant_data.csv"))
  
}


# CSS to use in the app
appCSS <-
  ".mandatory_star { color: red; }
.shiny-input-container { margin-top: 25px; }
#submit_msg { margin-left: 15px; }
#error { color: red; }"
