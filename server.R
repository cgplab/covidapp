library(shiny)
library(glmnet)
library(rhandsontable)
options(shiny.sanitize.errors = FALSE)


shinyServer(function(input, output) {
  # 
  load("data/glmnet_models_201113.rda")
  load("data/features_glmnet_models_201113.rda")
  
  DF <- readRDS("data/init.rds")

  rnd <- gsub(" ", "0", format(sample( 1:1e5, 1), width = 6))
  format_systime <- format(Sys.time(),'%Y%m%d_%H%M%S')
  logid <- paste0(format_systime, "_", rnd)
  values <- reactiveValues()
  
  
  ## Handsontable
  observe({
    if (!is.null(input$hot)) {
      DF = hot_to_r(input$hot)
    } else {
      if (is.null(values[["DF"]]))
        DF <- DF
      else
        DF <- values[["DF"]]
    }
    values[["DF"]] <- DF
  })
  # 
  output$hot <- renderRHandsontable({
    DF <- values[["DF"]]
    my_colnames <- c("Patient ID", "Age", "P/F (mmHg)", "LDH (UI/L)", "Fraction consolidated lung",
                     gsub(".original", "", colnames(DF)[6:8])
                     )
    if (!is.null(DF) ) {
      rhandsontable(DF, useTypes = T, stretchH = "all", colHeaders = my_colnames)
    }

  })
  
  observeEvent(input$calc_pred, {
    DF = hot_to_r(input$hot)
    DF <- values[["DF"]]

    probs_clinical <- predict(glmnet_clinical,
                              newx = as.matrix(DF[, features_clinical]),
                              type = "response",
                              s = "lambda.min"
                              )
    probs_clinical_radiol <- predict(glmnet_clinical_radiological,
                                     newx = as.matrix(DF[, features_clinical_radiological]),
                                     type = "response",
                                     s = "lambda.min"
    )
    probs_clinical_radiol_radiom <- predict(glmnet_clinical_radiological_radiomics,
                                            newx = as.matrix(DF[, features_clinical_radiological_radiomics]),
                                            type = "response",
                                            s = "lambda.min"
    )
    
    # pred_clinical <- ifelse(probs_clinical > roc_training_clinical$thr, "yes", "no")
    # pred_clinical_radiol <- ifelse(probs_clinical_radiol > roc_training_clinical_radiological$thr, "yes", "no")
    # pred_clinical_radiol_radiom <- ifelse(probs_clinical_radiol_radiom > roc_training_clinical_radiological_radiomics$thr, "yes", "no")


    DF_out <- data.frame(Patient_ID=DF$Patient_ID,
                         `blood laboratory-arterial gas analysis`=format(probs_clinical, digits = 2),
                         `Hybrid radiological`=format(probs_clinical_radiol, digits = 2),
                         `Hybrid radiomics`=format(probs_clinical_radiol_radiom, digits = 2)
    )

#     DF_out_classes <- data.frame(Patient_ID=DF$Patient_ID,
#                                  `Clinical-laboratory-arterial gas analysis (prob)`=probs_clinical,
# #                                 `Clinical-laboratory-arterial gas analysis (risk)`=class_clinical,
#                                  `Hybrid radiological (prob)`=probs_clinical_radiol,
# #                                 `Hybrid radiological (risk)`=class_clinical_radiol,
#                                  `Hybrid radiomics (prob)`=probs_clinical_radiol_radiom,
# #                                 `Hybrid radiomics (risk)`=class_clinical_radiol_radiom
#     )
    
    output$model_out <- renderRHandsontable({
      my_colnames <- c("Patient ID",
                    "blood laboratory-arterial gas analysis",
                    "Hybrid radiological",
                    "Hybrid radiomics"
                    
                    )
      
      rhandsontable(DF_out, 
                    readOnly = T, 
                    #stretchH = "all", 
                    colHeaders = my_colnames
                    )
      


    })
    
  })
  
  
  
  
  
})
