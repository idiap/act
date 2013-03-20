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
# perl ACT-preprocess-en_it-V1.x.pl SOURCE REFERENCE CANDIDATE  
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

    #normalisation of "pur" and "pure"
    while ($Ligne2 =~ /^(.*?)( pur)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference=" pure";
        $Ligne2= "$1$Creference$3$4";
        
    }
    #normalisation of "dallo" 
    while ($Ligne2 =~ /^(.*?)(dallo)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da lo";
        $Ligne2= "$1$Creference$3$4";
        
    }
     #normalisation of "dall'"
    while ($Ligne2 =~ /^(.*?)(dall\'|dall \')(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da l'";
        $Ligne2= "$1$Creference$3$4";
        
    }
    
    #normalisation of "dai'"
    while ($Ligne2 =~ /^(.*?)(dai)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da i";
        $Ligne2= "$1$Creference$3$4";
        
    }
    #normalisation of "dagli'"
    while ($Ligne2 =~ /^(.*?)(dagli)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da gli";
        $Ligne2= "$1$Creference$3$4";
        
    }
    #normalisation of "dalle'"
    while ($Ligne2 =~ /^(.*?)(dalle)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da le";
        $Ligne2= "$1$Creference$3$4";
        
    }
    
    
    
    
    
    #normalisation of "della" 
    while ($Ligne2 =~ /^(.*?)(della|dell\'|dell \')(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="di la";
        $Ligne2= "$1$Creference$3$4";
        
    }
    #normalisation of "dalla" 
    while ($Ligne2 =~ /^(.*?)(dalla)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da la";
        $Ligne2= "$1$Creference$3$4";
        
    }
    
    #normalisation of "dal|dall" 
    while ($Ligne2 =~ /^(.*?)(dal|dall)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da il";
        $Ligne2= "$1$Creference$3$4";
        
    }
    #normalisation of "del|dell" 
    while ($Ligne2 =~ /^(.*?)(del|dell)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="di il";
        $Ligne2= "$1$Creference$3$4";
        
    }
    
    #anche se|per quanto|a prescindere da|anche quando|da quando|dal momento|da allora|a partire da|fin da|dato che|in quanto|in seguito|sin da|visto che|a seguito|nel frattempo|tanto più che|sin d'allora|al contempo|allo stesso tempo| .......
    while ($Ligne2 =~ /^(.*?)(anche se|per quanto|a prescindere da|anche quando|da quando|dal momento|da allora|a partire da|fin da|dato che|in quanto|in seguito|sin da|visto che|a seguito|nel frattempo|tanto più che|sin d\'allora|sin d \'allora|sin d\' allora|sin d \' allora|al contempo|allo stesso tempo|nel contempo|al tempo stesso|dato che|nello stesso tempo|per intanto|per contro|per il momento|ciò nonostante|ciò nondimeno|per ora|non ancora|da il momento|al momento|non hanno ancora)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        
        $Creference=$2;
        $Creferencecopy=$2;
        $Creferencecopy =~ s/ //g;   
        $Creferencecopy ="$Creferencecopy"." ";  
        $Ligne2 =~ s/$Creference/$Creferencecopy/g;   
    }

    
    
    
     #*************************Preprocessing of the candidate*************************

    # converting &apos; et ’  to '
    $Ligne3 =~ s/\&apos\;|\’/\'/g;

    #normalisation of "pur" and "pure"
    while ($Ligne3 =~ /^(.*?)( pur)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Ccandidate=" pure";
        $Ligne3= "$1$Ccandidate$3$4";
        
    }    
    #normalisation of "dallo" 
    while ($Ligne3 =~ /^(.*?)(dallo)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da lo";
        $Ligne3= "$1$Creference$3$4";
        
    }
    #normalisation of "dall'"
    while ($Ligne3 =~ /^(.*?)(dall\'|dall \')(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da l'";
        $Ligne3= "$1$Creference$3$4";
        
    }
    
    #normalisation of "dai'"
    while ($Ligne3 =~ /^(.*?)(dai)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da i";
        $Ligne3= "$1$Creference$3$4";
        
    }
    #normalisation of "dagli'"
    while ($Ligne3 =~ /^(.*?)(dagli)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da gli";
        $Ligne3= "$1$Creference$3$4";
        
    }
    #normalisation of "dalle'"
    while ($Ligne3 =~ /^(.*?)(dalle)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da le";
        $Ligne3= "$1$Creference$3$4";
        
    }
    
    
    
    
    
    #normalisation of "della" 
    while ($Ligne3 =~ /^(.*?)(della|dell\'|dell \')(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="di la";
        $Ligne3= "$1$Creference$3$4";
        
    }
    #normalisation of "dalla" 
    while ($Ligne3 =~ /^(.*?)(dalla)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da la";
        $Ligne3= "$1$Creference$3$4";
        
    }

    
    
    #normalisation of "dal|dall" 
    while ($Ligne3 =~ /^(.*?)(dal|dall)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="da il";
        $Ligne3= "$1$Creference$3$4";
        
    }
    #normalisation of "del|dell" 
    while ($Ligne3 =~ /^(.*?)(del|dell)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="di il";
        $Ligne3= "$1$Creference$3$4";
        
    }
    #anche se|per quanto|a prescindere da|anche quando|da quando|dal momento|da allora|a partire da|fin da|dato che|in quanto|in seguito|sin da|visto che|a seguito|nel frattempo|tanto più che|sin d'allora|al contempo|allo stesso tempo| .......
    while ($Ligne3 =~ /^(.*?)(anche se|per quanto|a prescindere da|anche quando|da quando|dal momento|da allora|a partire da|fin da|dato che|in quanto|in seguito|sin da|visto che|a seguito|nel frattempo|tanto più che|sin d\'allora|sin d \'allora|sin d\' allora|sin d \' allora|al contempo|allo stesso tempo|nel contempo|al tempo stesso|dato che|nello stesso tempo|per intanto|per contro|per il momento|ciò nonostante|ciò nondimeno|per ora|non ancora|da il momento|al momento|non hanno ancora)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        
        $Creference=$2;
        $Creferencecopy=$2;
        $Creferencecopy =~ s/ //g;   
        $Creferencecopy ="$Creferencecopy"." ";  
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
