#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinyvalidate)
library(bslib)
library(tidyverse)
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
      ## Solve for
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
      ## Params
      uiOutput("param_sig.level"),
      uiOutput("param_power"),
      uiOutput("param_effect.size"),
      uiOutput("param_sample.size"),
      radioButtons(
        inputId = "alternative",
        label = "Альтернативная гипотеза",
        choices = c(
          "Левосторонняя" = "less",
          "Правосторонняя" = "greater",
          "Двусторонняя" = "two.sided"
        ),
        selected = "two.sided"
      ),
      ## Settings
      actionButton("settings_btn", label = "Показать настройки", icon = icon("gear")),
      uiOutput("settings_sig.level")
    ),
    
    # Show a plot and values
    card(
      navset_card_tab(
        nav_panel(title = "z", plotOutput("mainPlot")),
        #nav_panel(title = "d", "PLOT")
        ),
    layout_column_wrap(
      value_box(title = "Ошибка I рода", value = uiOutput("box_sig.level")),
      value_box(title = "Ошибка II рода", value = uiOutput("box_beta")),
      value_box(title = "Статистическая мощность", value = uiOutput("box_power")),
      value_box(title = "Размер эффекта", value = uiOutput("box_effect.size")),
      value_box(title = "Объём выборки", value = uiOutput("box_sample.size"))
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  ## Params
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
        min = 2,
        max = 300,
        value = 30,
        step = 1
      )
    }
  })
  
  ## Settings
  observeEvent(input$settings_btn, {
    if (input$settings_btn %% 2 == 1) {
      updateActionButton(inputId = "settings_btn", label = "Скрыть настройки")
    } else {
      updateActionButton(inputId = "settings_btn", label = "Показать настройки")
    }
  })
  output$settings_sig.level <- renderUI({
    if (input$settings_btn %% 2 == 1) {
      card(markdown("#### Уровень значимости"),
           layout_columns(
             numericInput(inputId = "sig.level_min", label = "Минимум", value = 0, min = 0, max = 1, step = .01),
             numericInput(inputId = "sig.level_max", label = "Максимум", value = 1, min = 0, max = 1, step = .01),
             numericInput(inputId = "sig.level_step", label = "Шаг", value = .01, min = .001, max = 1, step = .001), 
             )
      )
    }
  })
  observeEvent(input$sig.level_min, {
    updateSliderInput(inputId = "sig.level", min = input$sig.level_min)
  })
  observeEvent(input$sig.level_max, {
    updateSliderInput(inputId = "sig.level", max = input$sig.level_max)
  })
  observeEvent(input$sig.level_step, {
    updateSliderInput(inputId = "sig.level", step = input$sig.level_step)
  })
  
  
  ## Validation
  iv <- InputValidator$new()
  iv$add_rule("sig.level_min", sv_gte(0, message_fmt = "Значение должно быть не меньше нуля"))
  iv$add_rule("sig.level_max", sv_lte(1, message_fmt = "Значение должно быть не больше единицы"))
  iv$add_rule("sig.level_step", sv_gt(0, message_fmt = "Значение должно быть больше нуля"))
  iv$enable()
  
  ## Computations
  
  z_h1 <- reactive(input$effect.size * sqrt(input$sample.size))
  z_cr <- reactive(qnorm(1 - input$sig.level/2))
  
  
  ## Boxes
  output$box_sig.level <- renderText({
    if (input$solve.for != "sig.level") {
      paste0(input$sig.level * 100, "%")
    } else {
      "should solve"
    }
  })
  output$box_beta <- renderText({
    pnorm(q = z_cr(), mean = z_h1()) %>% round(2)
  })
  output$box_power <- renderText({
    if (input$solve.for != "power") {
      input$power
    } else {
      "should solve"
    }
  })
  output$box_effect.size <- renderText({
    if (input$solve.for != "effect.size") {
      input$effect.size
    } else {
      "should solve"
    }
  })
  output$box_sample.size <- renderText({
    if (input$solve.for != "sample.size") {
      input$sample.size
    } else {
      "should solve"
    }
  })
  
  ## Plot
  output$mainPlot <- renderPlot({
    z_h1 <- 2
    
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
