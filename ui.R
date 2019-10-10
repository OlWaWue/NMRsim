
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("NMRsim - simulate your NMR data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput("noise",
                  "Noise:",
                  min = 1,
                  max = 50,
                  value = 0.5),
      numericInput("ppm",
                   "Shift (ppm):",
                   min = 1,
                   max = 50,
                   value = 5),
      numericInput("intens",
                   "Intensity:",
                   min = 1,
                   max = 50,
                   value = 1),
      numericInput("width",
                   "Width:",
                   min = 1,
                   max = 50,
                   value = 0.03, step = 0.01),
      numericInput("couple",
                   "Coupling Constant (ppm):",
                   min = 1,
                   max = 50,
                   value = 0.25, step = 0.01),
      shiny::selectInput("choose", "Multiplet:",
                         choices = c("singlet"=1,
                                     "duplet"=2,
                                     "triplet"=3,
                                     "quartet"=4,
                                     "AB System"=5),
                         selected = 1),
      actionButton("send", "Add Signal"),
      
      hr(),
      numericInput("x_min",
                   "X Minimum (ppm):",
                   min = 0,
                   max = 20,
                   value = 0, step = 0.01),
      numericInput("x_max",
                   "X Maximum (ppm):",
                   min = 1,
                   max = 20,
                   value = 20, step = 0.01),
      numericInput("y_min",
                   "Y Minimum (Intensity):",
                   min = 0,
                   max = 20,
                   value = 0, step = 0.01),
      numericInput("y_max",
                   "Y Maximum (Intensity):",
                   min = 1,
                   max = 20,
                   value = 50, step = 10)
      
    ),

    mainPanel(
      plotOutput("mainPlot")
    )
  )
))
