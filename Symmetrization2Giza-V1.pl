#!/usr/bin/perl


#***********************************************Copyright and License ********************************************************************************************

#ACT for Accuracy of Connective Translation is a reference-based metric to measure the accuracy of discourse connective translation. 

#Copyright (c) 2013 Idiap Research Institute, http://www.idiap.ch/

#Written by Najeh Hajlaoui <Najeh.Hajlaoui@idiap.ch>  or  <Najeh.Hajlaoui@gmail.com>

#This file is part of ACT.
#ACT is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License version 3 as published by the Free Software Foundation.
#ACT is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
#You should have received a copy of the GNU General Public License along with ACT. If not, see <http://www.gnu.org/licenses/>.
#***********************************************End of Copyright and License ********************************************************************************************



# perl Symmetrization2Giza-V1.pl Scr.toact Ref.toact Src-Ref.toact.en-fr.grow-diag-final-and
#or
# perl Symmetrization2Giza-V1.pl Scr.toact Cand.toact Src-Cand.toact.en-fr.grow-diag-final-and
#.toact is the output of ACT-preprocess-xx_yy-V1.4.pl (xx_yy depending on the language pair)

if (not @ARGV){
	print "Usage: Symmetrization2Giza source target alignment \n";
	print "\tsource: a file containing one sentence per line\n";
	print "\ttarget: a file containing one sentence perl line\n";
	print "\talignment: same format as produced by simmetrized giza\n";
	exit -1;
}

my ($sourceFile,$targetFile,$alignmentFile) = @ARGV;


open(S,$sourceFile);
open(T,$targetFile);
open(A,$alignmentFile);

my %phraseTable; # $table{$t}{$s}
my $numberofsentence=1;

while( my $sourceLine = <S> and my $targetLine = <T> and my $alignmentLine = <A>)
{

	my @source=();
    my @target=();
    my @points=();
    my %ST=();
    
       
    $copietargetLine=$targetLine;
	
	# get words and alignment points
	chomp($sourceLine, $targetLine, $alignmentLine);
	my @source = split(/ /,$sourceLine); # f
	my @target = split(/ /,$targetLine); # e
	my @points = split(/ /,$alignmentLine);
	my %ST;
	my %TS;

	# maps source into target and vice-versa
	foreach my $point (@points)
    {
		my ($s,$t) = split (/-/,$point);
		$ST{$s}{$t} = 1;
		$TS{$t}{$s} = 1;
	}	
	
    $nbreDeMotsSource=@source;
    $nbreDeMotsTarget=@target;
    print "\# Sentence pair ($numberofsentence) source length $nbreDeMotsSource target length $nbreDeMotsTarget alignment score : ......\n";
    print "$copietargetLine";
    $numberofsentence++;
    for ($src=0;$src<$nbreDeMotsSource;$src++)
    #foreach my $src ( sort keys %ST)
    {
        
        my @ListCands=();
        my @SortListCands=();

        
        print "$source[$src] ({ "; 
        #foreach my $cand (keys %{$ST{$src}}) 
      
        foreach my $cand (keys %{$ST{$src}}) 
        #foreach my $target ($ST{$source}{$t})
        {
            #print "$cand " if $ST{$src}{$cand}; 
            @ListCands = (@ListCands,$cand);
        }
        
        #Tri numérique de la liste des chiffres pour former la suite des mots
        sub par_num { return $a <=> $b }
        @SortListCands = sort par_num @ListCands;
        
        
        
        foreach my $elemt (@SortListCands) 
        {
            $elementPlusUn=$elemt+1;
            print "$elementPlusUn " if $ST{$src}{$elemt}; 
        }

        print "}) "; 

    }
   print "\n"; 
}#end While


