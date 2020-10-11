#!/bin/bash

for i in {1..10}
do
  
  for j in {1..10}
  do
  
    for k in {1..50}
    do
    
      JOB_NAME="DM_${i}_${j}_${k}"
    
      OUT_NAME="/data/gpfs/projects/punim0231/process_explicit_sdms/outputs/slurm_outputs/DM_${i}_${j}_${k}.out"
    
      sbatch --job-name=$JOB_NAME --output=$OUT_NAME /data/gpfs/projects/punim0231/process_explicit_sdms/scripts/slurm/master_slurm.slurm $i $j $k
  
    done
    
  done
  
done
