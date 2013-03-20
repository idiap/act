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
# perl ACT-preprocess-en_fr-V1.x.pl SOURCE REFERENCE CANDIDATE  
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

   
    #disambiguiation of and normalisation même s'
    while ($Ligne2 =~ /^(.*?)(même s\'|même s \'|même si)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
            $Creference="mêmesi ";
            $Ligne2= "$1$Creference$3$4";
            
    }
    #disambiguiation of s'
    while ($Ligne2 =~ /^(.*?)(s\'|s\' |s \' |s \')(il|ils|elle|elles)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="si ";
        $Ligne2= "$1$Creference$3$4$5";
    }
    

    #Preprocessing of multi-words and normalisation
    #bien qu' #quoiqu'#sans qu'#encore qu'#alors qu'#il semble qu'#depuis qu'#étant donné qu'#puisqu'#dès qu'#parce qu'#ainsi qu'#lorsqu'#tandis qu' #pendant qu'#s'il est vrai qu' #de plus
    #en dépit #tout de même #quand bien même #entre temps #tout en #d'ici là #pendant ce temps #en attendant #à présent #en revanche #par contre #dans le même temps #dans l' intervalle #pour autant #quoi qu'il en soit #pas encore #jusqu'à présent #jusqu'à maintenant #pour l'instant #alors même que #voilà qu' #|non encore #tant que
    #|cela dit |quand même |par ailleurs |d'ailleurs|ceci étant dit|ceci étant|ceci dit|cela étant dit |cela étant|cela dit|en tout cas|quelle que|quel que|au contraire|en effet|en outre
    while ($Ligne2 =~ /^(.*?)(bien qu\'|bien qu \'|bien que|quoiqu\'|quoiqu \'|sans qu\'|sans qu \'|sans que|encore qu\'|encore qu \'|encore que|alors qu\'|alors qu \'|alors que|il semble qu\'|il semble qu \'|il semble que|depuis qu\'|depuis qu \'|depuis que|étant donné qu\'|étant donné qu \'|étant donné que|puisqu\'|puisqu \'|dès qu\'|dès qu \'|dès que|parce qu\'|parce qu \'|parce que|ainsi qu\'|ainsi qu \'|ainsi que|lorsqu\'|lorsqu \'|tandis qu\'|tandis qu \'|tandis que|pendant qu\'|pendant qu \'|pendant que|s\'il est vrai qu\'|s \'il est vrai qu \'|s \' il est vrai qu \'|s\'il est vrai que|s \'il est vrai que|s \' il est vrai que|si il est vrai que|si  il est vrai que|de plus|en dépit|tout de même|quand bien même|entre temps|tout en|d\'ici là|d \'ici là|d \' ici là|d\' ici là|pendant ce temps|en attendant|à présent|en revanche|par contre|dans le même temps|dans l\'intervalle|dans l \'intervalle|dans l \' intervalle|dans l\' intervalle|pour autant|quoi qu\'il en soit|quoi qu \'il en soit|quoi qu \' il en soit|quoi qu\' il en soit|pas encore|jusqu\'à présent|jusqu \'à présent|jusqu \' à présent|jusqu\' à présent|jusqu\'à maintenant|jusqu \'à maintenant|jusqu \' à maintenant|jusqu\' à maintenant|pour l\'instant|pour l \'instant|pour l \' instant|pour l\' instant|alors même qu\'|alors même qu \'|alors même que|voilà qu\'|voilà qu \'|voilà que|non encore|tant qu\'|tant qu \'|tant que|cela dit|quand même|par ailleurs|d\' ailleurs|d \' ailleurs|d \'ailleurs|d\'ailleurs|ceci étant dit|ceci étant|ceci dit|cela étant dit|cela étant|cela dit|en tout cas|quelle que|quel que|au contraire|en effet|en outre)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        
        $Creference=$2;
        $Creferencecopy=$2;
        $Creferencecopy =~ s/ //g;   
        $Creferencecopy =~ s/\'/e/g;   
        $Creferencecopy ="$Creferencecopy"." ";  
        $Ligne2 =~ s/$Creference/$Creferencecopy/g;   
    }
    
    #**************Preprocessing of the candidate*************************
  
    # converting &apos; et ’  to '
    $Ligne3 =~ s/\&apos\;|\’/\'/g;

    #disambiguiation of and normalisation même s'
    while ($Ligne3 =~ /^(.*?)(même s\'|même s \'|même si)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="mêmesi ";
        $Ligne3= "$1$Creference$3$4";
        
    }
    #disambiguiation of s'
    while ($Ligne3 =~ /^(.*?)(s\'|s\' |s \' |s \')(il|ils|elle|elles)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {
        $Creference="si ";
        $Ligne3= "$1$Creference$3$4$5";
    }
    
    
    #Preprocessing of multi-words and normalisation
    #bien qu' #quoiqu'#sans qu'#encore qu'#alors qu'#il semble qu'#depuis qu'#étant donné qu'#puisqu'#dès qu'#parce qu'#ainsi qu'#lorsqu'#tandis qu' #pendant qu'#s'il est vrai qu' #de plus
    #en dépit #tout de même #quand bien même #entre temps #tout en #d'ici là #pendant ce temps #en attendant #à présent #en revanche #par contre #dans le même temps #dans l' intervalle #pour autant #quoi qu'il en soit #pas encore #jusqu'à présent #jusqu'à maintenant #pour l'instant #alors même que #voilà qu' #|non encore #tant que
    #|cela dit |quand même |par ailleurs |d'ailleurs|ceci étant dit|ceci étant|ceci dit|cela étant dit |cela étant|cela dit|en tout cas|quelle que|quel que|au contraire|en effet|en outre
    while ($Ligne3 =~ /^(.*?)(bien qu\'|bien qu \'|bien que|quoiqu\'|quoiqu \'|sans qu\'|sans qu \'|sans que|encore qu\'|encore qu \'|encore que|alors qu\'|alors qu \'|alors que|il semble qu\'|il semble qu \'|il semble que|depuis qu\'|depuis qu \'|depuis que|étant donné qu\'|étant donné qu \'|étant donné que|puisqu\'|puisqu \'|dès qu\'|dès qu \'|dès que|parce qu\'|parce qu \'|parce que|ainsi qu\'|ainsi qu \'|ainsi que|lorsqu\'|lorsqu \'|tandis qu\'|tandis qu \'|tandis que|pendant qu\'|pendant qu \'|pendant que|s\'il est vrai qu\'|s \'il est vrai qu \'|s \' il est vrai qu \'|s\'il est vrai que|s \'il est vrai que|s \' il est vrai que|si il est vrai que|si  il est vrai que|de plus|en dépit|tout de même|quand bien même|entre temps|tout en|d\'ici là|d \'ici là|d \' ici là|d\' ici là|pendant ce temps|en attendant|à présent|en revanche|par contre|dans le même temps|dans l\'intervalle|dans l \'intervalle|dans l \' intervalle|dans l\' intervalle|pour autant|quoi qu\'il en soit|quoi qu \'il en soit|quoi qu \' il en soit|quoi qu\' il en soit|pas encore|jusqu\'à présent|jusqu \'à présent|jusqu \' à présent|jusqu\' à présent|jusqu\'à maintenant|jusqu \'à maintenant|jusqu \' à maintenant|jusqu\' à maintenant|pour l\'instant|pour l \'instant|pour l \' instant|pour l\' instant|alors même qu\'|alors même qu \'|alors même que|voilà qu\'|voilà qu \'|voilà que|non encore|tant qu\'|tant qu \'|tant que|cela dit|quand même|par ailleurs|d\' ailleurs|d \' ailleurs|d \'ailleurs|d\'ailleurs|ceci étant dit|ceci étant|ceci dit|cela étant dit|cela étant|cela dit|en tout cas|quelle que|quel que|au contraire|en effet|en outre)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$)(.*\s*$)/)
    {        
        $Creference=$2;
        $Creferencecopy=$2;
        $Creferencecopy =~ s/ //g;   
        $Creferencecopy =~ s/\'/e/g;   
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
