#!/bin/bash

perl /opt/PepPrograms/popoolation_1.2.2/basic-pipeline/identify-genomic-indel-regions.pl --input ${sample}_MTBCseqs.mpileup --output ${sample}_MTBCseqs_indelregs.gtf

perl /opt/PepPrograms/popoolation_1.2.2/basic-pipeline/filter-pileup-by-gtf.pl --input ${sample}_MTBCseqs.mpileup --gtf ${sample}_MTBCseqs_indelregs.gtf --output ${sample}_MTBCseqs_noIndel.mpileup

perl /opt/PepPrograms/popoolation_1.2.2/basic-pipeline/filter-pileup-by-gtf.pl --input ${sample}_MTBCseqs_noIndel.mpileup --gtf /opt/data/mbovis/mbovis_AF2122_exludeRegions.gff --output ${sample}_MTBCseqs_noIndel_remRegs.mpileup
