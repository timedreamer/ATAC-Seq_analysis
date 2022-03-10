#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=2:10:00
#SBATCH --mem=2GB
#SBATCH --job-name=smkATAC
#SBATCH --mail-type=NONE
#SBATCH --mail-user=jh6577@nyu.edu

# launch snakemake to run jobs on NYU Greene via SLURM

# load modules.
# Each job's module is loaded within each job.

module purge
module load snakemake/6.12.3

snakemake --profile slurm -s atac_se_pipeline_bt2.smk

