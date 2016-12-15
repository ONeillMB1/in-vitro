#!/bin/bash

java -Xmx8g -jar /opt/PepPrograms/picard-tools-1.138/picard.jar FilterSamReads I=${sample}.realn.bam O=${sample}_MTBCseqs.bam READ_LIST_FILE=${sample}_Mycobacterium_seqNames.txt FILTER=includeReadList
