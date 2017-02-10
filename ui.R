library(ggvis)

# For dropdown menu
actionLink <- function(inputId, ...) {
  tags$a(href='javascript:void',
         id=inputId,
         class='action-button',
         ...)
}

fluidPage(
  titlePanel("MaÅ”inÅ³ nuoma"),
  fluidRow(
    column(3,
           wellPanel(
             h4("Filtras"),
             
             sliderInput("Menuo", "MÄnuo", 1, 12, value = c(1, 12), step = 1),
            
             sliderInput("Liko_dienu", "Liko dienÅ³",
                         0, 350, c(0, 350), step = 10),
             sliderInput("Price", "Kaina", 1, 800, value = c(1, 800), step = 1)
                            
             ),
             wellPanel(
             selectInput("xvar", "X-aÅ”ies kintamasis", axis_vars, selected = "Menuo"),
             selectInput("yvar", "Y-aÅ”ies kintamasis", axis_vars, selected = "Price"),
             tags$small(paste0(
                ))
           )
    ),
    column(9,
           ggvisOutput("plot1"),
           wellPanel(
             span("AtvejÅ³ skaiÄius:",
                  textOutput("n_cars")
             )
           )
    )
  )
)
