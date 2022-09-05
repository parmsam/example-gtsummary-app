# Load libraries
library(shiny)
library(gtsummary)
library(gt)
library(datasets)

# List datasets of interest
listDatasets <- c("USArrests", "VADeaths", "Seatbelts")

# Define a UI for the Shiny app
# Dropdown selection for dataset of interest
ui <- fluidPage(selectInput("dataset", "Select dataset", listDatasets),
            gt::gt_output('table'))
# Define a server for the Shiny app
server <- function(input, output) {
  selectedData <- reactive({
    req(input$dataset)
    
    # Ensure that the input dataset is a tibble
    gtsummary::as_tibble(get(input$dataset, "package:datasets"))
  })
  
  gtObject <- reactive({
    req(input$dataset)
    
    # Create a gtsummary object and convert it to a gt object
    gts_object <- gtsummary::tbl_summary(selectedData())
    gtsummary::as_gt(gts_object)
  })
  
  # Render a gt table
  output$table <- render_gt({
    req(input$dataset)
    
    gtObject()
  })
}
# Run Shiny app
shinyApp(ui, server)