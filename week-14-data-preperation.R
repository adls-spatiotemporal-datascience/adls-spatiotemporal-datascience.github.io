

library(sf)
library(purrr)
library(stringr)
library(dplyr)

# extracted from https://extract.bbbike.org/ on the 15.05.2025 using the format
# "Protocolbuffer (PBF)" using the coordinates:
# Left lower corner (South-West)
# Lng 115.423 Lat 39.448
# Right top corner (North-East)
# Lng 117.314 Lat 40.368


path <- "data/OSM_bejing/planet_115.423,39.448_117.314,40.368.osm.pbf"

lays <- st_layers(path)$name

names(lays) <- lays

bej <- imap(lays, \(x, y) st_read(path, x))


lines <- bej$lines
not_na <- \(x)!is.na(x)

lines_types <- c("highway", "waterway", "aerialway", "barrier", "railway")

other_cols <- colnames(lines)[!(colnames(lines) %in% lines_types)]

# mat <- st_drop_geometry(lines[,lines_types]) |> 
#   as.matrix()
# 
# sel <- mat |> 
#   not_na() |> 
#   apply(1, sum) |> 
#   sapply(\(x)x>1)
# 
# 
# lines[sel,lines_types] |> View()


names(lines_types) <- lines_types

lines_l <- map(lines_types, \(x,y){
  sel <- as.vector(!is.na(st_drop_geometry(lines[,x])))
  lines[sel,c(x, other_cols)]
})

library(tidyr)

highway <- lines_l$highway




any(duplicated(highway$osm_id))


highway_tags <- map2_dfr(str_split(highway$other_tags, ","), highway$osm_id, \(x,y){
  if(any(!is.na(x))){
    df <- x |>
      str_split_fixed("=>", 2) |>
      apply(2, \(x){
        str_trim(str_remove_all(x, '\"'))
      })  |>
      matrix(ncol = 2) |>
      as.data.frame()
    
    colnames(df) <- c("key","val")
    df |> 
      pivot_wider(names_from = key, values_from = val) |> 
      mutate(osm_id = y)
  } 
}, .progress = TRUE)


highway_tags_cycle<- highway_tags[,str_detect(colnames(highway_tags), "cycle")] 

highway_tags_cycle_vec <- highway_tags_cycle |> 
  mutate(across(everything(), \(x)x != "no")) |> 
  as.matrix() |> 
  apply(1, any)

highway_tags_cycle <- tibble(osm_id = highway_tags$osm_id, cycleway = highway_tags_cycle_vec)



highway2 <- left_join(highway, highway_tags_cycle, by = "osm_id")


highway2 <- st_transform(highway2, 32650)

library(forcats)

highway2$length <- as.numeric(st_length(highway2))

highway2$highway <- fct_lump_n(highway2$highway, 6, w = highway2$length)


st_write(highway2, "data/week14-exercises/osm.gpkg", "highway", append = FALSE)


railway <- st_transform(lines_l$railway, 32650)

railway$length <- as.numeric(st_length(railway))

railway$railway <- fct_lump_n(railway$railway, 3, w = railway$length)
st_write(railway, "data/week14-exercises/osm.gpkg", "railway", append = FALSE)
