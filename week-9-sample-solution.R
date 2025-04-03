
library(sf)
library(sfnetworks)
library(tidygraph)
library(tmap)
library(tmap.networks)

veloland <- read_sf("data/week9-exercises/veloland.gpkg")

veloland <- sfnetworks::as_sfnetwork(veloland, directed = FALSE)


veloland <- veloland |> 
  activate("nodes") |> 
  mutate(
    centrality_betweenness = centrality_betweenness(weights = length),
    centrality_closeness = centrality_closeness(weights = length),
    centrality_degree = centrality_degree(weights = length)
    )


veloland_nodes <- veloland |> activate("nodes") |> st_as_sf()
veloland_edges <- veloland |> activate("edges") |> st_as_sf()


veloland_nodes2 <- aggregate(veloland_nodes, veloland_edges, FUN = "mean")


tm_shape(veloland_nodes2) + 
  tm_lines(col = "centrality_degree", col.scale = tm_scale_intervals(style = "jenks",n = 11, values = "-brewer.spectral")) +
  tm_layout(legend.show = FALSE)


tm_shape(veloland_nodes2) + 
  tm_lines(col = "centrality_closeness", col.scale = tm_scale_intervals(style = "jenks",n = 11, values = "-brewer.spectral")) +
  tm_layout(legend.show = FALSE)
tm_shape(veloland_nodes2) + 
  tm_lines(col = "centrality_degree", col.scale = tm_scale_intervals(style = "jenks",n = 11, values = "-brewer.spectral")) +
  tm_layout(legend.show = FALSE)




