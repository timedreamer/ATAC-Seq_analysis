#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0:40:00
#SBATCH --mem=4GB
#SBATCH --job-name=fastqDownload
#SBATCH --mail-type=NONE
#SBATCH --mail-user=jh6577@nyu.edu

mkdir -p ../data/raw_fastq

curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR574/000/SRR5748810/SRR5748810.fastq.gz -o ../data/raw_fastq/SRR5748810_ATAC-seq_of_Zea_mays_leaf_mesophyll.fastq.gz &&
curl -L ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR574/009/SRR5748809/SRR5748809.fastq.gz -o ../data/raw_fastq/SRR5748809_ATAC-seq_of_Zea_mays_leaf_mesophyll.fastq.gz &&

echo "Sucess! Fastq file are downloaded"
