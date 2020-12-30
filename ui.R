library(shiny)
library(rhandsontable)

manuscript <- a("manuscript", href="https://www.google.com/")

shinyUI(fluidPage(
  
  # Navigation prompt
  tags$head(tags$script(HTML("
                             // Enable navigation prompt
                             window.onbeforeunload = function() {
                             return 'Your changes will be lost!';
                             };
                             "))),

  titlePanel( div(column(width = 6, h2("Predict ICU admission for COVID-19 patients")), 
                  column(width = 6, 
                         # tags$a(
                         #   href="https://www.uslcentro.toscana.it", 
                         #   tags$img(src="Logo_Servizio_Sanitario_della_Toscana.jpg", 
                         #            title="USLTC", 
                         #            align="right",
                         #            height="80")
                         # ),
                         tags$a(
                           href="https://github.com/cgplab", 
                           tags$img(src="cgplab.png", 
                                    title="Cancer Genomics Prato Lab", 
                                    align="right",
                                    height="80")
                         ))
  ),
  windowTitle="covidapp"),
  

  br(),
  
  br(),
  sidebarLayout(
    sidebarPanel(
      wellPanel(
        h4("Usage"), 
        helpText("This app calculates the probability of admission to ICU",
                  "for COVID-19 patients",
                  " based on three models ", 
                 " exploiting blood laboratory-arterial gas analyses, ", 
                 "radiological and ",
                 "radiomics parameters.",
                 br()
                 ),
        helpText("Right-click on the table to delete/insert rows.", br(), 
               "Double-click on a cell to edit. ", br(), br(),
               "Click on", tags$b("Calculate"), 
               "to run the three models. "),
        
        helpText("For more details about the study and models see", br(), 
                 "the", manuscript, "(preprint, under revision)" )
      ),
      br(), 
      
      wellPanel(
        h4("Predict ICU"), 
        helpText("Calculate risk of ICU admission based on three models: ", br(), br(),
                 tags$b("blood laboratory-arterial gas analysis"), ": age, P/F, LDH", br(),
                 tags$b("Hybrid radiological"), ": age, P/F, LDH, percentage consolidated lung (CT)", br(),
                 tags$b("Hybrid radiomics"), ": P/F, LDH, percentage consolidated (CT), 3 radiomic features 
                 (LargeDependenceLowGrayLevelEmphasis, RunLengthNonUniformity, LowGrayLevelZoneEmphasis)"
        ), br(),
        actionButton("calc_pred", "Calculate")
      ),
      
      br()
      
    #   ,
    #   wellPanel(
    #     h4("Credits"),
    #     helpText(tags$b("Study design"), ": Maurizio Bartolucci", br(),
    #              tags$b("Data collection (clinical)"), ": XX, XX", br(),
    #              tags$b("Data collection (radiological)"), ": Margherita Betti, Luca Fedeli", br(),
    #              tags$b("Radiological evaluation and analyses"), ": Maurizio Bartolucci, Margherita Betti, Luca Fedeli", br(),
    #              tags$b("Radiomic analyses, model building and evaluation"), ": Matteo Benelli", br(),
    #              tags$b("App development and testing"), ": Matteo Benelli", br(),
    #              tags$b("Study supervision"), ": Maurizio Bartolucci, Matteo Benelli, Mario Mascalchi", br()
    #     )    )
    #   
    ),
    
    mainPanel(
      h4("Input data"),
      br(),
      rHandsontableOutput("hot"), 
      br(),
      h4("Risk of ICU admission"),
      br(),
      rHandsontableOutput("model_out")
    )
  )
))
