pkg=c("tidyverse", "ggplot2", "plotly")
sapply(pkg, require, character=T)


beer=read.csv("../data/beer.csv", stringsAsFactors = F)

ui <- fluidPage(
  checkboxGroupInput("FermentationType", label = h3("Checkbox group"), 
                     choices = list("Bottom" = unique(beer$Fermentation)[1], "Top" =unique(beer$Fermentation)[2]), selected="Bottom"
  ),

  mainPanel(
    plotlyOutput("plot_ferment")
  )
)

server <- function(input, output, session) {
  beer=read.csv("../data/beer.csv", stringsAsFactors = F)
  
  select_type=reactive({
    beer %>% filter(Fermentation==input$FermentationType)
    })
  
  output$plot_ferment <- renderPlotly({
     ggplot(data=select_type(), aes(x=Calories, y=ABV, labels = Brand), tooltip = c("Brand"))+geom_point()
    
  })
    
}

shinyApp(ui, server)