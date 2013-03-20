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




# *********How to use this script*********
# perl ACT-preprocess-en_de-V1.x.pl SOURCE REFERENCE CANDIDATE  
#SOURCE REFERENCE and CANDIDATE have to be lowercased and tokenised 
#The output files (Scr, Ref and Cand) will be created in the $WorkingDir (see your config file)

open (CONFIGACT,"<./ACT-V1.7.config")|| die ("Can't open ACT-V1.7.config  \n");


while(  $Line = <CONFIGACT> )
{
    chomp($Line);
    if ( ($Line =~ /^(\$WorkingDir)\=(.*)\;/))
    {
        $WorkingDir=$2 if ($1 eq "\$WorkingDir");
       
    }	
}#end While


my $File1=$ARGV[0];
open (SCR,"<$File1")|| die ("Cannot open SCR  \n");

my $File2=$ARGV[1];
open (REF,"<$File2")|| die ("Cannot open REF  \n");

my $File3=$ARGV[2];
open (CAND,"<$File3")|| die ("Cannot open CAND  \n");

if( scalar( @ARGV ) < 3 ) {
    print "Error - Invalid command line \n";
    exit;
}


#************Preprocessing step *************


open (SCR1,">$WorkingDir/Scr")|| die ("can't open SCR1\n");
open (REF1,">$WorkingDir/Ref")|| die ("can't open REF1\n");
open (CAND1,">$WorkingDir/Cand")|| die ("can't open CAND1\n");


$Csource="";
print "****************** Preprocessing of the source *************************\n";
print "****************** Preprocessing of the reference *************************\n";
print "****************** Preprocessing of the candidate *************************\n";

while (($Ligne1=<SCR>) and ($Ligne2=<REF>) and ($Ligne3=<CAND>))

{
   
    #****************** Preprocessing of the source *************************

    while ($Ligne1 =~ /^(.*?)(even though)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/) 
    {
        $Csource="even though";
        if ($2 eq $Csource)
        {
            $Csource="eventhough";
            $Ligne1= "$1$Csource$3$4";
            
        }
    }
    
    while ($Ligne1 =~ /^(.*?)(as though)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Csource="as though";
        if($2 eq $Csource)
        {
            $Csource="asthough";
            $Ligne1= "$1$Csource$3$4";
        }
    }
     while ($Ligne1 =~ /^(.*?)(not yet)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
      $Csource="not yet";
    if($2 eq $Csource)
    {
     $Csource="notyet";
     $Ligne1= "$1$Csource$3$4";
    }
     }
   
    #*************************Preprocessing of the reference*************************
   
    # converting &apos; et ’  to '
    $Ligne2 =~ s/\&apos\;|\’/\'/g;
        

    #Preprocessing of multi-words and normalisation
    #
    #while ($Ligne2 =~ /^(.*?)(auch wenn|wenn auch|aber auch|selbst wenn|aber dennoch|aber doch|als wenn|so als|so auch|als ob|selbst wenn|lange vor|so lange|bei gleichzeitige(r|m)|während gleichzeitig|zur gleichen Zeit|in der Zwischenzeit|während dessen|bis dahin|bisher noch|nach wie vor|selbst wenn|zunächst einmal)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    while ($Ligne2 =~ /^(.*?)(auch wenn|wenn auch|aber auch|selbst wenn|aber dennoch|aber doch|als wenn|so als|so auch|als ob|selbst wenn|lange vor|so lange|bei gleichzeitige(r|m)|während gleichzeitig|zur gleichen zeit|in der zwischenzeit|während dessen|bis dahin|bisher noch|nach wie vor|selbst wenn|zunächst einmal)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        
        $Creference=$2;
        $Creferencecopy=$2;
        $Creferencecopy =~ s/ //g;   
        $Ligne2 =~ s/$Creference/$Creferencecopy/g;   
    }
    
    #**************Preprocessing of the candidate*************************
  
    # converting &apos; et ’  to '
    $Ligne3 =~ s/\&apos\;|\’/\'/g;
        
    #Preprocessing of multi-words and normalisation
    #
    while ($Ligne3 =~ /^(.*?)(auch wenn|wenn auch|aber auch|selbst wenn|aber dennoch|aber doch|als wenn|so als|so auch|als ob|selbst wenn|lange vor|so lange|bei gleichzeitige(r|m)|während gleichzeitig|zur gleichen zeit|in der zwischenzeit|während dessen|bis dahin|bisher noch|nach wie vor|selbst wenn|zunächst einmal)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        
        $Creference=$2;
        $Creferencecopy=$2;
        $Creferencecopy =~ s/ //g;   
        $Ligne3 =~ s/$Creference/$Creferencecopy/g;   
    }
    
    
    
    #print results
    print SCR1 "$Ligne1";
    print REF1 "$Ligne2";
    print CAND1 "$Ligne3";



}
close(SCR1);
close(REF1);
close(CAND1);

close(SCR);
close(REF);
close(CAND);

close(CONFIGACT);


#************End Preprocessing step *************
