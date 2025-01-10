# Code to download all mapping data
# Only needs to be sourced once to download all data and unzip files on local machine

# Luke Warkentin

remotes::install_github("vlucet/rgovcan")
require(rgovcan)
require(here)
require(sf)
require(purrr)

if( !dir.exists(here("data", "map-data"))) {
newfolder <- "map-data"
dir.create(here("data"), newfolder) }

# where to save data
path <- here("data/map-data")


# Provincial and US Borders and Coastlines (not using rgovcan because they are more complicated file source urls)
if(!file.exists(here('data/map-data/can_admin.zip')) )
  download.file('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/canvec/shp/Admin/canvec_1M_CA_Admin_shp.zip', 
                destfile=here('data/map-data/can_admin.zip'), mode="wb")
# just unzip region boundaries
if(!file.exists(here('data/map-data/canvec_admin/canvec_1M_CA_Admin/geo_poligical_region_2.shp')))
  unzip(zipfile=here('data/map-data/can_admin.zip'),  exdir=here('data/map-data/canvec_admin'))


# Rivers, lakes, ocean
options(timeout=1000)
if(!file.exists(here('data/map-data/canvec_250K_BC_Hydro/canvec_250K_BC_Hydro/waterbody_2.shp')))
  download.file('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/canvec/shp/Hydro/canvec_250K_BC_Hydro_shp.zip', 
                destfile=here('data/map-data/canvec_250K_BC_Hydro.zip'), mode="wb")
options(timeout=60)
# Unzip
if(!file.exists(here('data/map-data/canvec_250K_BC_Hydro/waterbody_2.shp')))
  unzip(zipfile=here('data/map-data/canvec_250K_BC_Hydro.zip'), 
        exdir=here('data/map-data/canvec_250K_BC_Hydro'))

# # Point shapefile of place names for labels (currently unused)
# if(!file.exists(here('data_in/map_data/place_names.zip')))
#   download.file('https://ftp.maps.canada.ca/pub/nrcan_rncan/vector/canvec/shp/Toponymy/canvec_50K_BC_Toponymy_shp.zip', destfile=here('data_in/map_data/place_names.zip'), mode="wb")
# fs2 <- unzip(zipfile=here('data_in/map_data/place_names.zip'), list=TRUE)
# if(!file.exists(here('data_in/map_data/canvec_50K_BC_Toponymy')))
#   unzip(zipfile=here('data_in/map_data/place_names.zip'), files=fs2$Name[grep("bdg_named_feature_0", fs2$Name)], exdir=here('data_in/map_data/'))

