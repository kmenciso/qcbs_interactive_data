# Global variables: which fields get saved 
fieldsAll <- c("student_number", 
               "student_name", 
               "plant", 
               "country", 
               "treatment",
               "stem_length")

# Global variables: which fields are mandatory
fieldsMandatory <- c("student_number", 
                     "student_name",
                     "plant")

labelMandatory <- function(label) {
# Function that adds an asterisk to an input label so that we know it is a mandatory field
#
# Arguments :
#         label = the input label
#
# Output : 
#       html code
  tagList(
    label,
    span("*", class = "mandatory_star")
  )
}

saveData <- function(data) {
# Function that saves the results (data) into the plant_data.csv file 
#
# Arguments:
#         data = data we want to save, the data table
#
# Output:
#       no output but the plant_data.csv should exist/be updated in the folder
  fileName <- "plant_data.csv"
  
  write.csv(x = data, file = file.path(fileName),
            row.names = FALSE, quote = TRUE)
}

loadData <- function() {
# Function that loads the plant_data.csv file
#
# Arguments: NULL
#
# Output:
#       data.table of data from plant_data.csv
  files <-  data.table(read.csv(file = "plant_data.csv"))
  
}

# CSS to use in the app
appCSS <-
  ".mandatory_star { color: red; }
.shiny-input-container { margin-top: 25px; }
#submit_msg { margin-left: 15px; }
#error { color: red; }"
