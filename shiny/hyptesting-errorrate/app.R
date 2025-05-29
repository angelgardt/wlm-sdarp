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
library(ggmosaic)
library(latex2exp)

# Define UI for application
ui <- fluidPage(
  
  # Application title
  titlePanel("Ошибки I и II рода"),
  
  # Sidebar with a slider input
  sidebarLayout(
    sidebarPanel(
      sliderInput(
        inputId = "h1",
        label = "Вероятность справедливости альтернативной гипотезы",
        min = 0,
        max = 1,
        value = .5,
        step = .01
    ),
    sliderInput(
      inputId = "sig.level",
      label = "Уровень значимости",
      min = 0,
      max = 1,
      value = .05,
      step = .01
      ),
    sliderInput(
      inputId = "power",
      label = "Статистическая мощность",
      min = 0,
      max = 1,
      value = .8,
      step = .01
    )
    ),
  
  # Show a plot
  mainPanel(
    layout_column_wrap(
      value_box(title = "TN", value = uiOutput("box_tn")),
      value_box(title = "FP", value = uiOutput("box_fp")),
      value_box(title = "FN", value = uiOutput("box_fn")),
      value_box(title = "TP", value = uiOutput("box_tp"))
    ),
    plotOutput("tablePlot")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  values <- list(tn = numeric(1),
                 fp = numeric(1),
                 fn = numeric(1),
                 tp = numeric(1))
  values$tn <- reactive({ (1 - input$sig.level) * (1 - input$h1) })
  values$fp <- reactive({ input$sig.level * (1 - input$h1) })
  values$fn <- reactive({ (1 - input$power) * input$h1 })
  values$tp <- reactive({ input$power * input$h1 })
  output$box_tn <- renderText({
    paste0(values$tn() %>% round(3) %>% `*`(100), "%")
  })
  output$box_fp <- renderText({
    paste0(values$fp() %>% round(3) %>% `*`(100), "%")
  })
  output$box_fn <- renderText({
    paste0(values$fn() %>% round(3) %>% `*`(100), "%")
  })
  output$box_tp <- renderText({
    paste0(values$tp() %>% round(3) %>% `*`(100), "%")
  })
  output$tablePlot <- renderPlot({
    tibble(
      pplt = rep(c("H0", "H1"), each = 2) %>% factor(levels = c("H0", "H1"), ordered = TRUE),
      smpl = rep(c("H0^", "H1^"), times = 2) %>% factor(levels = c("H1^", "H0^"), ordered = TRUE),
      infer = c(TRUE, FALSE, FALSE, TRUE),
      prob = c(
        TN = values$tn(),
        FP = values$fp(),
        FN = values$fn(),
        TP = values$tp()
      )
    ) %>%
      ggplot() +
      geom_mosaic(aes(
        x = product(pplt),
        fill = smpl,
        weight = prob),
        show.legend = FALSE
        ) +
      theme_mosaic() +
      scale_x_productlist(position = "top", 
                          labels = TeX(c(r"($H_0$)", r"($H_1$)"))) +
      scale_y_productlist(labels = TeX(c(r"($\hat{H}_1$)", r"($\hat{H}_0$)"))) +
      scale_fill_manual(values = c("salmon", "royalblue")) +
      # labs(x = "Генеральная совокупность",
      #      y = "Выборка") +
      theme(axis.text.x = element_text(size = 20),
            axis.text.y = element_text(size = 20),
            axis.title = element_text(size = 0))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
