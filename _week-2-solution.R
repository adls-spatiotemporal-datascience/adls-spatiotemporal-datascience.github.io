library(terra)

ortho <- rast("data/Orthofoto_ZH/3612.tif")

ortho_10 <- terra::aggregate(ortho, 200)

names(ortho_10) <- c("R","G","B","NIR")


plotRGB(ortho_10, r = 4, g = 1, b = 2)


NDVI <- (ortho_10$NIR - ortho_10$R)/(ortho_10$NIR + ortho_10$R)

plot(NDVI)
