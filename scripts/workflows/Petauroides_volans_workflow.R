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
###   "species_name_workflow.R"           ###
###                                       ###
###   Species-specific workflow files are ###
### to be saved in the appropriate        ###
### folder:                               ###
###                                       ###
###   "scripts/workflows"                 ###
###                                       ###
#############################################
#############################################

########################
### WORKFLOW DETAILS ###
########################

## Species: Petauroides volans
## Guild: Mammals
## Region: "VIC" "NSW" "QLD" "ACT"
## Analyst: Adam
## Reviewer: Darren
## SDM Required: Y
## Used existing SDM: N
## Built SDM: Y
## Data available: PO
## Type of SDM: PresBG
## Number of presence records: 2388
## Number of background points:1000
## Type of background points: RBG
## Date completed: 14/7/20
## Any other comments: Re-ran with RB. Output looks Ok.

species <- "Petauroides volans"

guild <- "Mammals"

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

spp_data <- bushfireSOS::load_pres_bg_data_AUS(species = species,
                                               region = c("VIC", "NSW", "QLD", "SA", "NT", "WA", "TAS"),
                                               save.map = FALSE,
                                               map.directory = "outputs/data_outputs",
                                               email = "asmart1@student.unimelb.edu.au",
                                               file.vic = "bushfireResponse_data/spp_data_raw/VIC sensitive species data/FAUNA_requested_spp_ALL.gdb")

region <- bushfireSOS::species_data_get_state_character(spp_data$data)

## Presence absence data

# spp_data <- bushfireSOS::load_pres_abs_data(species,
#                                             region)

## Preliminary presence records check
## If <20 can end workflow here

nrow(spp_data$data)

###############################
### Load Environmental Data ###
###############################

# Load appropriate environmental raster data

env_data <- bushfireSOS::load_env_data(stack_file = "bushfireResponse_data/spatial_layers/raster_tiles",
                                       region = region)

#########################
### Background Points ###
#########################

# Generate our background points

spp_data <- bushfireSOS::background_points(species = species,
                                           spp_data = spp_data,
                                           guild = guild,
                                           region = region,
                                           background_group = "vertebrates",
                                           bias_layer = "bushfireResponse_data/spatial_layers/aus_road_distance_250_aa.tif",
                                           sample_min = 200000)

## Check that there are >= 20 presences (1s) and an appropriate number of
## background points (1000 * number of states with data for target group,
## or 10,000 for random)

table(spp_data$data$Value)

#######################
### Data Extraction ###
#######################

spp_data <- bushfireSOS::env_data_extraction(spp_data = spp_data,
                                             env_data = env_data)

saveRDS(spp_data,
        sprintf("bushfireResponse_data/outputs/spp_data/spp_data_%s.rds",
                gsub(" ", "_", species)))

#####################
### SDM Required? ###
#####################

# Do we have >=20 presence records?
# Y

# Can we fit an SDM for this species?
# Y

# If no, how should we create an output for Zonation?

#########################
### Use Existing SDM? ###
#########################

# Can we use an existing SDM for this species?
# Y/N

# If yes, how should we ensure its suitable for our purposes?

#####################
### Model Fitting ###
#####################

# Fit an appropriate model type

# Comment out unused methods instead of deleting them in case more
# data becomes available at a later date

## Presence only
## Features should equal "default" on first attempt. Can reduce 
## to "lqp", "lq", or "l" if model is too complex to fit 

model <- bushfireSOS::fit_pres_bg_model(spp_data = spp_data,
                                        tuneParam = TRUE,
                                        k = 5,
                                        parallel = FALSE,
                                        features = "default")

saveRDS(model,
        sprintf("bushfireResponse_data/outputs/model/model_%s.rds",
                gsub(" ", "_", species)))

## Presence absence model

# model <- bushfireSOS::fit_pres_abs_model()

## Hybrid model

# model <- bushfireSOS::fit_hybrid_model()

########################
### Model Evaluation ###
########################

# Perform appropriate model checking
# Ensure features is set identical to that of the above full model
# If Boyce Index returns NAs then re-run the cross-validation with
#  one fewer fold i.e. 5 > 4 > 3 > 2 > 1

model_eval <- bushfireSOS::cross_validate(spp_data = spp_data,
                                          type = "po",
                                          k = 5,
                                          parallel = FALSE,
                                          features = "default")

saveRDS(model_eval,
        sprintf("bushfireResponse_data/outputs/model_eval/model_eval_%s.rds",
                gsub(" ", "_", species)))

########################
### Model Prediction ###
########################

# Perform appropriate prediction

prediction <- bushfireSOS::model_prediction(model = model,
                                            env_data = env_data,
                                            mask = "bushfireResponse_data/spatial_layers/NIAFED_v20200428",
                                            parallel = FALSE)

raster::writeRaster(prediction,
                    sprintf("bushfireResponse_data/outputs/predictions/predictions_%s.tif",
                            gsub(" ", "_", species)), overwrite=T)

mapview::mapview(prediction)

#################
### Meta Data ###
#################

# Store meta data relevant to analysis

meta_data <- sessionInfo()

saveRDS(meta_data,
        sprintf("bushfireResponse_data/outputs/meta_data/meta_data_%s.rds",
                gsub(" ", "_", species)))
