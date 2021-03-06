library(shiny)

# vars <- list(currWk=8,
#              numWks=4
#              )

# source('D:/workbin/BigData/NFLScrape/nflTeamBoxscoreFunctions.r')
# source('D:/workbin/BigData/NFLScrape/nflTeamBoxscoreStats.r')
# source('D:/workbin/BigData/NFLScrape/nflTeamBoxscoreAnalysis.r')

# numPastWks <- 4
# currWk <- 8

source('nflTeamBoxscoreFunctions.r')
source('nflTeamBoxscoreStats.r')
source('nflTeamBoxscoreAnalysis.r')



#CREDIT: https://shiny.rstudio.com/gallery/

# Define UI for data download app ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("2018 NFL Regular Season Wk 10 Outlook based on Wk 5-9"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Choose dataset ----
      selectInput("dataset", "Choose a report:",
                  choices = c("Boxscore Details", "All Ranking",
                              "Avg Ranking - Passing",
                              "Avg Ranking - Rushing",
                              "Avg Ranking - Defense",
                              "Avg Ranking - Defense BX",
                              "Avg Ranking - Defense DB",
                              "Avg Ranking - Kicker",
                              "SnapCounts")),
      
      # Button
      downloadButton("downloadData", "Download")
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      tableOutput("table")
      
    )
  )
)

# Define server logic to display and download selected file ----
server <- function(input, output) {
  
  # Reactive value for selected dataset ----
  datasetInput <- reactive({
    switch(input$dataset,
           "Boxscore Details" = priorWks,
           "All Ranking" = thisWkRank,
           "Avg Ranking - Passing"=thisWkRankAvg[order(thisWkRankAvg$QBWRTE),],
           "Avg Ranking - Rushing"=thisWkRankAvg[order(thisWkRankAvg$RB),],
           "Avg Ranking - Defense"=thisWkRankAvg[order(thisWkRankAvg$DEF),],
           "Avg Ranking - Defense BX"=thisWkRankAvg[order(thisWkRankAvg$DLLB),],
           "Avg Ranking - Defense DB"=thisWkRankAvg[order(thisWkRankAvg$DB),],
           "Avg Ranking - Kicker"=thisWkRankAvg[order(thisWkRankAvg$KR),],
           "SnapCounts"=snapcounts2018
           )
  })
  
  # Table of selected dataset ----
  output$table <- renderTable({
    datasetInput()
  })
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    filename = function() {
      paste(input$dataset, ".csv", sep = "")
    },
    content = function(file) {
      write.csv(datasetInput(), file, row.names = FALSE)
    }
  )
  
}

# Create Shiny app ----
shinyApp(ui, server)

