import geopandas as gpd

# File paths
gpkg = "data/swisstlm3d_2024-03_2056_5728/SWISSTLM3D_2024_LV95_LN02.gpkg"
gpkg2 = "data/swissboundaries3d_2024-01_2056_5728/swissBOUNDARIES3D_1_5_LV95_LN02.gpkg"

# Load layers
bb = gpd.read_file(gpkg, layer="tlm_bb_bodenbedeckung")
cantons = gpd.read_file(gpkg2, layer="tlm_kantonsgebiet")

# Filter forest areas
wald = bb[bb["objektart"] == "Wald"]

# Intersect forest areas with canton boundaries
wald_cant = gpd.overlay(wald, cantons, how="intersection")

# Calculate forest area
wald_cant["area"] = wald_cant.geometry.area
wald_area = wald_cant.groupby("name", as_index=False)["area"].sum().rename(columns={"area": "wald_area"})

# Calculate total canton area
cantons["area"] = cantons.geometry.area
canton_area = cantons.groupby("name", as_index=False)["area"].sum().rename(columns={"area": "canton_area"})

# Merge and compute forest percentage
result = wald_area.merge(canton_area, on="name", how="outer")
result["wald_perc"] = (result["wald_area"] / result["canton_area"]) * 100

# Sort by forest percentage in descending order
result = result.sort_values(by="wald_perc", ascending=False)

# Display result
print(result)
