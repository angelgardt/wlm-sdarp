#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(tidyverse)
theme_set(theme_bw())
library(latex2exp)

ui <- page_navbar(
  
  # Application title
  title = "Стандартизация случайных величин // WLM SDARP",
  
  sidebar = sidebar(
    title = "Параметры",
    sliderInput(
      "n",
      label = TeX("n"),
      min = 1,
      max = 500,
      value = 30
    ),
    sliderInput(
      "p",
      label = "p",
      min = 0,
      max = 1,
      value = .5
    ),
    sliderInput(
      "point_size",
      label = "Размер точек",
      min = 1,
      max = 5,
      value = 2
    ),
    sliderInput(
      "line_width",
      label = "Ширина линий",
      min = 1,
      max = 5,
      value = 1
    ),
    textInput(
      "additional_color",
      label = "Дополнительный цвет",
      value = "gray"
    )
  ),
  
  nav_panel("Стандартизация"),
  
  nav_panel("Свойства среднего и дисперсии")
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
