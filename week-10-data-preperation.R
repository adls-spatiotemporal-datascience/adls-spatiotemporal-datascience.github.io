



library(sf)

locs <- tribble(
  ~E, ~N, ~Ortschaft,
  2723294.54, 1076851.51, "Chiasso",
  2499995.19, 1117970.05, "Genf",
  2536605.02, 1151690.19, "Lausanne",
  2600096.82, 1199631.61, "Bern",
  2611090.23, 1267860.62, "Basel",
  2683315.44, 1247849.21, "Zürich",
  2760052.49, 1191525.89, "Chur",
  2837794.40, 1174997.14, "Mals",
) |> st_as_sf(coords = c("E","N"), crs = 2056)


st_write(locs, "data/week10-exercises/locations.gpkg")

# gpkg <- "data/swisstlm3d_2024-03_2056_5728/SWISSTLM3D_2024_LV95_LN02.gpkg"
# 
# lay <- st_layers(gpkg)
# 
# # Visp, Bahnhof Nord
# # Zürich HB
# # Basel SBB
# # Locarno
# 
# oev2 <- st_read(gpkg, query = "SELECT * FROM tlm_oev_haltestelle WHERE name IN ('Visp, Bahnhof Nord', 'Zürich HB', 'Basel SBB', 'Locarno', 'Genève') AND objektart = 'Haltestelle Bahn'")
# 
# 
# plot(oev2)
