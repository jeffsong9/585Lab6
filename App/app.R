pkg=c("tidyverse", "ggplot2", "plotly")
sapply(pkg, require, character=T)


beer=read.csv("../data/beer.csv", stringsAsFactors = F)

ui <- fluidPage(
  checkboxGroupInput("FermentationType", label = h3("Checkbox group"), 
                     choices = list("Bottom" = unique(beer$Fermentation)[1], "Top" =unique(beer$Fermentation)[2]), selected="Bottom"
  ),

  mainPanel(
    plotlyOutput("plot_ferment")
  ),
  
  
  fluidRow(
    column(4,
           
           # Copy the line below to make a slider range 
           sliderInput("EFFrange", label = h3("Efficiency Range"), min = 43, 
                       max = 89, value = c(44, 89))
    )
  ),
  
  hr(),
  
  fluidRow(
    column(4, verbatimTextOutput("value")),
    column(4, verbatimTextOutput("range"))
  )
)

server <- function(input, output, session) {
  beer=read.csv("../data/beer.csv", stringsAsFactors = F)
  
  select_type=reactive({
    beer %>% filter(Fermentation==input$FermentationType[1] | Fermentation == input$FermentationType[2], Efficiency > input$EFFrange[1] & Efficiency < input$EFFrange[2])
    })
  
  output$plot_ferment <- renderPlotly({
     ggplot(data=select_type(), aes(x=Calories, y=ABV, labels = Brand), tooltip = c("Brand"))+geom_point() + ylim(2,7) + xlim(50,300)
    
  })
    
}

shinyApp(ui, server)