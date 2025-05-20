#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(ggplot2)
theme_set(theme_bw())

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Ошибки I и II рода, уровень значимости, статистическая мощность и размер эффекта"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput(inputId = "sig.level",
                        label = "Уровень значимости (α)",
                        min = 0,
                        max = 1,
                        value = .05),
            sliderInput(inputId = "effect.size",
                        label = "Размер эффекта (d)",
                        min = 0,
                        max = 1,
                        value = .3),
            sliderInput(inputId = "sample.size",
                        label = "Объём выборки (n)",
                        min = 0,
                        max = 300,
                        value = 30),
            radioButtons(inputId = "alternative",
                         label = "Альтернативная гипотеза (H_1)",
                         choices = c("Greater" = "greater",
                                     "Less" = "less",
                                     "Two-sided" = "two.sided"),
                         selected = "two.sided")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("mainPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$mainPlot <- renderPlot({
    z_h1 <- input$effect.size * sqrt(input$sample.size)
    
    graph <- ggplot(NULL) +
      stat_function(fun = dnorm) +
      stat_function(fun = dnorm, args = list(mean = z_h1)) +
      labs(x = "z", y = "Density")
    
    if (input$alternative == "greater") {
      graph +
        xlim(0, 3)
    } else if (input$alternative == "less") {
      graph +
        xlim(-3, 0)
    } else {
      graph +
        geom_vline(xintercept = c(qnorm(input$sig.level / 2), qnorm(1 - input$sig.level / 2)),
                   linetype = "dotted") +
        xlim(-4, 4)
    }
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
