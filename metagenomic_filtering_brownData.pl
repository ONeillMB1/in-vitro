#!/usr/bin/perl -w

#metagenomic filtering stats


use strict;
use File::Basename;

my $sam = "/opt/PepPrograms/samtools-1.2/samtools";

my @files = @ARGV; #list of bam files
open (STATS, ">>", "kraken_stats.txt") or die "couldn't open file for stats output: $?\n";
print STATS "sample\ttotalSeqs\tnumberClassified\ttotalMTBC\tfinalMTBC\n";

foreach my $file (@files) {

#start working on bam file, convert to fastq
	my $name = basename($file); 
	#print STDERR "$name\n";
	my ($sample, $temp1, $temp2) = split /\./, $name;
	my $fqOut = "${sample}.realn.fastq";
	print STDERR "Processing $sample [bam2fq]...\n";
	system "$sam bam2fq $file > $fqOut";
	#system "gzip $fqOut"; #can compress here, use other kraken option

#call kraken on fastqs
	
	#use below if inputting compressed fq
	#system "/opt/PepPrograms/kraken/kraken -preload --threads 8 --fastq-input --gzip-compressed --db /opt/PepPrograms/kraken/DB/ ${fqOut}.gz > ${sample}.kraken";
	print STDERR "Processing $sample [kraken]...\n";
	system "/opt/PepPrograms/kraken/kraken -preload --threads 8 --fastq-input --db /opt/PepPrograms/kraken/DB/ ${fqOut} > ${sample}.kraken";
#translate kraken file
	print STDERR "Processing $sample [kraken translate]...\n";
	system "/opt/PepPrograms/kraken/kraken-translate --db /opt/PepPrograms/kraken/DB/ ${sample}.kraken > ${sample}.kraken.labels";

#work on .kraken files
	open (IN, "<", "${sample}.kraken") or die "couldn't open $file: $?\n";
	print STDERR "Processing $sample [kraken output]...\n";
	my $numClass = 0;
	my $numUnclass = 0;
	# my $lengthsClass = 0;
	# my $lengthsUnclass = 0;
	# my $totalLength = 0;

	while (my $line = <IN>) {
		chomp $line;
		my ($class, $name, $tax, $length, $taxChain) = split "\t", $line;
		if ($class eq "C") {
			$numClass++;
			#$lengthsClass += $length;
		} elsif ($class eq "U") {
			$numUnclass++;
			#$lengthsUnclass += $length;
		} else {
			die "found an unexpected value in 1st column\n";
		}
		#$totalLength += $length;
	}
	my $totalSeqs = $numClass + $numUnclass;
	# my $fracClass = $numClass / $totalSeqs;
	# my $avgLength = $totalLength / $totalSeqs;
	# my $avgLengthC = $lengthsClass / $numClass;
	# my $avgLengthU = $lengthsUnclass / $numUnclass || "no seqs";
	#print STDOUT "Total sequences: $totalSeqs\nFraction classified: $fracClass\nAverage Length total: $avgLength\nAverage Length C: $avgLengthC\nAverage Length U: $avgLengthU\n";
	close IN;
	
#now work on output from kraken-translate
	print STDERR "Processing $sample [kraken labels]...\n";
	open (LABELS, "<", "${sample}.kraken.labels") or die "couldn't open labels file: $?\n";
	#open (ALLNAMES, ">>", "${sample}_MTBC_allSeqs.txt") or die "couldn't open file for all the seqs: $?\n";
	my %seqNames;
	my $totalMTBC = 0;
	while (my $line = <LABELS>) {
		chomp $line;
		my ($seq, $taxList) = split /\t/, $line;
	#now filter out non MTBC hits
		my @taxa = split /;/, $taxList;
		if (scalar @taxa < 9) {
			next;
		} elsif ($taxa[7] ne "Mycobacterium") {
			next;
		} else {
		#	print ALLNAMES "$seqName\n";
		 	$totalMTBC++;
		# }
	#now count the number if times each sequence appears, removing the trailing /[12]
		my $seqName = (split /\//, $seq)[0];
		$seqNames{$seqName}++;
		}
	}
#now filter against sequences where only 1 of the pair was assigned
	open (NAMES, ">>", "${sample}_MTBC_seqNames.txt") or die "couldn't open output for sequence names: $?\n";
	my $numMTBC = 0;
	foreach my $seqName (keys %seqNames) {
		if ($seqNames{$seqName} != 2) {
			next;
		} else {
			print NAMES "$seqName\n";
			$numMTBC++;
		}
	}

#now print some stats
	my $finalMTBC = 2 * $numMTBC;
	#print STDERR "Single end seqs: $diff\n";
	print STATS "$sample\t$totalSeqs\t$numClass\t$totalMTBC\t$finalMTBC\n";

#now filter the original bam file by sequence names
	print STDERR "Processing $sample [Picard FilterSamReads]...\n";
	system "java -Xmx8g -jar /opt/PepPrograms/picard-tools-1.138/picard.jar FilterSamReads INPUT=${sample}.realn.bam OUTPUT=${sample}_MTBCseqs.bam READ_LIST_FILE=${sample}_MTBC_seqNames.txt FILTER=includeReadList";

#now convert filtered bam to mpileup and do some further filtering on the mpileup
	print STDERR "Processing $sample [mpileup generation and filtering]...\n";
	#open (INBAM, "<", "${sample}_MTBCseqs.bam") or die "couldn't open BAM to generate mpileup: $?\n";
	system "$sam mpileup -B -Q 20 -f /opt/data/mbovis/mbovis_AF2122.fa ${sample}_MTBCseqs.bam > ${sample}_MTBCseqs.mpileup";
	system "perl /opt/PepPrograms/popoolation_1.2.2/basic-pipeline/identify-genomic-indel-regions.pl --input ${sample}_MTBCseqs.mpileup --output ${sample}_MTBCseqs_indelregs.gtf";
	system "perl /opt/PepPrograms/popoolation_1.2.2/basic-pipeline/filter-pileup-by-gtf.pl --input ${sample}_MTBCseqs.mpileup --gtf ${sample}_MTBCseqs_indelregs.gtf --output ${sample}_MTBCseqs_noIndel.mpileup";
	system "perl /opt/PepPrograms/popoolation_1.2.2/basic-pipeline/filter-pileup-by-gtf.pl --input ${sample}_MTBCseqs_noIndel.mpileup --gtf /opt/data/mbovis/mbovis_AF2122_exludeRegions.gff --output ${sample}_MTBCseqs_noIndel_remRegs.mpileup";
#remove all but the final mpileup (.noIndel.remRegs.mpileup)
	unlink "${sample}_MTBCseqs.mpileup";
	unlink "${sample}_MTBCseqs_noIndel.mpileup";
	unlink "$fqOut";
	unlink "${sample}.kraken.label";

}



