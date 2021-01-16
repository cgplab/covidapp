# covidapp: predict probability of admission to ICU for patients with COVID-19

This app calculates the probability of admission to ICU for COVID-19 patients based on three models  exploiting blood laboratory-arterial gas analyses, radiological and radiomics parameters.  

## Run the web application

To run the web application, first install the Shiny R package using

``` r
install.packages("shiny")
```

then, you can launch the Shiny web application using

``` r
shiny::runGitHub("cgplab/covidapp", ref = "main")
```

## Citation

The manuscript describing the study and the models is currently under revision. The preprint is available at https://www.medrxiv.org/content/10.1101/2021.01.08.20249041v1. 
