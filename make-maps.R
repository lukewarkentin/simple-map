# Code to create maps after mapping data are downloaded.


# Luke Warkentin
library(here)
library(ggplot2)
library(sf)
library(ggspatial)
library(purrr)
library(rgdal)
library(dplyr)


# Download data if not downloaded (if there are not 3 or more non-zip files in 
#    the map_data folder. The DFO fisheries management areas file is downloaded manually)
if(length(grep(list.files(here('data/map-data')), pattern=".*\\.zip$", invert=TRUE, value=TRUE)) < 3 )
  source(here("get-map-data.R"))
# # Download BC Freshwater atlas stream line data with fwatlasbc package
# if(!file.exists(here("data/map-data/freshwater-atlas-streams.RDS")))
#   source(here("R/get-freshwater-atlas-stream-shapefiles.R"))

# where to get map data
path <- here("data/map-data")

# Borders and regions/land
borders <- st_read(here('data/map-data/canvec_admin/canvec_1M_CA_Admin/geopolitical_boundary_1.shp'))
regions <- st_read(here('data/map-data/canvec_admin/canvec_1M_CA_Admin/geo_political_region_2.shp'))

# Rivers, lakes, ocean
water <- st_read(here('data/map-data/canvec_250K_BC_Hydro/canvec_250K_BC_Hydro/waterbody_2.shp'))
water$area_km2 <- as.numeric(st_area(water))/1000000
water_filter <- st_transform(water, crs = st_crs(borders))

# # place names (currently unused)
# pnames <- st_read(here('data_in/map_data/canvec_50K_BC_Toponymy/bdg_named_feature_0.shp'))

# Define global colours
water_col <- "white"
land_col <- "gray50"


# Add points for samples
d <- read.csv(here("data", "data.csv"))
d_sf <- st_as_sf(d, coords = c("long", "lat"), 
                    crs = 4269)

# Plot Skeena populations only
png(here("fig/map.png"), width=6, height=5, units="in", res=1000)
ggplot(data = d_sf) + #, colour=LABEL_COLOUR)) +
  geom_sf(data=regions[!regions$ctry_en == "Ocean",], fill=land_col, size=0, colour=NA) +
  geom_sf(data=water_filter[ water_filter$area_km2 > 10 , ], fill=water_col, colour=NA, size=0) +
  geom_sf(aes(colour= type)) +
  coord_sf(xlim =  c(-130.5, -129.6) , ylim = c(54.4, 53.9) ) +
  xlab(NULL) +
  ylab(NULL) +
  annotation_scale(location = "bl", width_hint = 0.5) +
  annotation_north_arrow(location = "tl", which_north = "true",
                         pad_x = unit(0.3, "in"), pad_y = unit(0.3, "in"),
                         style = north_arrow_fancy_orienteering, width=unit(0.3, "in")) +
  theme_classic()
dev.off()

