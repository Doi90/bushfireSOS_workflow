#!/bin/bash
#
# Set required nodes.
#SBATCH --nodes=1
#
# Set up nodes for job. 
#SBATCH --ntasks=1
#
# Set partition
#SBATCH -p "physical"
#
# Set number of CPUs
#SBATCH --cpus-per-task=1
#
# Set memory limit
#SBATCH --mem=60000
#
# Set wall time
#SBATCH --time=1-00
#
# Set job name
#SBATCH --job-name="S.rosei"
#    
# Set output file
#SBATCH --output="/data/gpfs/projects/punim0200/bushfireSOS_workflow/bushfireResponse_data/outputs/slurm_outputs/Saproscincus_rosei_1990.out"
#
# Set email notifications
#SBATCH --mail-user=davidpw@student.unimelb.edu.au
#SBATCH --mail-type=ALL,TIME_LIMIT_50,TIME_LIMIT_80,TIME_LIMIT_90

module purge

module load proj/6.2.1
module load gcc/8.3.0  
module load openmpi/3.1.4
module load gdal/3.0.2-python-3.7.4
module load rgdal/1.4-4-r-3.6.0
module load geos/3.7.2-python-3.7.4
module load netcdf/4.7.1
module load nodejs
module load r/3.6.0

export http_proxy=http://wwwproxy.unimelb.edu.au:8000
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy

cd /data/gpfs/projects/punim0200/bushfireSOS_workflow

Rscript --vanilla scripts/workflows_spartan/Saproscincus_rosei_workflow_1990.R 