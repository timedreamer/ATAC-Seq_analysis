SAMPLES, = glob_wildcards("../data/raw_fastq/{id}.fastq.gz")
print(SAMPLES)

configfile: 'exp_settings.yaml'

BT2INDEX = config['BT2INDEX']

# REFGENOME = config['REFGENOME']

LENGTH_CUT = config['LENGTH_CUT']

# Rules -----------------------------------------------------------------------------------
localrules: all

rule all:
    input:
        # fastp result
        expand('../data/trim_fastq/{sample}_fastp.html', sample=SAMPLES),

        # BT2 alignment
        expand('../data/aligned_bam/{sample}.bam', sample=SAMPLES),

rule QC_ADAPTERS:
    input:
        r1 = "../data/raw_fastq/{sample}.fastq.gz",
    output:
        o1 = "../data/trim_fastq/{sample}_trimed.fq.gz",
        html = "../data/trim_fastq/{sample}_fastp.html",
        json = "../data/trim_fastq/{sample}_fastp.json"
    resources: cpus=2, time_min=20, mem_mb=8000,

    shell:
       'fastp -q 20 -l {LENGTH_CUT} --thread {resources.cpus} -y -a CTGTCTCTTATA \
       -i {input.r1} -o {output.o1} -h {output.html} -j {output.json}'

## BT2 alignment
rule BT2_ALIGN:
    input:  
        o1 = "../data/trim_fastq/{sample}_trimed.fq.gz",
    output: 
        bam = "../data/aligned_bam/{sample}.bam",
    resources: cpus=9, time_min=30, mem_mb=30000,
    log:
        bt2 = "00logs/bt2_{sample}.log",
    message: "aligning {input}: {resources.cpus} threads",

    shell:"""
        module purge && module load bowtie2/2.4.2 &&
        module load samtools/intel/1.11 &&
        bowtie2 --very-sensitive -k 10 -p 6 -U {input} -x {BT2INDEX} 2>{log.bt2}|samtools view -u - |samtools sort -n -m 4G -@ 2 -o {output.bam} 
        """

