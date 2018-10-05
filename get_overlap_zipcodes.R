# INSTRUCTIONS:
# 1. Download tribal shapefiles from https://www.census.gov/geo/maps-data/data/cbf/cbf_aiannh.html
# 2. Download zipcode shapefiles from https://www.census.gov/geo/maps-data/data/cbf/cbf_zcta.html
# 3. Put zipcode shapefiles in "zips" folder
# 4. Put tribal shapefiles "tribal" folder
# 5. run script to save the overlapped zipcode shapefiles into the output folder

library(rgdal); library(sf)

# Read shapefiles
zip <- readOGR(dsn = "zips", layer = "cb_2017_us_zcta510_500k")
tri <- readOGR(dsn = "tribal", layer = "cb_2017_us_aiannh_500k")

# Transform projections
zip <- spTransform(zip, CRS("+init=epsg:4326"))
tri <- spTransform(tri, CRS("+init=epsg:4326"))

# Transform to sf objects
tri_sf <- st_as_sf(tri)
zip_sf <- st_as_sf(zip)

# Get overlaps
t <- st_intersects(zip_sf, tri_sf, sparse = FALSE)
overlap <- rowSums(t) > 0

# Get overlaps
zip_tribal <- zip[overlap,]

# Save as shapefiles
writeOGR(zip_tribal, dsn='output', layer='tribal_zips', driver="ESRI Shapefile",overwrite_layer=T)

# Plot (Uncomment if needed)
#library(leaflet)
#leaflet() %>%
#  addPolygons(data=zip_tribal,stroke = TRUE,opacity = 0.5,fillOpacity = 0.5, smoothFactor = 0.5,
#              color="black",weight = 0.5) %>%
#  addPolygons(data=tri,stroke = TRUE,opacity = 0.5,fillOpacity = 0.5, smoothFactor = 0.5,
#              color="blue",weight = 0.5) %>%
#  addTiles()