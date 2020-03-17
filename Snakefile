configfile: "config.yaml"

rule all:
    input:
        expand("sorted/{sample}.sorted.bam.bai", sample=config["samples"]),
        expand("fastqc/{sample}_fastqc.zip", sample=config["samples"])


rule fastqc:
    input:  
        "data/{sample}.fastq.gz"
    output: 
        "fastqc/{sample}_fastqc.zip", "fastqc/{sample}_fastqc.html"
    log:    
        "fastqclog/{sample}_fastqc"
    shell:
        "fastqc -o fastqc -f fastq --noextract {input} 2> {log}"
    

#Trim reads using cutadapt
rule trim:
    input:
        "data/{sample}.fastq.gz"
    output:
        "trimmed/{sample}_trimmed.fastq.gz"
    shell:
       "cutadapt -q {config[trim_quality]} --cores={config[trim_cores]} {config[trim_params]} -o {output} {input}"

#Align reads using bowtie, remove unmapped reads and sort bam files
rule align:
   input:
       "trimmed/{sample}_trimmed.fastq.gz"
   output:
       "sorted/{sample}.sorted.bam"
   log:
        bowtie = "log/{sample}.align",
        samtools = "log/{sample}.sort"
   params:
        p1 = "{sample}.sam"
       
   shell:
       "bowtie {config[bowtie_idx]} -q {input} -S 2> {log.bowtie}| samtools view -Sb -F 4 - | samtools sort {config[sort_params]} -o {output} 2> {log.samtools}"

#Index bam files
rule index_bam:
    input:  
        "sorted/{sample}.sorted.bam"
    output: 
        "sorted/{sample}.sorted.bam.bai"
    log:    
        index = "log/{sample}.index_bam"
    shell:
        "samtools index {input} 2> {log.index}"