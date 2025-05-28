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
      uiOutput("param_effect.size.sign"),
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
      uiOutput("settings_sig.level"),
      uiOutput("settings_power"),
      uiOutput("settings_effect.size"),
      uiOutput("settings_sample.size")
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
      value_box(title = "Объём выборки", value = uiOutput("box_sample.size")),
      value_box(title = "Критическое значение", value = uiOutput("box_z.cr")),
      value_box(title = "Наблюдаемое значение", value = uiOutput("box_z.h1"))
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
      if (input$alternative != "less") {
        sliderInput(
          inputId = "effect.size",
          label = "Размер эффекта (d)",
          min = 0,
          max = 1,
          value = .3
        )
      } else {
        sliderInput(
          inputId = "effect.size",
          label = "Размер эффекта (d)",
          min = -1,
          max = 0,
          value = -.3
        )
      }
    }
  })
  output$param_effect.size.sign <- renderUI({
    if (input$solve.for == "effect.size" & input$alternative == "two.sided") {
      checkboxInput(inputId = "effect.size.sign",
                    label = "Отрицательный эффект",
                    value = FALSE)
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
    if (input$solve.for != "sig.level") {
      if (input$settings_btn %% 2 == 1) {
        card(markdown("#### Уровень значимости"),
             layout_columns(
               numericInput(inputId = "sig.level_min", label = "Минимум", value = 0, min = 0, max = 1, step = .01),
               numericInput(inputId = "sig.level_max", label = "Максимум", value = 1, min = 0, max = 1, step = .01),
               numericInput(inputId = "sig.level_step", label = "Шаг", value = .01, min = .001, max = 1, step = .001), 
               )
        )
      }
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
  
  output$settings_power <- renderUI({
    if (input$solve.for != "power") {
      if (input$settings_btn %% 2 == 1) {
        card(markdown("#### Статистическая мощность"),
             layout_columns(
               numericInput(inputId = "power_min", label = "Минимум", value = 0, min = 0, max = 1, step = .01),
               numericInput(inputId = "power_max", label = "Максимум", value = 1, min = 0, max = 1, step = .01),
               numericInput(inputId = "power_step", label = "Шаг", value = .01, min = .001, max = 1, step = .001), 
             )
        )
      }
    }
  })
  observeEvent(input$power_min, {
    updateSliderInput(inputId = "power", min = input$power_min)
  })
  observeEvent(input$power_max, {
    updateSliderInput(inputId = "power", max = input$power_max)
  })
  observeEvent(input$power_step, {
    updateSliderInput(inputId = "power", step = input$power_step)
  })
  
  output$settings_effect.size <- renderUI({
    if (input$solve.for != "effect.size") {
      if (input$settings_btn %% 2 == 1) {
        card(markdown("#### Размер эффекта"),
             layout_columns(
               numericInput(inputId = "effect.size_min", label = "Минимум", value = 0, min = -2, max = 2, step = .01),
               numericInput(inputId = "effect.size_max", label = "Максимум", value = 1, min = -2, max = 2, step = .01),
               numericInput(inputId = "effect.size_step", label = "Шаг", value = .01, min = .001, max = 1, step = .001), 
             )
        )
      }
    }
  })
  observeEvent(input$effect.size_min, {
    updateSliderInput(inputId = "effect.size", min = input$effect.size_min)
  })
  observeEvent(input$effect.size_max, {
    updateSliderInput(inputId = "effect.size", max = input$effect.size_max)
  })
  observeEvent(input$effect.size_step, {
    updateSliderInput(inputId = "effect.size", step = input$effect.size_step)
  })
  
  output$settings_sample.size <- renderUI({
    if (input$solve.for != "sample.size") {
      if (input$settings_btn %% 2 == 1) {
        card(markdown("#### Объём выборки"),
             layout_columns(
               numericInput(inputId = "sample.size_min", label = "Минимум", value = 2, min = 2, max = 10000, step = 1),
               numericInput(inputId = "sample.size_max", label = "Максимум", value = 300, min = 2, max = 10000, step = 1)
             )
        )
      }
    }
  })
  observeEvent(input$sample.size_min, {
    updateSliderInput(inputId = "sample.size", min = input$sample.size_min)
  })
  observeEvent(input$sample.size_max, {
    updateSliderInput(inputId = "sample.size", max = input$sample.size_max)
  })
  
  
  ## Validation
  iv <- InputValidator$new()
  iv$add_rule("sig.level_min", sv_gte(0, message_fmt = "Значение должно быть не меньше нуля"))
  iv$add_rule("sig.level_max", sv_lte(1, message_fmt = "Значение должно быть не больше единицы"))
  iv$add_rule("sig.level_step", sv_gt(0, message_fmt = "Значение должно быть больше нуля"))
  iv$enable()
  
  ## Computations
  
  z_h1 <- reactive({
    if (input$solve.for != "effect.size" & input$solve.for != "sample.size") {
      input$effect.size * sqrt(input$sample.size)
    } else if (input$solve.for == "effect.size") {
      ## TODO
      if (input$alternative == "less") {
        z_cr() - qnorm(input$power)
      } else {
        z_cr() - qnorm(input$power, lower.tail = FALSE)
      }
    }
  })
  
  z_cr <- reactive({
  if (input$solve.for != "sig.level") {
    if (input$alternative == "less") {
      qnorm(input$sig.level)
    } else if (input$alternative == "greater") {
      qnorm(1 - input$sig.level)
    } else {
      qnorm(1 - input$sig.level/2)
    }
  } else {
    if (input$alternative == "less") {
      qnorm(input$power, mean = z_h1())
    } else if (input$alternative == "greater") {
      qnorm(input$power, mean = z_h1(), lower.tail = FALSE)
    } else {
      if (input$effect.size < 0) {
        qnorm(input$power, mean = z_h1())
      } else {
        qnorm(input$power, mean = z_h1(), lower.tail = FALSE)
      }
    }
  }
  })
  
  values <- list(sig.level = numeric(1),
                 beta = numeric(1),
                 power = numeric(1),
                 effect.size = numeric(1),
                 sample.size = numeric(1))
  
  values$sig.level <- reactive({
    if (input$solve.for != "sig.level") {
      input$sig.level
    } else {
      if (input$alternative == "less") {
        pnorm(z_cr())
      } else if (input$alternative == "greater") {
        pnorm(z_cr(), lower.tail = FALSE)
      } else {
          pnorm(-z_cr()) * 2
      }
    }
  })
  values$power <- reactive({
    if (input$solve.for != "power") {
      input$power
    } else {
      pnorm(q = z_cr(), mean = z_h1(), lower.tail = FALSE) %>% round(2)
    }
  })
  values$beta <- reactive({
    1 - values$power()
  })
  values$effect.size <- reactive({
    if (input$solve.for != "effect.size") {
      input$effect.size
    } else {
      z_h1() / sqrt(input$sample.size)
    }
  })
  values$sample.size <- reactive({
    if (input$solve.for != "sample.size") {
      input$sample.size
    } else {
      NA
    }
  })
  
  ## Boxes
  output$box_sig.level <- renderText({
    paste0(values$sig.level() %>% round(2) %>% `*`(100), "%")
  })
  output$box_beta <- renderText({
    paste0(values$beta() %>% round(2) %>% `*`(100), "%")
  })
  output$box_power <- renderText({
    paste0(values$power() %>% round(2) %>% `*`(100), "%")
  })
  output$box_effect.size <- renderText({
    paste0(values$effect.size() %>% round(2))
  })
  output$box_sample.size <- renderText({
    paste0(values$sample.size())
  })
  output$box_z.cr <- renderText({
    z_cr() %>% round(2)
  })
  output$box_z.h1 <- renderText({
    z_h1() %>% round(2)
  })
  
  ## Plot
  output$mainPlot <- renderPlot({
    
    graph <- ggplot(NULL) +
      stat_function(fun = dnorm) +
      stat_function(fun = dnorm, args = list(mean = z_h1())) +
      geom_vline(xintercept = z_h1(), linetype = "dashed") +
      labs(x = "z", y = "Density")
    
    if (input$alternative == "greater") {
      graph +
        stat_function(
          fun = dnorm,
          args = list(mean = z_h1()),
          geom = "area",
          xlim = c(-4, z_cr()),
          fill = "blue",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          args = list(mean = z_h1()),
          geom = "area",
          xlim = c(z_cr(), 4),
          fill = "cyan",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          geom = "area",
          xlim = c(z_cr(), 4),
          fill = "red",
          alpha = .5
        ) +
        geom_vline(xintercept = z_cr(),
                   linetype = "dotted") +
        xlim(-4, 4)
    } else if (input$alternative == "less") {
      graph +
        stat_function(
          fun = dnorm,
          args = list(mean = z_h1()),
          geom = "area",
          xlim = c(z_cr(), 4),
          fill = "blue",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          args = list(mean = z_h1()),
          geom = "area",
          xlim = c(-4, z_cr()),
          fill = "cyan",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          geom = "area",
          xlim = c(-4, z_cr()),
          fill = "red",
          alpha = .5
        ) +
        geom_vline(xintercept = z_cr(),
                   linetype = "dotted") +
        xlim(-4, 4)
    } else {
      graph +
        stat_function(
          fun = dnorm,
          args = list(mean = z_h1()),
          geom = "area",
          xlim = c(-z_cr(), z_cr()),
          fill = "blue",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          args = list(mean = z_h1()),
          geom = "area",
          xlim = c(z_cr(), 4),
          fill = "cyan",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          geom = "area",
          xlim = c(-4, -z_cr()),
          fill = "red",
          alpha = .5
        ) +
        stat_function(
          fun = dnorm,
          geom = "area",
          xlim = c(z_cr(), 4),
          fill = "red",
          alpha = .5
        ) +
        geom_vline(xintercept = c(-z_cr(), z_cr()),
                   linetype = "dotted") +
        xlim(-4, 4)
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
