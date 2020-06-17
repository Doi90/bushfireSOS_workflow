#############################################
#############################################
###                                       ###
###       TEMPLATE FOR SDM WORKFLOW       ###
###                                       ###
###   This script file is a template for  ###
### the species distribution modelling    ###
### workflow as part of the bushfire 2019 ###
### - 2020 response analysis.             ###
###                                       ###
###   For each actual species workflow we ###
### should copy this template into a new  ###
### file. Then edit the workflow to suit  ###
### the species being analysed.           ###
###                                       ###
###   Species-specific workflow files are ###
### to be saved as:                       ###
###                                       ###
###   "workflow_species_name.R"           ###
###                                       ###
###   Species-specific workflow files are ###
### to be saved in the appropriate guild  ###
### folder:                               ###
###                                       ###
###   "scripts/workflows/<guild>"         ###
###                                       ###
#############################################
#############################################

########################
### WORKFLOW DETAILS ###
########################

## Species:                           # Scientific names?
## Guild:                             # Or whatever we want to call our groups
## Region:                            # Eastern seaboard/WA/Kangaroo Island?
## Analyst:                           # Name of person who implemented workflow
## Reviewer:                          # Name of person who checked workflow
## SDM Required: Y/N                  # Retain option to indicate method
## Used existing SDM: Y/N             # Retain option to indicate method
## Built SDM: Y/N                     # Retain option to indicate method
## Data available: PO/PA              # Retain option to indicate method
## Type of SDM: PresBG/PresAbs/Hybrid # Retain option to indicate method
## Date completed:                    # Date workflow is finished (or last updated?)

#####################
### Load Packages ###
#####################

library(bushfireSOS)

#########################
### Load Species Data ###
#########################

# Load appropriate species data.

# Comment out unused methods instead of deleting them in case more
# data becomes available at a later date

## Presence background data

spp_data <- bushfireSOS::load_pres_bg_data_AUS(species = "Petauroides volans",
                                               region = c("NSW", "VIC", "QLD"),
                                               save.map = TRUE,
                                               map.directory = "outputs/data_outputs",
                                               email = "davidpw@student.unimelb.edu.au",
                                               file.vic = "bushfireResponse_data/spp_data_raw/VIC sensitive species data/FAUNA_requested_spp_ALL.gdb")

## Presence absence data

# spp_data <- bushfireSOS::load_pres_abs_data(species,
#                                             region)

#####################
### SDM Required? ###
#####################

# Does this species require an SDM?
# Y/N 

# If no, how should we create an output for Zonation?

#########################
### Use Existing SDM? ###
#########################

# Can we use an existing SDM for this species?
# Y/N

# If yes, how should we ensure its suitable for our purposes?

###############################
### Load Environmental Data ###
###############################

# Load appropriate environmental raster data

env_data <- bushfireSOS::load_env_data(stack_file = "bushfireResponse_data/spatial_layers/bushfire_terre_layers_250_AA.tif",
                                       region = c("VIC","NSW", "QLD"))

######################
### Region Masking ###
######################

# Might change how this section works
# We're going to pre-mask rasters
# Still need to load a mask to mask predictions

# mask <- bushfireSOS::mask_data()

#########################
### Background Points ###
#########################

# Generate our background points

spp_data <- bushfireSOS::background_points(species = "Petauroides volans",
                                           spp_data = spp_data,
                                           guild = "Mammals",
                                           region = c("VIC","NSW", "QLD"),
                                           background_group = "vertebrates",
                                           bias_layer = "bushfireResponse_data/spatial_layers/aus_road_distance_250_aa.tif",
                                           sample_min = 1000)

#######################
### Data Extraction ###
#######################

spp_data <- bushfireSOS::env_data_extraction(spp_data = spp_data,
                                             env_data = env_data)


#####################
### Model Fitting ###
#####################

# Fit an appropriate model type

# Comment out unused methods instead of deleting them in case more
# data becomes available at a later date

# Any guild/region specific things to happen here?

## Presence only

model <- bushfireSOS::fit_pres_bg_model(spp_data = spp_data,
                                        tuneParam = TRUE,
                                        k = 5,
                                        parallel = FALSE,
                                        features = "lqp")

## Presence absence model

# model <- bushfireSOS::fit_pres_abs_model()

## Hybrid model

# model <- bushfireSOS::fit_hybrid_model()

########################
### Model Evaluation ###
########################

# Perform appropriate model checking

model_eval <- bushfireSOS::cross_validate(spp_data = spp_data,
                                          type = "po",
                                          k = 5,
                                          parallel = FALSE,
                                          features = "lqp")

########################
### Model Prediction ###
########################

# Perform appropriate prediction

prediction <- bushfireSOS::model_prediction(model = model,
                                            env_data = env_data,
                                            mask = "",
                                            parallel = FALSE)

###########################
### Zonation Formatting ###
###########################

# Any special steps required to set things up for Zonation?

#################
### Meta Data ###
#################

# Store meta data relevant to analysis

meta_data <- bushfireSOS::meta_data()

