library(sf)
library(sfnetworks)
library(tidygraph)
library(tmap)
library(tmap.networks)
library(purrr)


veloland <- read_sf("data/week9-exercises/veloland.gpkg")

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


tm_shape(veloland) + 
  tm_lines() +
  tm_shape(from) + tm_dots(col = "red", size = .5)  + 
  tm_labels(text = "Ortschaft") +
  tm_shape(to) + tm_dots(col = "blue", size = .5)  +
  tm_shape(edge_paths2) + tm_lines(col = "name",lwd = 3, lty = 2)



# https://luukvdmeer.github.io/sfnetworks/articles/sfn04_routing.html 