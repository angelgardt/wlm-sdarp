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

# Define UI for application that draws a histogram
ui <- page_navbar(

    # Application title
    title = "Биномиальное распределение // WLM SDARP",
    
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
    
    
    nav_panel("Асимптотика Муавра — Лапласа",
              plotOutput("bernoulliPlot1"),
              plotOutput("binomLaplasPlot")),
    
    nav_panel("Асимптотика Пуассона",
              plotOutput("bernoulliPlot2"),
              plotOutput("binomPoisPlot"))
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  
  output$bernoulliPlot1 <- renderPlot({
      ggplot(NULL,
             aes(c("0 (неудача)", "1 (успех)"), c(1-input$p, input$p))) +
      geom_point(size = input$point_size) +
      ylim(0, 1) +
      labs(x = "Элементарные исходы единичного испытания",
           y = "Вероятность",
           title = paste0("Распределение Бернулли (Bernoulli Distribution) (p = ", 
                          input$p, ")"))
  })
  
  output$bernoulliPlot2 <- renderPlot({
    ggplot(NULL,
           aes(c("0 (неудача)", "1 (успех)"), c(1-input$p, input$p))) +
      geom_point(size = input$point_size) +
      ylim(0, 1) +
      labs(x = "Элементарные исходы единичного испытания",
           y = "Вероятность",
           title = paste0("Распределение Бернулли (Bernoulli Distribution) (p = ", 
                          input$p, ")"))
  })
  
  output$binomLaplasPlot <- renderPlot({
    tibble(k = 1:input$n,
           p_binom = dbinom(k, input$n, input$p)) %>% 
      ggplot(aes(k, p_binom)) +
      geom_function(fun = dnorm, 
                    args = list(mean = input$n*input$p, 
                                sd = sqrt(input$n * input$p * (1 - input$p))),
                    color = input$additional_color,
                    linewidth = input$line_width) +
      geom_point(size = input$point_size) +
      labs(x = "Количество успехов в серии испытаний Бернулии",
           y = "Вероятность",
           title = paste0("Биномиальное распределение (Binomial Distribution) (n = ", 
                          input$n, ", p = ", input$p, ")"),
           caption = "Линия отображает плотность вероятности нормального распределения N(np, np(1-p))"
           )
    })
  
  output$binomPoisPlot <- renderPlot({
    tibble(k = 1:input$n,
           p_binom = dbinom(k, input$n, input$p),
           p_pois = dpois(k, input$n * input$p)) %>% 
      ggplot(aes(k, p_binom)) +
      geom_point(aes(y = p_pois),
                    color = input$additional_color,
                    size = input$point_size + 1) +
      geom_point(size = input$point_size) +
      labs(x = "Количество успехов в серии испытаний Бернулии",
           y = "Вероятность",
           title = paste0("Биномиальное распределение (Binomial Distribution) (n = ", 
                          input$n, ", p = ", input$p, "), λ = ", input$n * input$p),
           caption = "Серые точки отображают распределение Пуассона Pois(λ)"
      )
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
