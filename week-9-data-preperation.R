


# data source
# https://data.sbb.ch/explore/dataset/linie-mit-polygon/information/

sbb <- st_read("data/sbb/linie-mit-polygon.fgb")

sbb <- st_set_crs(sbb, 2056)

st_write(sbb, "data/week9-exercises/sbb.gpkg")


# Alternative Strassennetz Zürich

library(sf)
library(dplyr)


tlm_strassen <- st_read("data/swisstlm3d_2024-03_2056_5728/SWISSTLM3D_2024_LV95_LN02.gpkg", query = "SELECT objektart, geom FROM tlm_strassen_strasse")
tlm_hoheitsgebiet <- st_read("data/swissboundaries3d_2024-01_2056_5728/swissBOUNDARIES3D_1_5_LV95_LN02.gpkg", query = "SELECT name, geom FROM tlm_hoheitsgebiet WHERE name = 'Wädenswil'")

strassen <- st_intersection(tlm_strassen, tlm_hoheitsgebiet)
strassen <- strassen |> 
  st_zm() |> 
  st_cast("MULTILINESTRING") |> 
  st_cast("LINESTRING")

rownames(strassen) <- NULL
strassen$length <- as.numeric(st_length(strassen))
st_write(strassen, "data/week9-exercises/network-analysis.gpkg", "strassen", append = FALSE)


# Alternative Veloland Schweiz


gpkg <- "data/schweizmobil/veloland.gdb/"
veloweg <- read_sf(gpkg, "VeloWeg")

veloweg <- veloweg |> 
  select() |> 
  st_zm() |> 
  st_cast("MULTILINESTRING") |> 
  st_cast("LINESTRING")

net = as_sfnetwork(veloweg, directed= FALSE)

n_edges <- function(obj){
  obj |> activate("edges") |> st_as_sf() |> nrow()
}

n_nodes <- function(obj){
  obj |> activate("nodes") |> st_as_sf() |> nrow()
}

# removed 6 edges
simple = net %>%
  activate("edges") %>%
  filter(!edge_is_multiple()) %>%
  filter(!edge_is_loop())



# added 59 nodes
subdivision = convert(simple, to_spatial_subdivision)


# n_nodes(subdivision) - n_nodes(smoothed)
# rmoved 86k+ nodes
smoothed = convert(subdivision, to_spatial_smooth)


maincomp <- smoothed |> 
  activate("nodes") |> 
  mutate(
    membership = components(smoothed)$membership    
  ) |> 
  filter(membership == which.max(table(membership)) )


maincomp_lines <- maincomp |> 
  activate("edges") |> 
  st_as_sf() |> 
  select()

plot(maincomp_lines)


maincomp_lines$length <- as.numeric(st_length(maincomp_lines))

maincomp_lines <- filter(maincomp_lines, length > 0)


st_write(maincomp_lines, "data/week9-exercises/veloland.gpkg", append = FALSE)


# alternative (delete at some point):
# 
# autobahn <- st_read(
#   "data/swisstlm3d_2024-03_2056_5728/SWISSTLM3D_2024_LV95_LN02.gpkg",
#   query = "SELECT objektart, geom FROM tlm_strassen_strasse WHERE objektart IN ('Autobahn','Autostrasse', 'Verbindung')",
# 
#   )
# 
# autobahn <- autobahn |>
#   st_zm() |>
#   st_cast("MULTILINESTRING") |>
#   st_cast("LINESTRING")
# 
# autobahn2 <- as_sfnetwork(autobahn)
# 
# library(igraph)
# 
# comps <- autobahn2 |>
#   components(mode = c("weak"))
# 
# autobahn2 <- autobahn2 |>
#   activate("nodes") |>
#   mutate(
#     membership = comps$membership,
#   )
# 
# 
# 
# 
# autobahn3 <- autobahn2 |>
#   activate("nodes") |>
#   st_as_sf()
# 
# autobahn3b <- autobahn3 |>
#   filter(membership == which.max(table(autobahn3$membership)))
# 
# 
# autobahn4 <- autobahn[autobahn3b,,]
# 
# 
# autobahn5 <- as_sfnetwork(autobahn4)
















