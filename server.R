library(shiny)
library(ggmap)
library(TSP)



shinyServer(
  function(input, output) {
    
    
    reactive_tour <- reactive({
        
        start <- input$id2
        cities <- input$id1
        if( ! start %in% cities ) cities <- c(start,cities)

        city_dist <- rep(0,length(cities)*length(cities))
        city_dist <- matrix(data=city_dist,nrow=length(cities),ncol=length(cities))
        
        #retrieve city to city roadtravel distances
        for(i in 1:length(cities))
        {
          for( j in i:length(cities))
          {
            if(i == j) next
            city_dist [i,j] <- mapdist(cities[i],cities[j], mode="driving")$km
          }
        }
        
        city_dist <- city_dist + t(city_dist)
        
        #calculate the shortest 
        atsp <- as.ATSP(city_dist)
        tour <- solve_TSP(atsp, method="nn",control=list(start=which(cities==start)))
        
        #print route table
        tour_next <- c(tour[-1],tour[1])

        dist <- rep(0,length(cities))
    
        for( i in 1:length(cities))
        {
          dist[i] <- city_dist[tour[i],tour_next[i]]
        }
        to <- c(cities[tour][-1],cities[tour][1])

        from_to <- data.frame(from=cities[tour],to=to,distance=dist,stringsAsFactors = FALSE)

        df <- data.frame(city_tour=cities[tour],from_to=from_to,stringsAsFactors = FALSE )

        return(df)
        
      })

      output$oid1 <- renderPrint({
      input$goButton
      if (input$goButton == 0) ""
      else isolate(reactive_tour())})
    
      output$distTable <- renderTable({
        if (input$goButton == 0) NULL
        else
        {
          df_cities <- isolate(reactive_tour())
          tbl <- df_cities[c("from_to.from","from_to.to","from_to.distance")]
          names(tbl) <- c("From","To","Distance")
          tbl <- rbind(tbl,c(tbl[1,1],tbl[1,1],sum(tbl$Distance)))
          tbl
        }
      })

    
    output$plotMap <- renderPlot({
      
      if (input$goButton == 0) ""
      else
      {
      df_cities <- isolate(reactive_tour())
      rts <- data.frame()
      cities <- df_cities$city_tour

      for(i in 1:length(cities))
      {
        if(i==length(cities))
        {
          rts <- rbind(rts,route(cities[i],cities[1], structure = 'route'))
        }
        else
        {
          rts <- rbind(rts,route(cities[i],cities[i+1], structure = 'route'))
        }
      }
      
      
      gm <- get_map("Amsterdam",
                    zoom = 4, scale = 2,
                    maptype =  "roadmap",
                    messaging = FALSE, urlonly = FALSE,
                    filename = "ggmapTemp", crop = TRUE,
                    color = "color",
                    source = "google")
      
      mm <- ggmap(gm)
    
      mm <-  mm +      geom_path(
        aes(x = lon, y = lat),  colour = 'red', size = 1.5,
        data = rts)
      
      print(mm)
      }
      
    })
  }
)