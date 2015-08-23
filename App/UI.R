# Define UI 
shinyUI(fluidPage(
  # Application title
  titlePanel(strong("WordSmith")),
  h4("Text Completion Application for Data Science Capstone"),
  hr(style = "color:#00008B"),
  mainPanel(
    tabsetPanel(
      tabPanel("Text Completion Algorithm", 
               fluidRow( 
                 column(5, 
                        br(),
                        strong("Input text box"),
                        br(),
                        br(),
                        tags$textarea(id="wt_1", rows=5, cols=40, ""),
                        uiOutput("Dynamic"),
                        hr(style = "color:#00008B"),
                        strong("Processing time"),
                        textOutput('time'),
                        strong("Matches"),
                        textOutput('tetracnts'),
                        textOutput('tricnts'),
                        textOutput('bicnts'),
                        textOutput('unicnts')
                        
                 ),
                 column(2, offset = 1,
                        br(),
                        strong("Word Probs:",  style = "color:#202020 "),
                        br(),
                        br(),
                        uiOutput("matrix")
                 )
               )
      ), 
      tabPanel("About", 
               fluidRow( 
                 column(8, br(),
                        strong("The Algorithm"),
                        p("- WordSmith randomly samples over 500 MB of text scraped from news sites, blogs and twitter."),
                        p("- The input data are then cleaned, removing profanity and sparse terms."),
                        p("- Word sequences are stored in hash tables (using data.table and spooky.32), which make WordSmith memory efficient and fast."),
                        p("- Next, WordSmith uses a Markov process based on a modified Stupid Backoff algorithm (Brants 2007). It considers single, double, triple and quadruple word sequences (4-grams to 1-grams) that match the input, then calculates the probability for all potential completion words (MLE). Then it sums all N-gram collections (1 to k) to obtain a weight (W)."),
                        p("- Finally, it provides information on the number of word sequences that match the input and the weighted probabilities of its suggestions."),
                        br(),
                        strong('Developed by Jonathan Hill, 2015'),
                        br(),
                        a("More information - Rpubs", href="http://rpubs.com/Dripdrop12/103950"),
                        br(),
                        a("GitHub", href="https://github.com/Dripdrop12/Data-Science-Capstone")
                 )
               )
      )
    )
  )
)
)