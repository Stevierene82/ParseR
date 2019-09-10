#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)

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
          #verbatimTextOutput("text")
          tags$hr(),
          downloadButton("downloadData", "Download")
      ),
         
      mainPanel(
          h3('Data Display'),
          verbatimTextOutput("test"),
          
          tableOutput("table")
          
      )
   )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    readthedata <- reactive({
        req(input$file1)
        filePath <- input$file1$datapath
        #df <- paste(readLines(filePath), collapse="\n")
        #df
        a <- readr::read_file(filePath)
        a <- unlist(str_split(a, 'THIS IS THE END'))
        b <- grep('^\\r\\n$',a) # find lines with no content
        a <- a[-b] # get rid of those lines
        
        df <- data.frame('raw'=a)
        df$raw <- as.character(df$raw)
        df
    })
    
    parse_info <- function(){
        df <- readthedata()
        df$interest <- str_extract_all(df$raw,'interest.*\r\n')
        df$interest <- gsub('interest: *|\r\n','',df$interest) # get the interest
        df$color <- str_extract_all(df$raw,'color.*\r\n')      
        df$color <- gsub('color: *|\r\n','',df$color) # get the color
        df$date <- str_extract_all(df$raw,'\\d{1,2}\\/\\d{1,2}\\/\\d{2,4}') # get date
        df$date <- as.Date(as.character(df$date)) # fix this format
        df <- as.data.frame(df)
        df
    }
    
    output$test <- renderPrint({
        
        sapply(parse_info(),class)
    })

    output$table <- renderTable({ # rendered so can be highlighted
        parse_info()
    })
    
    asdf <- data.frame('a'=1:3,'b'=4:6)
    
    output$downloadData <- downloadHandler(
        filename = function() {
            paste(input$downloadData, ".txt", sep = "")
        },
        content = function(file) {
            write.csv(parse_info(), file, row.names = FALSE)
        }
    )
    
   

}

# Run the application 
shinyApp(ui = ui, server = server)

