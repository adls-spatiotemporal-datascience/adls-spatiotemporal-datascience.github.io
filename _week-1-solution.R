library(sf)
library(dplyr)


gpkg <- "data/swisstlm3d_2024-03_2056_5728/SWISSTLM3D_2024_LV95_LN02.gpkg"
gpkg2 <- "data/swissboundaries3d_2024-01_2056_5728/swissBOUNDARIES3D_1_5_LV95_LN02.gpkg"


bb <- st_read(gpkg, "tlm_bb_bodenbedeckung")
cantons <- st_read(gpkg2, "tlm_kantonsgebiet")

wald <- bb |> filter(objektart == "Wald")


wald_cant <- st_intersection(wald, cantons)

wald_cant$area <- as.numeric(st_area(wald_cant))

wald_area <- wald_cant |> 
  st_drop_geometry() |> 
  group_by(name) |> 
  summarise(
    wald_area = sum(area)
  )

cantons$area <- as.numeric(st_area(cantons))

canton_area <- cantons |> 
  st_drop_geometry() |> 
  group_by(name) |> 
  summarise(
    canton_area = sum(area)
  )

full_join(wald_area, canton_area) |> 
  mutate(wald_perc = wald_area/canton_area*100) |> 
  arrange(desc(wald_perc))

