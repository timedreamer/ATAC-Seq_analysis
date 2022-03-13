#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=00:10:00
#SBATCH --mem=6GB
#SBATCH --job-name=FRiP
#SBATCH --mail-type=NONE
#SBATCH --mail-user=jh6577@nyu.edu

module purge

DIR="/scratch/jh6577/maize/atac_all/protoplast_dong_2017/"

# Modified from https://www.biostars.org/p/337872/

# Generate SAF file for featureCounts
awk 'OFS="\t" {print $1"-"$2+1"-"$3, $1, $2+1, $3, "+"}' $DIR/result/genrich/SRR5748809_10_ATAC_Zma_leaf_mesophyll.narrowPeak > $DIR/result/genrich/SRR5748809_10_ATAC_Zma_leaf_mesophyll.saf;

# Count reads/fragments within peaks.
featureCounts -p -a $DIR/result/genrich/SRR5748809_10_ATAC_Zma_leaf_mesophyll.saf -F SAF -o temp_result.txt $DIR/data/aligned_bam/SRR5748809_ATAC-seq_of_Zea_mays_leaf_mesophyll.bam $DIR/data/aligned_bam/SRR5748810_ATAC-seq_of_Zea_mays_leaf_mesophyll.bam 2>$DIR/result/genrich/SRR5748809_10_peak_FRiP.txt;

rm temp_result*


