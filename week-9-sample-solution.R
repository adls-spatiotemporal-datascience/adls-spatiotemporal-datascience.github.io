
library(sf)
library(sfnetworks)
library(tidygraph)
library(tmap)
library(tmap.networks)
library(dplyr)
library(stringr)


veloland <- read_sf("data/week9-exercises/veloland.gpkg")

veloland <- sfnetworks::as_sfnetwork(veloland, directed = FALSE)


veloland <- veloland |> 
  activate("nodes") |> 
  mutate(
    betweenness = centrality_betweenness(weights = length),
    closeness = centrality_closeness(weights = length),
    degree = centrality_degree(weights = length)
    )


veloland_nodes <- veloland |> activate("nodes") |> st_as_sf()
veloland_edges <- veloland |> activate("edges") |> st_as_sf()


veloland_nodes2 <- aggregate(veloland_nodes, veloland_edges, FUN = "mean")


cols <- cols4all::c4a("temperature_diverging",11)
tm_shape(veloland_nodes2) + 
  tm_lines(col = c("degree"), 
           col.scale = tm_scale_intervals(style = "jenks",n = 11, values = cols),
           col.legend = tm_legend(show = FALSE)) +
  tm_add_legend(col = cols, type = "lines", labels = c("low", rep("",4), "mid",rep("",4), "high"))
  
p <- tm_shape(veloland_nodes2) + 
  tm_lines(col = c("degree", "closeness", "betweenness"), 
           col.scale = tm_scale_intervals(style = "jenks",n = 11, values = "-brewer.spectral"),
           col.legend = tm_legend(show = FALSE)) +
  tm_facets_wrap(nrow = 1)


tmap_save(p, height = 8, width = 30, units = "cm", filename = "images/centrality.png")
