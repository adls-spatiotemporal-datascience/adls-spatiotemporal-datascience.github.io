import rasterio
import numpy as np
import matplotlib.pyplot as plt
from rasterio.enums import Resampling

# File path
ortho_path = "data/Orthofoto_ZH/3612.tif"

# Open raster
with rasterio.open(ortho_path) as src:
    # Read all bands
    ortho = src.read()
    
    # Resample to lower resolution (aggregate by factor of 200)
    new_shape = (src.height // 200, src.width // 200)
    ortho_10 = src.read(out_shape=(src.count, *new_shape), resampling=Resampling.average)

# Rename bands (assuming original order is R, G, B, NIR)
R, G, B, NIR = ortho_10

# Display RGB composite (NIR as red, G as green, B as blue)
plt.figure(figsize=(8, 8))
plt.imshow(np.dstack((NIR, R, G)))
plt.title("RGB Composite (NIR, R, G)")
plt.axis("off")
plt.show()

# Compute NDVI
NDVI = (NIR - R) / (NIR + R)

# Plot NDVI
plt.figure(figsize=(8, 8))
plt.imshow(NDVI, cmap='RdYlGn')
plt.colorbar(label="NDVI")
plt.title("NDVI Map")
plt.axis("off")
plt.show()
