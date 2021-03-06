# ATAC-Seq analysis

Author: Ji Huang

This is the my note on the ATAC-Seq analysis.

## Background
There are many wonderful tutorials/notes on web and I learnt from them. Below to name a few:

1. [crazyhottommy /ChIP-seq-analysis](https://github.com/crazyhottommy/ChIP-seq-analysis)
2. [crazyhottommy pyflow-ATACseq ](https://github.com/crazyhottommy/pyflow-ATACseq)
3. [ATAC-seq data analysis: from FASTQ to peaks ](https://yiweiniu.github.io/blog/2019/03/ATAC-seq-data-analysis-from-FASTQ-to-peaks/)
4. [ATAC-seq Guidelines from Harvard FAS Informatics](https://informatics.fas.harvard.edu/atac-seq-guidelines.html)
5. [From reads to insight: a hitchhiker’s guide to ATAC-seq data analysis, 2020, Genome Biology](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-020-1929-3)

## Pipeline overview

My scripts is the basic one, including:
1. Download fast files from `EBI`. You can use [SRA-Explorer](https://sra-explorer.info/#) to find the URL for downloading fastq files. No need to start from `sra` files any more.
1. Adapter trimming with [fastp](https://github.com/OpenGene/fastp).
2. Reads mapping with Bowtie2.
3. Peak calling with [Genrich](https://github.com/jsh58/Genrich). The nice part of Genrich is *Genrich was designed to be able to run all of the post-alignment steps through peak-calling with one command.* No need to run `samtools`, `Picard` and all kinds of commands. However, Genrich is still not peer-reviewed/published, although it get used many times in papers.
4. Calculate Fraction of reads in peaks (FRiP).

According to [ENCODE term](https://www.encodeproject.org/data-standards/terms/#enrichment):
> Fraction of reads in peaks (FRiP) – Fraction of all mapped reads that fall into the called peak regions, i.e. usable reads in significantly enriched peaks divided by all usable reads. In general, FRiP scores correlate positively with the number of regions. (Landt et al, Genome Research Sept. 2012, 22(9): 1813–1831)

For [ATAC-Seq](https://www.encodeproject.org/atac-seq/),
> The fraction of reads in called peak regions (FRiP score) should be >0.3, though values greater than 0.2 are acceptable. For EN-TEx tissues, FRiP scores will not be enforced as QC metric. TSS enrichment remains in place as a key signal to noise measure.

I mostly follow the `ATAC-seq Guidelines from Harvard FAS Informatics`.

## Pipeline details

You can run step 1,2,3 sequentially, or run `submit_all.sh` to submit all three jobs.

1. `01_download_fastq.slurm`: download fastq files.
2. `02_submit_snake.slurm`: run the adapter cleaning and Bowtie2 alignment step.
3. `03_call_peaks.slurm`: call peaks with Genrich.
4. `submit_all.sh`: if you set up correctly, you can just run this bash script which including the above three jobs.
5. `calc_FRiP.slurm`: calculate FRiP.

## Misc

1. To get the maize contigs name that we want to **exclude** from Genrich peak calling, you can run `grep "^B" zmav4.chr.length.txt |cut -f1|sed -z 's/\n/,/g;s/,$/\n/'`.
2. The example code is to re-analyze the maize protoplast ATAC-Seq data in [3D Chromatin Architecture of Large Plant Genomes Determined by Local A/B Compartments, 2017 Molecular Plant](https://www.sciencedirect.com/science/article/pii/S1674205217303398?via%3Dihub).
3. To get the sum base pair of the peak regions, ` awk '{$4=$3-$2; sum+=$4} END {print sum}' SRR5748809_10_ATAC_Zma_leaf_mesophyll.narrowPeak`. The result is `22856828` or 22.9Mb.

