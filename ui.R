library(shiny)

city <- c("Amsterdam","Brussel","Berlin","London","Paris","Madrid","Lissabon","Prague")


shinyUI(fluidPage(
  headerPanel("Trans Europe Express"),
  sidebarPanel(

    checkboxGroupInput("id1", "Select cities to visit",city),
    selectInput("id2", "Start trip in", city, selected = "Amsterdam", multiple = FALSE, selectize = FALSE, width = NULL),
    actionButton("goButton", "Go!")
  ),
  mainPanel(
    tabsetPanel(type = "tabs", 
                tabPanel("Route",tableOutput( 'distTable')),
                tabPanel("Map",
                         h5("Roundtrip Map"),
                         plotOutput('plotMap'), width = 6
                ),
                tabPanel("About",
                         h5("Description"),
                         "Trans Europe Express lets the user select cities to visit and the city from where the trip starts.",
                         "The shortest route will be calculated using roadtrip distances as provided by Google Maps.",
                         h5("User Interface"),
                         "The user has to select the cities to be visited from the given list and the city from where the trip starts.",
                         "If the starting city is not in the selection it will be added.",
                         "When desired cities and start city are selected the \"Go\" button must be pressed.",
                         br(),
                         "Tab \"Route\" shows the city to city round trip including distances.",
                         "The roundtrip distance is shown in the last line of the table",
                         br(),
                         "Tab \"Map\" will show the calculated trip, if this tab is selected the route data will be retrieved from Google Maps first.",
                         "It may take a little time before the map is shown.",
                         h5("Author"),
                         "Eric van Mulken",
                         br(),
                         "September 2014"
                )
    )
  )
)
)