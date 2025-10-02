#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(tidyverse)
theme_set(theme_bw())
library(bslib)

# Define UI
ui <- fluidPage(

    # Application title
    titlePanel("Стандартизация"),

    # Sidebar
    sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "distform",
                      label = "Форма распределения",
                      choices = c(
                        "Нормальное" = "norm",
                        "Левосторонняя асимметрия" = "leftskew",
                        "Правосторонняя асимметрия" = "rightskew",
                        "Бимодальное" = "bimod"), 
                      selected = "norm"),
          card(markdown("#### Параметры распределения"),
               layout_column_wrap(
                 numericInput(inputId = "mean", label = "Среднее", value = 2),
                 numericInput(inputId = "sd", label = "Стандартное отклонение", value = 2)
               )
          ),
          card(markdown("#### Операции стандартизации"),
               layout_column_wrap(
                 checkboxInput(inputId = "centring", label = "Центрирование", value = FALSE),
                 checkboxInput(inputId = "norming", label = "Нормирование", value = FALSE)
                 )
               ),
          actionButton("settings_btn", label = "Показать настройки", icon = icon("gear")),
          uiOutput("settings_set.seed"),
          uiOutput("settings_nbins")
        ),

        # Show a plot
        mainPanel(
          tabsetPanel(id = "tabset",
            tabPanel(title = "Распределение",
                     plotOutput("distPlot")
                     ),
            tabPanel(title = "Симуляция",
                     plotOutput("simPlot")
                     )
          )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  ## Settings
  observeEvent(input$settings_btn, {
    if (input$settings_btn %% 2 == 1) {
      updateActionButton(inputId = "settings_btn", label = "Скрыть настройки")
    } else {
      updateActionButton(inputId = "settings_btn", label = "Показать настройки")
    }
  })
  output$settings_set.seed <- renderUI({
    if (input$settings_btn %% 2 == 1 & input$tabset == "Симуляция") {
      numericInput(inputId = "set.seed", label = "Зерно датчика случайных чисел", value = NULL, min = 0, step = 1)
    }
  })
  output$settings_nbins <- renderUI({
    if (input$settings_btn %% 2 == 1 & input$tabset == "Симуляция") {
      numericInput(inputId = "nbins", label = "Количество стобцов гистограммы", value = 30, min = 1, step = 1)
    }
  })
  
  ## Plots
  output$distPlot <- renderPlot({
    if (input$centring & input$norming) {
      ggplot(NULL) +
        stat_function(fun = dnorm, linetype = "dashed") +
        stat_function(fun = dnorm, args = list(mean = 0, sd = 1),
                      color = "blue") +
        stat_function(fun = dnorm, args = list(mean = input$mean, sd = input$sd),
                      color = "blue", linetype = "dashed") +
        xlim(-5, 5)
    } else if (input$centring) {
      ggplot(NULL) +
        stat_function(fun = dnorm, linetype = "dashed") +
        stat_function(fun = dnorm, args = list(mean = input$mean, sd = input$sd),
                      color = "blue", linetype = "dashed") +
        stat_function(fun = dnorm, args = list(mean = 0, sd = input$sd),
                      color = "blue") +
        xlim(-5, 5)
    } else if (input$norming) {
      ggplot(NULL) +
        stat_function(fun = dnorm, linetype = "dashed") +
        stat_function(fun = dnorm, args = list(mean = input$mean, sd = input$sd),
                      color = "blue", linetype = "dashed") +
        stat_function(fun = dnorm, args = list(mean = input$mean, sd = 1),
                      color = "blue") +
        xlim(-5, 5)
    } else {
      ggplot(NULL) +
        stat_function(fun = dnorm, linetype = "dashed") +
        stat_function(fun = dnorm, args = list(mean = input$mean, sd = input$sd),
                      color = "blue") +
        xlim(-5, 5)
      
    }
  })
  
  ds <- reactive({
    if (!is.null(input$set.seed)) { if(!is.na(input$set.seed)) { set.seed(input$set.seed) }}
    tibble(x = rnorm(1000, mean = input$mean, sd = input$sd),
           x_cent = scale(x, center = TRUE, scale = FALSE),
           x_norm = scale(x, center = FALSE, scale = TRUE),
           x_stand = scale(x, center = TRUE, scale = TRUE))
  })
  
  output$simPlot <- renderPlot({
    nbins <- reactive({ if (is.null(input$nbins)) {30} else {input$nbins} })
    
    if (input$centring & input$norming) {
      ggplot(ds()) +
        stat_function(fun = dnorm, linetype = "dashed") +
        geom_density(aes(x), color = "blue", linetype = "dashed") +
        geom_histogram(aes(x_stand, y = ..density..), alpha = .5, bins = nbins()) +
        geom_density(aes(x_stand), color = "blue")
    } else if (input$centring) {
      ggplot(ds()) +
        stat_function(fun = dnorm, linetype = "dashed") +
        geom_density(aes(x), color = "blue", linetype = "dashed") +
        geom_histogram(aes(x_cent, y = ..density..), alpha = .5, bins = nbins()) +
        geom_density(aes(x_cent), color = "blue")
    } else if (input$norming) {
      ggplot(ds()) +
        stat_function(fun = dnorm, linetype = "dashed") +
        geom_density(aes(x), color = "blue", linetype = "dashed") +
        geom_histogram(aes(x_norm, y = ..density..), alpha = .5, bins = nbins()) +
        geom_density(aes(x_norm), color = "blue")
    } else {
      ggplot(ds()) +
        stat_function(fun = dnorm, linetype = "dashed") +
        geom_histogram(aes(x, y = ..density..), alpha = .5, bins = nbins()) +
        geom_density(aes(x), color = "blue")
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
