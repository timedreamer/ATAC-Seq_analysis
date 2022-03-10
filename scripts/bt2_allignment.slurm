#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=11
#SBATCH --time=1:00:00
#SBATCH --mem=30GB
#SBATCH --job-name=bt2atac
#SBATCH --mail-type=NONE
#SBATCH --mail-user=jh6577@nyu.edu

module purge
module load bowtie2/2.4.2
module load samtools/intel/1.11

BT2INDEX="/scratch/cgsb/coruzzi/jh6577/GenomeFile/maizeV4/bowtie2_index/bt2_zmv4_index"

echo "Start alligning SRR5748809_trim.fq.gz..."

bowtie2 --very-sensitive -k 10 -p 8 -U SRR5748809_trim.fq.gz -x $BT2INDEX 2>SRR5748809_bt2.log|samtools view -u - |samtools sort -n -m 4G -@ 2 -o SRR5748809_trim.bam &&
echo "Done!"

echo "Start alligning SRR5748810_trim.fq.gz..."

bowtie2 --very-sensitive -k 10 -p 8 -U SRR5748810_trim.fq.gz -x $BT2INDEX 2>SRR5748810_bt2.log|samtools view -u - |samtools sort -n -m 4G -@ 2 -o SRR5748810_trim.bam
echo "Done!"


# Genrich -t SRR5748809_trim.bam,SRR5748810_trim.bam -j -y -r -e Pt,Mt -v -o SRR5748809_10_ATAC_Zma_leaf_mesophyll.narrowPeak
