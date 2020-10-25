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

## Species: Antechinus stuartii
## Guild: Mammals
## Region: NSW, QLD
## Analyst:
## Reviewer:
## SDM Required: Y/N
## Used existing SDM: Y/N
## Built SDM: Y/N
## Data available: PO/PA
## Type of SDM: PresBG/PresAbs/Hybrid
## Number of presence records:
## Number of background points:
## Type of background points:
## Date completed:
## Any other comments:

species <- "Antechinus stuartii"

guild <- "Mammals"

date_cutoff <- "1990-01-01"

uncertainty_cutoff <- 1000

#####################
### Load Packages ###
#####################

.libPaths("/home/davidpw/R/lib/3.6")

library(bushfireSOS)

#########################
### Load Species Data ###
#########################

# Load appropriate species data.

# Comment out unused methods instead of deleting them in case more
# data becomes available at a later date

## Presence background data

# spp_data <- bushfireSOS::load_pres_bg_data_AUS(species = species,
#                                                region = c("VIC", "NSW", "QLD", "SA", "NT", "WA", "TAS"),
#                                                save.map = FALSE,
#                                                map.directory = "outputs_1990/data_outputs",
#                                                email = "dbrizuela@student.unimelb.edu.au",
#                                                dir.NSW = "bushfireResponse_data/spp_data_raw",
#                                                dir.QLD = "bushfireResponse_data/spp_data_raw",
#                                                dir.WA = "bushfireResponse_data/spp_data_raw",
#                                                dir.SA = "bushfireResponse_data/spp_data_raw",
#                                                dir.VIC = "bushfireResponse_data/spp_data_raw",
#                                                file.VIC = "bushfireResponse_data/VBA_data_inverts_plants_updated_verts_0209202/original_spp_list",
#                                                file.SA = "bushfireResponse_data/spp_data_raw/BIODATAREQUESTS_table_UniMelbourne.xlsx",
#                                                file.BirdLife = "bushfireResponse_data/spp_data_raw/BirdLife/BirdLife_data.csv",
#                                                date.cutoff = date_cutoff,
#                                                uncertainty.cutoff = uncertainty_cutoff)
# 
# # spp_data$map
# 
# region <- bushfireSOS::species_data_get_state_character(spp_data$data)
# 
# ## Presence absence data
# 
# # spp_data <- bushfireSOS::load_pres_abs_data(species,
# #                                             region)
# 
# ## Preliminary presence records check
# ## If <20 can end workflow here
# 
# nrow(spp_data$data)
# 
# saveRDS(spp_data,
#         sprintf("bushfireResponse_data/outputs_1990/spp_data_tmp/spp_data_%s.rds",
#                 gsub(" ", "_", species)))

spp_data <- readRDS(sprintf("bushfireResponse_data/outputs_1990/spp_data_tmp/spp_data_%s.rds",
                            gsub(" ", "_", species)))

region <- bushfireSOS::species_data_get_state_character(spp_data$data)

###############################
### Load Environmental Data ###
###############################

# Load appropriate environmental raster data

env_data <- bushfireSOS::load_env_data(stack_dir = "bushfireResponse_data/spatial_layers/raster_tiles",
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
                                           sample_min = 100000)

## Check that there are >= 20 presences (1s) and an appropriate number of
## background points (1000 * number of states with data for target group,
## or 10,000 for random)

table(spp_data$data$Value)

#######################
### Data Extraction ###
#######################

spp_data <- bushfireSOS::env_data_extraction(spp_data = spp_data,
                                             env_data = env_data)

# bushfireSOS::map_sp_data(spp_data,
#                          only_presences = TRUE)

saveRDS(spp_data,
        sprintf("bushfireResponse_data/outputs_1990/spp_data/spp_data_%s.rds",
                gsub(" ", "_", species)))

#####################
### SDM Required? ###
#####################

# Do we have >=20 presence records?
# Y/N

# Can we fit an SDM for this species?
# Y/N 

# If no, how should we create an output for Zonation?

#########################
### Use Existing SDM? ###
#########################

# Can we use an existing SDM for this species?
# Y/N

# If yes, how should we ensure its suitable for our purposes?

if(nrow(spp_data$data[spp_data$data$Value == 1, ]) >= 20){
  
  print("At least 20 presence records")
  
  # feature_options <- c("default",
  #                      "lqp",
  #                      "lq",
  #                      "l")
  # 
  ########################
  ### Model Evaluation ###
  ########################
  
  # Perform appropriate model checking
  # Ensure features is set identical to that of the above full model
  # If Boyce Index returns NAs then re-run the cross-validation with
  #  one fewer fold i.e. 5 > 4 > 3 > 2 > 1
  
  # for(feat in feature_options){
  #   
  #   features <- feat
  #   
  model_eval <- tryCatch(expr = bushfireSOS::cross_validate(spp_data = spp_data,
                                                            type = "po",
                                                            k = 5,
                                                            # parallel = FALSE,
                                                            filepath = sprintf("bushfireResponse_data/outputs_1990/model/MaxEnt_outputs_CV/%s",
                                                                               gsub(" ", "_", species))),
                         err = function(err){ return(NULL) })
  
  #   if(!is.null(model_eval)){
  #     break()
  #   }
  #   
  # }
  
  if(!is.null(model_eval)){
    
    print("Model evaluation complete, fitting full model")
    
    saveRDS(model_eval,
            sprintf("bushfireResponse_data/outputs_1990/model_eval/model_eval_%s.rds",
                    gsub(" ", "_", species)))
    
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
                                            filepath = sprintf("bushfireResponse_data/outputs_1990/model/MaxEnt_outputs/%s",
                                                               gsub(" ", "_", species)))
    
    saveRDS(model,
            sprintf("bushfireResponse_data/outputs_1990/model/model_%s.rds",
                    gsub(" ", "_", species)))
    
    ## Presence absence model
    
    # model <- bushfireSOS::fit_pres_abs_model()
    
    ## Hybrid model
    
    # model <- bushfireSOS::fit_hybrid_model()
    
    ########################
    ### Model Prediction ###
    ########################
    
    # Perform appropriate prediction
    
    prediction <- bushfireSOS::model_prediction(model = model,
                                                env_data = env_data,
                                                mask = "bushfireResponse_data/spatial_layers/NIAFED_v20200428",
                                                parallel = FALSE)
    
    raster::writeRaster(prediction,
                        sprintf("bushfireResponse_data/outputs_1990/predictions/predictions_%s.tif",
                                gsub(" ", "_", species)),
                        overwrite = TRUE)
    
    prediction_threshold <- bushfireSOS::predict_threshold(pred_ras = prediction,
                                                           threshold = model_eval[3])
    
    raster::writeRaster(prediction_threshold,
                        sprintf("bushfireResponse_data/outputs_1990/predictions/predictions_%s_threshold.tif",
                                gsub(" ", "_", species)),
                        overwrite = TRUE)
    
    # mapview::mapview(prediction)
    
  } else{
    
    print("Model evaluation failed")
    
  } 
  
} else {
  
  print("Less than 20 records, no model fit")
  
}

#################
### Meta Data ###
#################

# Store meta data relevant to analysis

meta_data <- sessionInfo()

saveRDS(meta_data,
        sprintf("bushfireResponse_data/outputs_1990/meta_data/meta_data_%s.rds",
                gsub(" ", "_", species)))
