#!/usr/bin/bash

# Run one script for all the jobs

job1=$(sbatch 01_download_fastq.slurm)
job1id=`echo $job1|awk '{print $NF}'`

job2=$(sbatch --dependency=afterok:$job1id 02_submit_snake.slurm)
job2id=`echo $job2|awk '{print $NF}'`

job3=$(sbatch --dependency=afterok:$job2id 03_call_peaks.slurm)
