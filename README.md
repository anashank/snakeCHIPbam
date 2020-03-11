# snakeCHIPbam
Snakemake pipeline for obtaining sorted and indexed BAM files after read trimming using cutadapt and alignment using bowtie

# Before running
In the `config.yaml` file you should include details of samples to be analyzed and required bowtie index paths etc. You can also specify custom options for the trimming and alignment steps.

### Dependiencies
* [snakemake](https://snakemake.readthedocs.io/en/stable/)
* [bowtie](https://anaconda.org/bioconda/bowtie)
* [samtools](http://www.htslib.org/)
* [cutadapt](https://cutadapt.readthedocs.io/en/stable/)
