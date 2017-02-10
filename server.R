library(ggvis)
library(dplyr)
library(foreign)

all_cars <- read.spss("Automobiliunuoma4.sav", to.data.frame=TRUE)
#View(all_cars)

function(input, output, session) {
  
  # Filter the movies, returning a data frame
  cars <- reactive({
    # Due to dplyr issue #318, we need temp variables for input values
    minMenuo <- input$Menuo[1]
    maxMenuo <- input$Menuo[2]
    minLiko_dienu <- input$Liko_dienu[1] 
    maxLiko_dienu <- input$Liko_dienu[2] 
    minPrice <- input$Price[1] 
    maxPrice <- input$Price[2]
    
    # Apply filters
    m <- delpaso_files_stats_notime %>%
      filter(
        Menuo >= minMenuo,
        Menuo <= maxMenuo,
        Liko_dienu >= minLiko_dienu,
        Liko_dienu <= maxLiko_dienu,
        Price >= minPrice,
        Price <= maxPrice
      ) %>%
      arrange(Terminas)
    
    
    m <- as.data.frame(m)
    
    # Add column which says whether the movie won any Oscars
    # Be a little careful in case we have a zero-row data frame
    m$Terminas <- character(nrow(m))
    m$Terminas[m$Terminas == 21] <- "21"
    m$Terminas[m$Terminas == 28] <- "28"
    m
  })
  
    # A reactive expression with the ggvis plot
  vis <- reactive({
    # Lables for axes
    xvar_name <- names(axis_vars)[axis_vars == input$xvar]
    yvar_name <- names(axis_vars)[axis_vars == input$yvar]
    
    # Normally we could do something like props(x = ~BoxOffice, y = ~Reviews),
    # but since the inputs are strings, we need to do a little more work.
    xvar <- prop("x", as.symbol(input$xvar))
    yvar <- prop("y", as.symbol(input$yvar))

    
    all_values <- function(x) {
      if(is.null(x)) return(NULL)
      row <- delpaso_files_stats_notime[delpaso_files_stats_notime$id == x$id, ]
      paste0(names(row), ": ", format(row), collapse = "<br />")
    }
    
    
    cars %>%
      ggvis(x = xvar, y = yvar, key := ~id) %>%
      layer_points(size := 50, size.hover := 200,
                   fillOpacity := 0.2, fillOpacity.hover := 0.5,
                   #  stroke = ~Terminas, key := ~ID) %>%
                    stroke = ~Terminas) %>%
      
      

      
      
      
      
      add_tooltip(all_values, "hover") %>%
      add_axis("x", title = xvar_name) %>%
      add_axis("y", title = yvar_name) %>%
      add_legend("stroke", title = "Koks terminas?", values = c("21", "28")) %>%
      scale_nominal("stroke", domain = c("21", "28"),
                    range = c("orange", "#aaa")) %>%
      set_options(width = 500, height = 500)
  })
  
  vis %>% bind_shiny("plot1")
  
  output$n_cars <- renderText({ nrow(cars()) })
}
