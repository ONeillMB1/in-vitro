#!/bin/bash

perl /opt/PepPrograms/kraken/kraken -preload --threads 8 --fastq-input --db /opt/PepPrograms/kraken/DB/ ${sample}.realn.fastq > ${sample}.kraken

perl /opt/PepPrograms/kraken/kraken-translate --db /opt/PepPrograms/kraken/DB/ ${sample}.kraken > ${sample}.kraken.labels
