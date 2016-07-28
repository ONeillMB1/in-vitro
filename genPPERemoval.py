#!/usr/bin/env python

import sys

# Takes a human readable file with genomic postion as the second column and abed file of regions to be removed. 

# check for correct commandline arguments
if len(sys.argv) != 4 :
	print("Usage:  GenPPERemoval.py  <infile>  <bed regions> <output>")
	sys.exit(0)

# obtain proper I/O files
InFileFastaName = sys.argv[1]
InFileStartName = sys.argv[2]
#InFileEndName = sys.argv[3]
OutFileName = sys.argv[3]

# open I/O files for editing
InVcf = open(InFileFastaName, 'r')
InStart = open(InFileStartName, 'r')
#InEnd = open(InFileEndName, 'r')
OutFile = open(OutFileName, 'w')

# make two integer lists--one for start locations and one for end locations
StartList = []
EndList = []
for Line in InStart :
    Line = Line.strip().split()
    StartList.append(int(Line[1]))
    EndList.append(int(Line[2]))

# process vcf file
Header = ""  # store file header for later re-print
LineCount = 0
EndCount = 0
PPE = False

for Line in InVcf :
    # print all header lines to output
    if "#" in Line :
        OutFile.write(Line)
        LineCount = LineCount + 1
    # for non-header lines, check if position is in PPE region
    else :
        Tokens = Line.split()
        Position = int(Tokens[1])
        for End in EndList :
            if (Position <= End and Position >= StartList[EndCount]) :
                PPE = True
                print(StartList[EndCount], Position, End)
            EndCount = EndCount + 1
        # if not in PPE region, print to output file
        if not(PPE) :
             OutFile.write(Line)
    PPE = False
    EndCount = 0

# close all used files
OutFile.close()
InStart.close()
#InEnd.close()
InVcf.close()
