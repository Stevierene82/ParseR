#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
ui <- fluidPage(
   
   # Application title
   titlePanel("Parsing data"),
   
   # Sidebar with a slider input for number of bins 
   sidebarLayout(
      sidebarPanel(
          h3('Data Import'),
          p('Goal is to:'),
          tags$ul(
              tags$li('import a file'),
              tags$li('parse desired info'),
              tags$li('put into a dataframe'),
              tags$li('save out file')),
          # Input: Select a file ----
          fileInput("file1", "Choose a File",
                    multiple = TRUE,
                    accept = c("text/csv",
                               "text/comma-separated-values,text/plain",
                               ".csv")),
          #verbatimTextOutput("text"),
          # Horizontal line ----
          tags$hr()
      ),
         
      # Show a plot of the generated distribution
      mainPanel(
          h3('Data Display'),
          verbatimTextOutput("text")
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    readthedata <- reactive({
        req(input$file1)
        filePath <- input$file1$datapath
        df <- paste(readLines(filePath), collapse="\n")
        df
    })
    output$text <- renderText({ # rendered so can be highlighted
        readthedata()
    })
   
    
   

}

# Run the application 
shinyApp(ui = ui, server = server)

