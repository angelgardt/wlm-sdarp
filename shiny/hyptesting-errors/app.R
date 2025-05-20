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
library(ggplot2)
theme_set(theme_bw())

# Define UI for application
ui <- fluidPage(
  # Application title
  titlePanel(
    "Ошибки I и II рода, уровень значимости, статистическая мощность и размер эффекта"
  ),
  
  # Input area
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "solve.for",
        label = "Вычислить",
        choices = c(
          "Уровень значимости (α)" = "sig.level",
          "Статистическую мощность (1-β)" = "power",
          "Размер эффекта (d)" = "effect.size",
          "Объём выборки (n)" = "sample.size"
        ),
        selected = "power"
      ),
      uiOutput("param_sig.level"),
      uiOutput("param_power"),
      uiOutput("param_effect.size"),
      uiOutput("param_sample.size"),
      radioButtons(
        inputId = "alternative",
        label = "Альтернативная гипотеза (H_1)",
        choices = c(
          "Greater" = "greater",
          "Less" = "less",
          "Two-sided" = "two.sided"
        ),
        selected = "two.sided"
      )
    ),
    
    # Show a plot and table
    mainPanel(
      plotOutput("mainPlot"),
      value_box(title = "Type I Error", value = uiOutput("box_sig.level")),
      value_box(title = "Type II Error", value = uiOutput("box_beta")),
      value_box(title = "Power", value = uiOutput("box_power")),
      value_box(title = "Effect Size", value = uiOutput("box_effect.size")),
      value_box(title = "Sample Size", value = uiOutput("box_sample.size"))
      )
  )
)

# Define server logic
server <- function(input, output) {
  output$param_sig.level <- renderUI({
    if (input$solve.for != "sig.level") {
      sliderInput(
        inputId = "sig.level",
        label = "Уровень значимости (α)",
        min = 0,
        max = 1,
        value = .05
      )
    }
  })
  output$param_power <- renderUI({
    if (input$solve.for != "power") {
      sliderInput(
        inputId = "power",
        label = "Статистическая мощность (1-β)",
        min = 0,
        max = 1,
        value = .8
      )
    }
  })
  output$param_effect.size <- renderUI({
    if (input$solve.for != "effect.size") {
      sliderInput(
        inputId = "effect.size",
        label = "Размер эффекта (d)",
        min = 0,
        max = 1,
        value = .3
      )
    }
  })
  output$param_sample.size <- renderUI({
    if (input$solve.for != "sample.size") {
      sliderInput(
        inputId = "sample.size",
        label = "Объём выборки (n)",
        min = 0,
        max = 300,
        value = 30
      )
    }
  })
  
  output$box_sig.level <- renderText({
    input$sig.level
  })
  output$box_beta <- renderText({
    "beta"
  })
  output$box_power <- renderText({
    "power"
  })
  output$box_effect.size <- renderText({
    "effect size"
  })
  output$box_sample.size <- renderText({
    "sample size"
  })
  
  output$mainPlot <- renderPlot({
    z_h1 <- input$effect.size * sqrt(input$sample.size)
    
    graph <- ggplot(NULL) +
      stat_function(fun = dnorm) +
      stat_function(fun = dnorm, args = list(mean = z_h1)) +
      labs(x = "z", y = "Density")
    
    if (input$alternative == "greater") {
      graph +
        stat_function(
          fun = dnorm,
          geom = "area",
          xlim = c(qnorm(1 - input$sig.level), 4),
          fill = "red",
          alpha = .5
        ) +
        geom_vline(xintercept = qnorm(1 - input$sig.level),
                   linetype = "dotted") +
        xlim(-4, 4)
    } else if (input$alternative == "less") {
      graph +
        stat_function(
          fun = dnorm,
          geom = "area",
          xlim = c(-4, qnorm(input$sig.level)),
          fill = "red",
          alpha = .5
        ) +
        geom_vline(xintercept = qnorm(input$sig.level),
                   linetype = "dotted") +
        xlim(-4, 4)
    } else {
      graph +
        stat_function(
          fun = dnorm,
          args = list(mean = z_h1),
          geom = "area",
          xlim = c(qnorm(input$sig.level / 2), qnorm(1 - input$sig.level / 2)),
          fill = "blue",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          args = list(mean = z_h1),
          geom = "area",
          xlim = c(qnorm(1 - input$sig.level / 2), 4),
          fill = "cyan",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          geom = "area",
          xlim = c(-4, qnorm(input$sig.level / 2)),
          fill = "red",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          geom = "area",
          xlim = c(qnorm(1 - input$sig.level / 2), 4),
          fill = "red",
          alpha = .5
        ) +
        geom_vline(xintercept = c(qnorm(input$sig.level / 2), qnorm(1 - input$sig.level / 2)),
                   linetype = "dotted") +
        xlim(-4, 4)
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
