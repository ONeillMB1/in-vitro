#!/bin/bash

/opt/PepPrograms/samtools-1.2/samtools mpileup -B -Q 20 -f /opt/data/mbovis/mbovis_AF2122.fa ${sample}_MTBCseqs.bam > ${sample}_MTBCseqs.mpileup
