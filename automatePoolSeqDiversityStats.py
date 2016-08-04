#!/usr/bin/env python

import argparse
import sys
import os
import getopt
import glob
from subprocess import call
import shlex

####################################################################
##This script is generic. Modify!
####################################################################


class FullPaths(argparse.Action):
    """Expand user- and relative-paths"""
    def __call__(self, parser, namespace, values, option_string=None):
        setattr(namespace, self.dest,
            os.path.abspath(os.path.expanduser(values)))

def listdir_fullpath(d):
    return [os.path.join(d, f) for f in os.listdir(d)]

def is_dir(dirname):
    """Checks if a path is a directory"""
    if not os.path.isdir(dirname):
        msg = "{0} is not a directory".format(dirname)
        raise argparse.ArgumentTypeError(msg)
    else:
        return dirname
        
def is_file(filename):
    """Checks if a file exists"""
    if not os.path.isfile(filename):
        msg = "{0} is not a file".format(filename)
        raise argparse.ArgumentTypeError(msg)
    else:
        return filename

def get_arguments(): 
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(
        description="Merge individual sample VCFs into a project VCF")
    parser.add_argument('-p', '--prefix', required=True,
        help = 'sample prefix, eg ERR#, ERR1.noIndel.mpileup')
    parser.add_argument('-c', '--coverage', default=50,
        help = 'desired coverage for subsampling')
    parser.add_argument('-r', '--removereg', 
        help = 'gtf file containing regions to be removed',
        type = is_file,
        required=True)
    return parser.parse_args()

args = get_arguments()

def remReg():
    call("perl /opt/PepPrograms/popoolation_1.2.2/basic-pipeline/filter-pileup-by-gtf.pl --input {0}.noIndel.mpileup --gtf {1} --output {0}.filtered.mpileup".format(args.prefix, args.removereg), shell=True)

def SubSample():
    call("perl /opt/PepPrograms/popoolation_1.2.2/basic-pipeline/subsample-pileup.pl --input {0}.filtered.mpileup --output {0}_rand{1}.mpileup --target-coverage {2} --max-cov 1000000 --min-qual 20 --fastq-type sanger --method withoutreplace".format(args.prefix, i, args.coverage), shell=True)

def pi():
    call("perl /opt/PepPrograms/popoolation_1.2.2/Variance-sliding.pl --measure pi --pool-size 10000 --fastq-type sanger --min-count 2 --min-covered-fraction 0.5 --window-size 100000 --step-size 10000 --input {0}_rand{i}.mpileup --output {0}_rand{1}_w100K_n10K.pi --snp-output {0}_rand{1}.snps".format(args.prefix, i), shell=True)

def theta():
    call("perl /opt/PepPrograms/popoolation_1.2.2/Variance-sliding.pl --measure theta --pool-size 10000 --fastq-type sanger --min-count 2 --min-covered-fraction 0.5 --window-size 100000 --step-size 10000 --input {0}_rand{1}.mpileup --output {0}_rand{1}_w100K_n10K.theta".format(args.prefix, i), shell=True)

remReg()
for i in range(10) :
    SubSample()
    pi()
    theta()
