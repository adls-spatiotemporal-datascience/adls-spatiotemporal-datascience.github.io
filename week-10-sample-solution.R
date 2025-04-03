library(sf)
library(sfnetworks)
library(tidygraph)
library(tmap)
library(tmap.networks)
library(purrr)


veloland <- read_sf("data/week9-exercises/veloland.gpkg")
locs <- read_sf("data/week10-exercises/locations.gpkg")

veloland_net <- as_sfnetwork(veloland, directed = FALSE)


origin <- locs[4,]
destination <- locs[-4,]

edge_paths <- st_network_paths(veloland_net, origin, destination, weights = "length") |> 
  pull(edge_paths)
  

names(edge_paths) <- paste(origin$Ortschaft, destination$Ortschaft, sep = " - ")

edge_paths2 <- imap(edge_paths, \(x,y){
  veloland[x,] |> 
    mutate(name = y)
  }) |> 
  do.call(rbind, args = _) |> 
  group_by(name) |> 
  summarise()


p2 <- tm_shape(veloland) + 
  tm_lines(col = "grey") +
  tm_shape(edge_paths2) + 
  tm_lines(col = "name",lwd = 3, lty = 2, col_alpha = .5, col.legend = tm_legend(show = FALSE)) +
  tm_shape(origin) + 
  tm_dots(col = "red", size = .5, shape = 8)  + 
  tm_labels(text = "Ortschaft", col = "red") +
  tm_shape(destination) + 
  tm_dots(col = "blue", size = .5)  +
  tm_labels(text = "Ortschaft") +
  tm_layout(legend.show = FALSE)


tmap_save(p2, "images/shortest_path.png", height = 20, width = 30, units = "cm")

# https://luukvdmeer.github.io/sfnetworks/articles/sfn04_routing.html 