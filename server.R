

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  app_data <- shiny::reactiveValues(
    
    spectralwidth = seq(0,20, by=0.01),
    
    baseline=rep(0,length(seq(0,20, by=0.01))),
    
    noise=runif(length(seq(0,20, by=0.01)),min=0,max=0.5)
    
  )

  cauchy <-function(x,s,t) {
    f_value <- 1/3.141*s/(s^2+(x-t)^2)
    
    return(f_value)
  }
  
  refresh_noise <- function(){
    app_data$noise=runif(length(seq(0,20, by=0.01)),min=0,max=input$noise)
  }
  
  add_signal <- function(baseline, spectralwidth, s, t, intens){
    baseline <- (baseline+cauchy(app_data$spectralwidth, s,t)*intens)
    
    return(baseline)
  }
  
  add_singlet <- function(){
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm,input$intens)
  }
  
  add_dublet <- function(){
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm+input$couple,input$intens/2)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm-input$couple,input$intens/2)
  }
  
  add_triplet <- function(){
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm,input$intens/3*2)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm+input$couple,input$intens/3)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm-input$couple,input$intens/3)
  }
  
  add_quartet <- function(){
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm+input$couple/2*3,input$intens/4)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm+input$couple/2,input$intens/2)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm-input$couple/2*3,input$intens/4)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm-input$couple/2,input$intens/2)
  }
  
  add_ab_system <- function(){
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm+input$couple*2.5,input$intens*0.75/4)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm+input$couple*2,input$intens/4)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm-input$couple*2.5,input$intens*0.75/4)
    app_data$baseline <- add_signal(app_data$baseline,app_data$spectralwidth,input$width,input$ppm-input$couple*2,input$intens/4)
  }
  
  
  output$mainPlot <- renderPlot({



    dat <- data.frame(x=app_data$spectralwidth,y=app_data$baseline+app_data$noise)
    

    
    pl <- ggplot(dat) + geom_line(aes(x=x,y=y)) + theme_bw() +xlab("Shift [ppm]") + ylab("Intensity") +
      scale_x_reverse(limits=c(input$x_max, input$x_min)) + ylim(input$y_min, input$y_max)  
    
    plot(pl)

  })
  
  observeEvent(input$send,{
    
    refresh_noise()
    
    if(input$choose==1){
      add_singlet()
    } else if (input$choose==2){
      add_dublet()
    }else if (input$choose==3){
      add_triplet()
    }else if (input$choose==4){
      add_quartet()
    }else if (input$choose==5){
      add_ab_system()
    }
    
  })

})
