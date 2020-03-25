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

spp_data <- bushfireSOS::load_pres_bg_data()

## Presence absence data

spp_data <- bushfireSOS::load_pres_abs_data()

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

env_data <- bushfireSOS::load_env_data()

######################
### Region Masking ###
######################

# Might change how this section works

mask <- bushfireSOS::mask_data()

#####################
### Model Fitting ###
#####################

# Fit an appropriate model type

# Comment out unused methods instead of deleting them in case more
# data becomes available at a later date

## Presence only

model <- bushfireSOS::fit_pres_bg_model()

## Presence absence model

model <- bushfireSOS::fit_pres_abs_model()

## Hybrid model

model <- bushfireSOS::fit_hybrid_model()

########################
### Model Evaluation ###
########################

# Perform appropriate model checking

model_eval <- bushfireSOS::model_evaluation()

########################
### Model Prediction ###
########################

# Perform appropriate prediction

prediction <- bushfireSOS::model_prediction()

###########################
### Zonation Formatting ###
###########################

# Any special steps required to set things up for Zonation?

#################
### Meta Data ###
#################

# Store meta data relevant to analysis

meta_data <- bushfireSOS::meta_data()

