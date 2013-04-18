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
# perl ACT-V1.x.pl 

############PLEASE DONT MODIFY THESE PARAMETERS BUT USE THE CONFIG FILE (ACT-V1.x.config) TO CONFIGURE ACT 

##########################DEFAULT Configuration ###############################################################################################################
$ACTHOME="/Users/Hajlaoui/tools/ACT/ACT-V1.7";
$WorkingDir="/Users/Hajlaoui/tools/ACT/ACT-V1.7/Samples/En-Fr/WithoutAlignment";


$SourceFile="20undoc.2000.en-fr.tok.lc.src";
$ReferenceFile="20undoc.2000.en-fr.tok.lc.ref";
$CandidateFile="20undoc.2000.en-fr.tok.lc.cand";


$SourceLanguage=en;# possible values: en
$TargetLanguage=fr;#possible values: fr|ar|it|de
# Set the $case5manual and $case6manual variables to the correct numbers, by default $case5manual=0 and $case6manual=0
$case5manual=0; #number case5 valided by human
$case6manual=0; #number case6 valided by human
$PrintReport=1;# to print details in terminal, possible values: 0|1

$ModeTest=0;#  to do a test, #possible values: 0|1
$PrintPosition=1;# to print (in REPORT.txt output file) the position of the reference connective to be used as feature (ACT can be used giving the same file as reference and candidate $ReferenceFile=$CandidateFile), possible values: 0|1
$PrintCase5=0;# to print cases 5
$Preprocessing=1; #Preprocessing step is obligatory, possible values: 1

#You can use ACT without alignment ($UsingAlignment=0;) or with alignment information ($UsingAlignment=1; in the second case (with alignment) you can print or not the alignement information $PrintAligInfos=0|1;)
#if you choose $UsingAlignment=0 you dont need to configurate the rest of parameters.
$UsingAlignment=1; #possible values: 0|1
$PrintAligInfos=1; #possible values: 0|1


#ATTENTION: IF YOU CHOOSE $UsingAlignment=1, YOU HAVE THEN TO CHOOSE ONE OF THE 2 ALIGNMENT MODELS: GizaMODEL ($GizaModel=1; and $RunGiza=1; or $RunGiza=0 if you dont want to run Giza a second time) OR SAVINGMODEL ($SavingModel=1; and $RunGiza=0; ), NOT BOTH IF NOT THERE IS AUTOMATIC CONFIGURATION WHICH CHOOSE FOR YOU THE GizaMODEL;

$GizaModel=1; #possible values: 0|1
#You can run GIZA just the first time for the same data.
$RunGiza=0; #possible values: 0|1
$PathToGIZA="/Users/Hajlaoui/tools/giza-pp-v1.0.7/giza-pp/GIZA++-v2"; # the same directory should contain also the binary plain2snt.out
#The GIZA's outputs will be created automatically in a new folders ./Giza-Src_Ref/.tst.A3.final  and ./Giza-Src_Cand/.tst.A3.final
#If your Giza tool is configured differentely, please adapt your configuration or change your files names to the proposed ones.

#IMPORTANT, if you choose $SavingModel=1, 2 externals scripts have to be used before using the actual ACT tool:
#1- ACT-preprocess-xx_yy-V1.4.pl for a preprocessing step of data for the  saving model alignment. (xx_yy depend on the source and target languages). (for example, you can use Europarl corpus to build the saving model, which will be used to align new data) 
#Between the precedent preprocessing step and the folowing postprocessing step, you have to align your data ((source//reference) and (source//candidate)).
#2- Symmetrization2Giza-V1.pl for a postprocessing step of the saving model alignment's output to convert it from the format produced by simmetrized giza (or Mgiza) to giza output. The result have to be placed (with the following file names) in $WorkingDir/model/$SavingModel_Src_Ref  and  $WorkingDir/model/$SavingModel_Src_Cand 

#Rq: the last 2 script are included in  ACT. If you choose to use  GIZAModel ($GizaModel=1;) you dont need to use these 2 scripts.
$SavingModel=0; #possible values: 0|1
$SavingModel_Src_Ref="20undoc.2000.Src-Ref.toact.v1.4.en-fr.grow-diag-final-and.giza";#only if $SavingModel=1, source_reference alignment output after conversion from  simmetrized giza (or Mgiza) to giza output using the Symmetrization2Giza-V1.pl script, to placed in a new folder "model", please create a new folder "model" in $WorkingDir.
$SavingModel_Src_Cand="20undoc.2000.Src-Cand.toact.v1.4.en-fr.grow-diag-final-and.giza";#only if $SavingModel=1, source_candidate alignment output after conversion from  simmetrized giza (or Mgiza) to giza output using the Symmetrization2Giza-V1.pl script, to placed in the same new folder "model" in $WorkingDir.

########################## End of DEFAULT Configuration ##########################################################################################################

#### configuration from the config file #####
#open (CONFIGACT,"<./ACT-V1.4.config")|| die ("Can't open ./ACT-V1.4.config  \n");
open (CONFIGACT,"<./ACT-V1.7.config")|| die ("Can't open ./ACT-V1.7.config  \n");


while(  $Line = <CONFIGACT> )
{
    chomp($Line);
    if ( ($Line =~ /^(\$SourceLanguage|\$TargetLanguage)\=(\w+)\;/)or ($Line =~ /^(\$\w+)\=(\d*)\;/)or ($Line =~ /^(\$SourceFile|\$ReferenceFile|\$CandidateFile|\$PathToGIZA|\$ACTHOME|\$WorkingDir|\$SavingModel_Src_Ref|\$SavingModel_Src_Cand)\=(.*)\;/))
    {
        print "$1=$2 \n";
        $SourceFile=$2 if ($1 eq "\$SourceFile");
        $ReferenceFile=$2 if ($1 eq "\$ReferenceFile");
        $CandidateFile=$2 if ($1 eq "\$CandidateFile");
        $ACTHOME=$2 if ($1 eq "\$ACTHOME");
        $WorkingDir=$2 if ($1 eq "\$WorkingDir");
        $SourceLanguage=$2 if ($1 eq "\$SourceLanguage");
        $TargetLanguage=$2 if ($1 eq "\$TargetLanguage");
        $case5manual=$2 if ($1 eq "\$case5manual");
        $case6manual=$2 if ($1 eq "\$case6manual");
        $PrintReport=$2 if ($1 eq "\$PrintReport");
        $ModeTest=$2 if ($1 eq "\$ModeTest");
        $PrintCase5=$2 if ($1 eq "\$PrintCase5");
        $Preprocessing=$2 if ($1 eq "\$Preprocessing");
        $UsingAlignment=$2 if ($1 eq "\$UsingAlignment");
        $PrintAligInfos=$2 if ($1 eq "\$PrintAligInfos");
        $GizaModel=$2 if ($1 eq "\$GizaModel");
        $RunGiza=$2 if ($1 eq "\$RunGiza");
        $PathToGIZA=$2 if ($1 eq "\$PathToGIZA");
        $SavingModel=$2 if ($1 eq "\$SavingModel");
        $SavingModel_Src_Ref=$2 if ($1 eq "\$SavingModel_Src_Ref");
        $SavingModel_Src_Cand=$2 if ($1 eq "\$SavingModel_Src_Cand");
    }	
}#end While


print " \n\n";

#### End of configuration from Config file #####

#### Automatic configuration #####
if ($GizaModel)
{
    $SavingModel=0;
}

if ($SavingModel)
{
$GizaModel=0;
$RunGiza=0;
}


if ($UsingAlignment and ($GizaModel eq 0) and ($SavingModel eq 0) )
{
                print "You have to choose the alignment method (GizaModel=1 and RunGiza=1) OR (SavingModel=1) \n";
                exit 0;
}
####End of Automatic configuration#####



$temps=time;


$SourceFile=$ARGV[0] if ( exists $ARGV[0]);
$ReferenceFile=$ARGV[1] if ( exists $ARGV[1]);
$CandidateFile=$ARGV[2] if ( exists $ARGV[2]);

#if( scalar( @ARGV ) < 3 ) {
#print "Error - Invalid command line \n";
# exit;
#}


#****** dictionary ********************************************************************************************************************************************************************************

require './ACT-dico-en_fr-V1.7.pl' if (($SourceLanguage eq "en") and ($TargetLanguage eq "fr"));
require './ACT-dico-en_ar-V1.6.pl' if (($SourceLanguage eq "en") and ($TargetLanguage eq "ar"));
require './ACT-dico-en_it-V1.7.pl' if (($SourceLanguage eq "en") and ($TargetLanguage eq "it"));
require './ACT-dico-en_de-V1.7.pl' if (($SourceLanguage eq "en") and ($TargetLanguage eq "de"));



#****** End dictionary ********************************************************************************************************************************************************************************


#************Preprocessing step *************

$ACTpreprocessen_fr=`perl ./ACT-preprocess-en_fr-V1.6.pl $WorkingDir/$SourceFile $WorkingDir/$ReferenceFile $WorkingDir/$CandidateFile`if (($Preprocessing) and ($SourceLanguage eq "en") and ($TargetLanguage eq "fr"));
$ACTpreprocessen_ar=`perl ./ACT-preprocess-en_ar-V1.5.pl $WorkingDir/$SourceFile $WorkingDir/$ReferenceFile $WorkingDir/$CandidateFile`if (($Preprocessing) and ($SourceLanguage eq "en") and ($TargetLanguage eq "ar"));
$ACTpreprocessen_ar=`perl ./ACT-preprocess-en_it-V1.6.pl $WorkingDir/$SourceFile $WorkingDir/$ReferenceFile $WorkingDir/$CandidateFile`if (($Preprocessing) and ($SourceLanguage eq "en") and ($TargetLanguage eq "it"));
$ACTpreprocessen_de=`perl ./ACT-preprocess-en_de-V1.6.pl $WorkingDir/$SourceFile $WorkingDir/$ReferenceFile $WorkingDir/$CandidateFile`if (($Preprocessing) and ($SourceLanguage eq "en") and ($TargetLanguage eq "de"));


#************End Preprocessing step *************

#************ Alignment Processing *************
if ($UsingAlignment)
{
print "************ Run plain2snt ************ \n" if ($RunGiza);
$plain2sntSrcRef=`$PathToGIZA/plain2snt.out $WorkingDir/Scr $WorkingDir/Ref`if ($RunGiza);
$plain2sntSrcCand=`$PathToGIZA/plain2snt.out $WorkingDir/Scr $WorkingDir/Cand` if ($RunGiza);

print "************ Run Giza++ ************ \n" if ($RunGiza);

$mkdirGiza_Src_Ref=`mkdir $WorkingDir/Giza-Src_Ref`if ($RunGiza);
$mkdirGiza_Src_Cand=`mkdir $WorkingDir/Giza-Src_Cand`if ($RunGiza);

$GizaSrcRef=`$PathToGIZA/GIZA++ -S $WorkingDir/Scr.vcb -T $WorkingDir/Ref.vcb -C $WorkingDir/Scr_Ref.snt -TC $WorkingDir/Scr_Ref.snt -O $WorkingDir/Giza-Src_Ref/`if ($RunGiza);
$GizaSrcRef=`$PathToGIZA/GIZA++ -S $WorkingDir/Scr.vcb -T $WorkingDir/Cand.vcb -C $WorkingDir/Scr_Cand.snt -TC $WorkingDir/Scr_Cand.snt -O $WorkingDir/Giza-Src_Cand/`if ($RunGiza);

print "************ end Run Giza++ ************ \n" if ($RunGiza);

print "************ Cleaning data ************ \n" if ($RunGiza);

$mkdirSrc_Ref=`mkdir $WorkingDir/Src_Ref`if ($RunGiza);
$mkdirSrc_Cand=`mkdir $WorkingDir/Src_Cand`if ($RunGiza);

$Scrvc=`cp $WorkingDir/Scr.vcb $WorkingDir/Src_Ref/Scr.vcb`if ($RunGiza);
$Refvc=`mv $WorkingDir/Ref.vcb $WorkingDir/Src_Ref/Ref.vcb`if ($RunGiza);
$Scr_Refsnt=`mv $WorkingDir/Scr_Ref.snt $WorkingDir/Src_Ref/Scr_Ref.snt`if ($RunGiza);
$Ref_Scrsnt=`mv $WorkingDir/Ref_Scr.snt $WorkingDir/Src_Ref/Ref_Scr.snt`if ($RunGiza);

$Scrvc=`mv $WorkingDir/Scr.vcb $WorkingDir/Src_Cand/Scr.vcb`if ($RunGiza);
$Refvc=`mv $WorkingDir/Cand.vcb $WorkingDir/Src_Cand/Cand.vcb`if ($RunGiza);
$Scr_Refsnt=`mv $WorkingDir/Scr_Cand.snt $WorkingDir/Src_Cand/Scr_Cand.snt`if ($RunGiza);
$Ref_Scrsnt=`mv $WorkingDir/Cand_Scr.snt $WorkingDir/Src_Cand/Cand_Scr.snt`if ($RunGiza);

print "************ Processing Alignment results ************ \n";
$ExtractAlignementSrcRef=`grep "({" <$WorkingDir/Giza-Src_Ref/.tst.A3.final >$WorkingDir/Src_Ref.giza`if ($GizaModel);
$ExtractAlignementSrcCand=`grep "({" <$WorkingDir/Giza-Src_Cand/.tst.A3.final >$WorkingDir/Src_Cand.giza`if ($GizaModel);

$ExtractAlignementSrcRef=`grep "({" <$WorkingDir/model/$SavingModel_Src_Ref >$WorkingDir/Src_Ref.giza`if ($SavingModel);
$ExtractAlignementSrcCand=`grep "({" <$WorkingDir/model/$SavingModel_Src_Cand >$WorkingDir/Src_Cand.giza`if ($SavingModel);

    open (SRCREFGIZA,"<$WorkingDir/Src_Ref.giza")|| die ("Can't open SRCREFGIZA\n");
    open (SRCCANDGIZA,"<$WorkingDir/Src_Cand.giza")|| die ("Can't open SRCCANDGIZA\n");
}
#************End Alignment Processing *************




open (SCR2,"<$WorkingDir/Scr")|| die ("Can't open SCR2\n");
open (REF2,"<$WorkingDir/Ref")|| die ("Can't open REF2\n");
open (CAND2,"<$WorkingDir/Cand")|| die ("Can't open CAND2\n");




open (REPORT,">$WorkingDir/Report.txt")|| die ("Can't open REPORT\n");
open (SCORE,">$WorkingDir/Score.txt")|| die ("Can't open SCORE\n");
open (CASE1,">$WorkingDir/Case1.txt")|| die ("Can't open CASE1\n");
print CASE1 "*******************************************Case 1: Same connective in Ref and Cand ==>likely ok ! *******************************\n";
open (CASE2,">$WorkingDir/Case2.txt")|| die ("Can't open CASE2\n");
print CASE2 "*******************************************Case 2: Synonym connectives in Ref and Cand ==>likely ok ! *******************************\n";
open (CASE3,">$WorkingDir/Case3.txt")|| die ("Can't open CASE3\n");
print CASE3 "*******************************************Case 3: Incompatible connectives *******************************\n";
open (CASE4,">$WorkingDir/Case4.txt")|| die ("Can't open CASE4\n");
print CASE4 "*******************************************Case 4: Not translated in Cand ==> likely not ok *******************************\n";
open (CASE5,">$WorkingDir/Case5.txt")|| die ("Can't open CASE5\n");
print CASE5 "*******************************************Case 5: Not translated in Ref but translated in Cand==> indecide, to check by Human *******************************\n";
open (CASE6,">$WorkingDir/Case6.txt")|| die ("Can't open CASE6\n");
print CASE6 "*******************************************Case 6: Not translated in Ref nor in Cand ==> indecide *******************************\n";



$NumLine=0;
$NumSent=0;

$Csrc="";
$Cref="";
$Ccand="";

$line1="";
$line2="";
$line3="";

$case1=0;
$case2=0;
$case3=0;
$case4=0;
$case5=0;
$case6=0;

$ACTa=0;
$ACTa5=0;
$ACTm=0;

$CrefEqCR=0;
$CrefNotEqCR=0;
$CcandEqCC=0; 
$CcandNotEqCC=0; 

$VV=0;
$FF=0;
$FV=0;
$VF=0;

while (($Ligne1=<SCR2>) and ($Ligne2=<REF2>) and ($Ligne3=<CAND2>) )


{
    $Ligne4=<SRCREFGIZA> if ($UsingAlignment);
    $Ligne5=<SRCCANDGIZA> if ($UsingAlignment);

    
    #**************Adding alignment *******************
    my @WordsSrc=();
    my @WordsRef=();
    my @WordsCand=();
    @WordsSrc=split(/ /, $Ligne1);
    @WordsRef=split(/ /, $Ligne2);
    @WordsCand=split(/ /, $Ligne3);
     #**************End Adding alignment *******************
    $NumLine++;
	$line1=$Ligne1;
	$line2=$Ligne2;
    $line3=$Ligne3;
    $PrintLine=1;
	#**************Processing of Scource file: SCR *******************
    while ($Ligne1 =~ /^(.*?)($EnConnectors)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$|--)(.*\s*$)/) 
	{		
        print "\nSOURCE: $Ligne1"	if ($ModeTest);
        print "REFERENCE: $Ligne2" if ($ModeTest);
        print "CANDIDATE: $Ligne3"	if ($ModeTest);
        $Csrc=$2;
        $Ligne1="$1$3$4";

        #check for non-connectors
        $CheckNotConnectors="$1$2";
        if ( ($CheckNotConnectors=~/^(.*\W*)($NotEnConnectors)/) or ($CheckNotConnectors=~/^(.*)($NotEnConnectors)/) )
        {
            goto START; 
        }

        
        $NumSent++;
        if ($Csrc eq "even though")
        {
            $string=$eventhough;
        }
        elsif ($Csrc eq "not yet")
        {
            $string=$notyet;
        }
        elsif ($Csrc eq " yet")
        {
            $Csrc="yet";
            $string=$yet;
        }
        elsif ($Csrc eq " while")
        {
            $Csrc="while";
            $string=$while;
        }
        else{
            $string=$$2;
        }
        #$string =~ s/\\//g;
	    #**************Adding alignment *******************
        if ($UsingAlignment)
        {
        $CRNumbers="";
        $CR="";
        $CSrcNotAliginRef=0;
        $CSrcNotAliginCand=0;
        if( $Ligne4=~/^(.*?)($Csrc) \({ ((\d*\s*\d*)*) }\)( )(.*\s*$)/)
		{	
             @NumWordsinRefAlignCsrc=();
            $CRNumbers=$3;
            @NumWordsinRefAlignCsrc=split(/ /, $3);
            $nbreDeMots=@NumWordsinRefAlignCsrc;
            
            foreach $AlignWord (@NumWordsinRefAlignCsrc)
            {
            $CR= "$CR "."$WordsRef[$AlignWord-1]";
            }
            if( $CR=~/( )(.*)/)
                 {
                     $CR=$2;  
                 }

            print "\n SENTENCE $NumLine Csrc:$Csrc {$CRNumbers} CR:$CR" if ($PrintAligInfos);# to test 
           
        }
        else
            {
                $CR=""; 
                $CSrcNotAliginRef=1;
                print "\n SENTENCE $NumLine Csrc:$Csrc {$CRNumbers} CR:$CR" if ($PrintAligInfos);# to test 
            }
        $CCNumbers="";
        $CC=""; 
        if( $Ligne5=~/^(.*?)($Csrc) \({ ((\d*\s*\d*)*) }\)( )(.*\s*$)/)
        
		{	
            @NumWordsinCandAlignCsrc=();
            $CCNumbers=$3;
            @NumWordsinCandAlignCsrc=split(/ /, $3);
            $nbreDeMots=@NumWordsinCandAlignCsrc;
            
            foreach $AlignWord (@NumWordsinCandAlignCsrc)
            {
                $CC= "$CC "."$WordsCand[$AlignWord-1]";
                
            }
            if( $CC=~/( )(.*)/)
            {
                $CC=$2;  
            }
            print "\n SENTENCE $NumLine Csrc:$Csrc {$CCNumbers} CC:$CC" if ($PrintAligInfos);# to test 
            
        }
        else
        {
            $CC=""; 
            $CSrcNotAliginCand=1;
            print "\n SENTENCE $NumLine Csrc:$Csrc {$CCNumbers} CC:$CC" if ($PrintAligInfos);# to test 
        }
        }# end if ($UsingAlignment)
        #**************End Adding alignment *******************

		#**************Processing of reference file: REF *******************
		
        if( $Ligne2=~/^(.*?)($string)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$|--)(.*\s*$)/)

		{
            
			#print "REFERENCE: $Ligne2" if ($ModeTest);
            #adding position
            my @WordsBeforeRefConnect=();
            @WordsBeforeRefConnect=split(/ /,$1);
            $NberWordsBeforeRefConnect=0;
            $NberWordsBeforeRefConnect=@WordsBeforeRefConnect;
            #End adding position

            
			$Cref=$2;
            if( $Cref=~/( )(.*)/)
            {
                $Cref=$2;  
            }
            
            #adding position

            $PCref=0;
            if( $NberWordsBeforeRefConnect > 0)
            {
            $PCref=$NberWordsBeforeRefConnect +1;
            }else{
                $PCref=1;
            }
            # $PCref=$-[2]; # based on caracters
            # print "\nCref position: $PCref\n";# for test
            #End adding position
            
            $CopieCref=$Cref;            
            #************** Adding alignment *******************
            if ($UsingAlignment)
            {
            $CopieLigne2=$Ligne2;
            if( $Cref eq $CR)
            {
                $CrefEqCR++;  
            }
            else
            {
                $CrefNotEqCR++;  
            }
            my @ListCref=();
            while ($CopieLigne2 =~ /^(.*?)($string)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$|--)(.*\s*$)/)

            {
                @ListCref = (@ListCref,$2);
                # print "\n$2"; # to test
                 $CopieLigne2 =~ s/$2//;
            }
             $NberPossibleRefTrans=@ListCref;
            if( $NberPossibleRefTrans > 1)
            {
                foreach $Elemt (@ListCref)
                {
                    print "\n SENTENCE $NumLine Csrc:$Csrc have as possible translation in Ref:$Elemt" if ($PrintAligInfos); # to test 
                }
                if( $CR =~ /($string)/)
                {
                    #if($CR ne $Cref)
                         # {
                             print "\n SENTENCE $NumLine Csrc:$Csrc and Cref :$CopieCref will be replaced/confirmed by CR:$1 " if ($PrintAligInfos); # to test 
                             $Cref=$1;
                    #adding position
                    $PCref=$NumWordsinRefAlignCsrc[0];
                    #print "Cref position: $PCref\n";
                    #End adding position
                    
                        # }
                }
                elsif ($CSrcNotAliginRef) # CR is not a connector and Csrc is not aligned in Ref
                {
                     $NbMotsdsRef=@WordsRef;
                    my %ConnecteursRef_Position=();
                   
                    foreach $Elemt (@ListCref)
                    {
                        for ($i=0;$i<$NbMotsdsRef;$i++ )
                        {
                           if (($Elemt eq $WordsRef[$i]) or ($Elemt eq " "."$WordsRef[$i]"))
                               {
                                   $ConnecteursRef_Position{$Elemt}=$i+1;
                               }
                            elsif (($Elemt eq "$WordsRef[$i]"." $WordsRef[$i+1]") or ($Elemt eq " "."$WordsRef[$i]"." $WordsRef[$i+1]"))
                                {
                                    $ConnecteursRef_Position{$Elemt}=$i+1;
                                }
                            elsif (($Elemt eq "$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]") or ($Elemt eq " "."$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"))
                                {
                                    $ConnecteursRef_Position{$Elemt}=$i+1;
                                }
                            elsif (($Elemt eq "$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"." $WordsRef[$i+3]") or ($Elemt eq " "."$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"." $WordsRef[$i+3]"))
                            {
                                $ConnecteursRef_Position{$Elemt}=$i+1;
                            }
                            elsif (($Elemt eq "$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"." $WordsRef[$i+3]"." $WordsRef[$i+4]") or ($Elemt eq " "."$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"." $WordsRef[$i+3]"." $WordsRef[$i+4]"))
                            {
                                $ConnecteursRef_Position{$Elemt}=$i+1;
                            }
                        }
                    }
                    
                    
                    $NbMotsdsSrc=@WordsSrc;
                    $PositionConnecteurSrc=0;
                    for ($i=0;$i<$NbMotsdsSrc;$i++ )
                    {
                        if ($Csrc eq $WordsSrc[$i])
                        {
                            $PositionConnecteurSrc=$i+1;
                        }
                        elsif ($Csrc eq "$WordsSrc[$i]"." $WordsSrc[$i+1]")
                        {
                            $PositionConnecteurSrc=$i+1;
                        }
                        elsif ($Csrc eq "$WordsSrc[$i]"." $WordsSrc[$i+1]"." $WordsSrc[$i+2]")
                        {
                            $PositionConnecteurSrc=$i+1;
                        }
                    }
                    $Diffactual=0;
                    $MinDiff=1000;
                    $CoonecteurFinal="";
                    foreach  $Ci (keys %ConnecteursRef_Position) 
                    {
                        $Diffactual = abs ($ConnecteursRef_Position{$Ci}-$PositionConnecteurSrc);
                        if ($Diffactual<$MinDiff)
                            {
                                $MinDiff=$Diffactual;
                                #$Pfinal = $ConnecteursRef_Position{$Ci}; 
                                $CoonecteurFinal= $Ci;
                            
                                
                            }
                       
                    }
                    print "\n SENTENCE $NumLine Csrc:$Csrc and Cref :$CopieCref will be replaced/confirmed by the nearest connective to the source one:$CoonecteurFinal " if ($PrintAligInfos); # to test 
                    $Cref=$CoonecteurFinal;
                    #adding position
                    $PCref=$ConnecteursRef_Position{$CoonecteurFinal};
                    #print "Cref position: $PCref\n"; #for test
                    #End adding position
                    
                }
                else
                 {  
                     $NbMotsdsRef=@WordsRef;
                     my %ConnecteursRef_Position=();
                     
                     foreach $Elemt (@ListCref)
                     {
                         for ($i=0;$i<$NbMotsdsRef;$i++ )
                         {
                             if (($Elemt eq $WordsRef[$i]) or ($Elemt eq " "."$WordsRef[$i]"))
                             {
                                 $ConnecteursRef_Position{$Elemt}=$i+1;
                             }
                             elsif (($Elemt eq "$WordsRef[$i]"." $WordsRef[$i+1]") or ($Elemt eq " "."$WordsRef[$i]"." $WordsRef[$i+1]"))
                             {
                                 $ConnecteursRef_Position{$Elemt}=$i+1;
                             }
                             elsif (($Elemt eq "$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]") or ($Elemt eq " "."$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"))
                             {
                                 $ConnecteursRef_Position{$Elemt}=$i+1;
                             }
                             elsif (($Elemt eq "$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"." $WordsRef[$i+3]") or ($Elemt eq " "."$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"." $WordsRef[$i+3]"))
                             {
                                 $ConnecteursRef_Position{$Elemt}=$i+1;
                             }
                             elsif (($Elemt eq "$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"." $WordsRef[$i+3]"." $WordsRef[$i+4]") or ($Elemt eq " "."$WordsRef[$i]"." $WordsRef[$i+1]"." $WordsRef[$i+2]"." $WordsRef[$i+3]"." $WordsRef[$i+4]"))
                             {
                                 $ConnecteursRef_Position{$Elemt}=$i+1;
                             }

                         }
                     }

                      $PositionAlignment=$NumWordsinRefAlignCsrc[0]-1;
                     
                     $Diffactual=0;
                     $MinDiff=1000;
                     $CoonecteurFinal="";
                     foreach  $Ci (keys %ConnecteursRef_Position) 
                     {
                         $Diffactual = abs ($ConnecteursRef_Position{$Ci} - $PositionAlignment);
                         if ($Diffactual<$MinDiff)
                         {
                             $MinDiff=$Diffactual;
                             $CoonecteurFinal= $Ci;
                             
                         }
                         
                     }
                     print "\n SENTENCE $NumLine Csrc:$Csrc and Cref :$CopieCref will be replaced/confirmed by the nearest connective to the alignment:$CoonecteurFinal " if ($PrintAligInfos); # to test 
                     $Cref=$CoonecteurFinal;
                     #adding position
                     $PCref=$ConnecteursRef_Position{$CoonecteurFinal};
                     #print "Cref position: $PCref\n";# for test
                     #End adding position
                    
                 }#end else

            }
            } #end  if ($UsingAlignment)
                
            #**************End Adding alignment *******************
            #**************Processing of candidate file *******************
			
            if( $Ligne3=~/^(.*?)($string)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$|--)(.*\s*$)/)

			{		
				#print "CANDIDATE: $Ligne3"	if ($ModeTest);
				$Ccand=$2;
                if( $Ccand=~/( )(.*)/)
                {
                    $Ccand=$2;  
                }
                $CopieCcand=$Ccand;
                
                #************** Adding alignment *******************
                if ($UsingAlignment)
                {    
                $CopieLigne3=$Ligne3;

                if( $Ccand eq $CC)
                {
                    $CcandEqCC++;  
                }
                else
                {
                    $CcandNotEqCC++;  
                }
                my @ListCcand=();
                while( $CopieLigne3=~/^(.*?)($string)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$|--)(.*\s*$)/)
                {
                    @ListCcand = (@ListCcand,$2);
                    $CopieLigne3 =~ s/$2//;
                }
                $NberPossibleCandTrans=@ListCcand;
                if( $NberPossibleCandTrans > 1)
                {
                    foreach $Elemt (@ListCcand)
                    {
                        print "\n SENTENCE $NumLine Csrc:$Csrc have as possible translation in Cand:$Elemt" if ($PrintAligInfos); # to test 
                    }
                    if( $CC =~ /($string)/)
                    {
                        # if($CC ne $Ccand)
                        # {
                        print "\n SENTENCE $NumLine Csrc:$Csrc and Ccand:$CopieCcand will be replaced/confirmed by CC:$1 " if ($PrintAligInfos); # to test
                         $Ccand=$1;
                            
                        # }
                    }
                    elsif ($CSrcNotAliginCand) # CC is not a connector   and Csrc is not aligned in Cand
                    {
                        $NbMotsdsCand=@WordsCand;
                        my %ConnecteursCand_Position=();
                        
                        foreach $Elemt (@ListCcand)
                        {
                            for ($i=0;$i<$NbMotsdsCand;$i++ )
                            {
                                if (($Elemt eq $WordsCand[$i]) or ($Elemt eq " "."$WordsCand[$i]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                                elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                                elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                                elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                                elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"." $WordsCand[$i+4]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"." $WordsCand[$i+4]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                            }
                        }
                        
                        
                        $NbMotsdsSrc=@WordsSrc;
                        $PositionConnecteurSrc=0;
                        for ($i=0;$i<$NbMotsdsSrc;$i++ )
                        {
                            if ($Csrc eq $WordsSrc[$i])
                            {
                                $PositionConnecteurSrc=$i+1;
                            }
                            elsif ($Csrc eq "$WordsSrc[$i]"." $WordsSrc[$i+1]")
                            {
                                $PositionConnecteurSrc=$i+1;
                            }
                            elsif ($Csrc eq "$WordsSrc[$i]"." $WordsSrc[$i+1]"." $WordsSrc[$i+2]")
                            {
                                $PositionConnecteurSrc=$i+1;
                            }
                        }
                        $Diffactual=0;
                        $MinDiff=1000;
                        $CoonecteurFinalCand="";
                        foreach  $Ci (keys %ConnecteursCand_Position) 
                        {
                            $Diffactual = abs ($ConnecteursCand_Position{$Ci}-$PositionConnecteurSrc);
                            if ($Diffactual<$MinDiff)
                            {
                                $MinDiff=$Diffactual;
                                #$Pfinal = $ConnecteursCand_Position{$Ci}; 
                                $CoonecteurFinalCand= $Ci;
                            }
                            
                        }
                        print "\n SENTENCE $NumLine Csrc:$Csrc and Ccand :$CopieCcand will be replaced/confirmed by the nearest connective to the source one:$CoonecteurFinalCand " if ($PrintAligInfos); # to test 
                        $Ccand=$CoonecteurFinalCand;
                        
                        
                    }
                    
                    else
                    {  
                        $NbMotsdsCand=@WordsCand;
                        my %ConnecteursCand_Position=();
                        
                        foreach $Elemt (@ListCcand)
                        {
                            for ($i=0;$i<$NbMotsdsCand;$i++ )
                            {
                                if (($Elemt eq $WordsCand[$i]) or ($Elemt eq " "."$WordsCand[$i]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                                elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                                elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                                elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                                elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"." $WordsCand[$i+4]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"." $WordsCand[$i+4]"))
                                {
                                    $ConnecteursCand_Position{$Elemt}=$i+1;
                                }
                            }
                        }
                        
                        $PositionAlignment=$NumWordsinCandAlignCsrc[0]-1;                        
                        
                        $Diffactual=0;
                        $MinDiff=1000;
                        $CoonecteurFinalCand="";
                        foreach  $Ci (keys %ConnecteursCand_Position) 
                        {
                            $Diffactual = abs ($ConnecteursCand_Position{$Ci}-$PositionAlignment);
                            if ($Diffactual<$MinDiff)
                            {
                                $MinDiff=$Diffactual;
                                #$Pfinal = $ConnecteursCand_Position{$Ci}; 
                                $CoonecteurFinalCand= $Ci;
                            }
                            
                        }
                        print "\n SENTENCE $NumLine Csrc:$Csrc and Ccand :$CopieCcand will be replaced/confirmed by the nearest connective to the alignment:$CoonecteurFinalCand " if ($PrintAligInfos); # to test 
                        $Ccand=$CoonecteurFinalCand; 
                        
                        
                    }#end else
                    
                    
                } 
                }  #end of  if ($UsingAlignment)
                #**************End Adding alignment *******************
                

               $NotInCase2=1; 
                
				$VV=$VV+1;
				if ($Cref eq $Ccand)
					{
					
                        print "\nSENTENCE $NumLine: Csrc = $Csrc\tCref=Ccand = $Ccand\t==> case 1: Same connective in Ref and Cand ==>likely ok ! \n" if($PrintReport );
                        if($PrintReport and $PrintLine )
                        {
                            
                            print  "\nSOURCE $NumLine: $line1";
                            print  "REFERENCE $NumLine: $line2";
                            print  "CANDIDATE $NumLine: $line3";
                            $PrintLine=0;  
                        }
                        #Modification, adding position 
                    if($PrintPosition)
                         {
                        print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref=Ccand = $Ccand\tPositionCref=$PCref\t==> case 1: Same connective in Ref and Cand ==>likely ok ! \n";
                         }
                    else
                         {
                         print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref=Ccand = $Ccand\t==> case 1: Same connective in Ref and Cand ==>likely ok ! \n";
                         }
					$case1++;
					print CASE1 "***SENTENCE $NumLine: Csrc = $Csrc\tCref=Ccand = $Ccand***\n";
					print CASE1 "SOURCE $NumLine: $line1";
					print CASE1 "REFERENCE $NumLine: $line2";
					print CASE1 "CANDIDATE $NumLine: $line3\n";



					}
                else
                    {
                       
                        #adding multiple senses
                        #Senses of the reference
                        $NberSensesofCref=0;
                        my @ListSensesofCref=();
                        
                        foreach $ConnectorSense (@EnConnectorsSenses)
                        {
                            if ( (($ConnectorSense eq "$Csrc"."CONTRAST") or( $ConnectorSense eq "$Csrc"."CONCESSION")or($ConnectorSense eq "$Csrc"."TEMPORAL")or($ConnectorSense eq "$Csrc"."CAUSAL")or($ConnectorSense eq "$Csrc"."ADVERB"))   and ($Cref=~/^($$ConnectorSense)/)  )
                                
                            {
                                $NberSensesofCref++;
                                @ListSensesofCref = (@ListSensesofCref,$ConnectorSense);
                            
                            }
                        }
                        #Senses of the candidate
                        $NberSensesofCcand=0;
                        my @ListSensesofCcand=();
                        
                        foreach $ConnectorSense (@EnConnectorsSenses)
                        {
                            if ( (($ConnectorSense eq "$Csrc"."CONTRAST") or( $ConnectorSense eq "$Csrc"."CONCESSION")or($ConnectorSense eq "$Csrc"."TEMPORAL")or($ConnectorSense eq "$Csrc"."CAUSAL")or($ConnectorSense eq "$Csrc"."ADVERB"))   and ($Ccand=~/^($$ConnectorSense)/)  )
                                
                            {
                                $NberSensesofCcand++;
                                @ListSensesofCcand = (@ListSensesofCcand,$ConnectorSense);
                                
                            }
                        }
                       
                        ##### test of including
                        my $elementofSensesofCcand="";
                        my $elementofSensesofCref="";
                        my $elmentcommun=0;

                        foreach $elementofSensesofCcand (@ListSensesofCcand)
                        {
                            foreach $elementofSensesofCref (@ListSensesofCref)
                            {
                                if ($elementofSensesofCcand eq $elementofSensesofCref)
                                    {
                                        $elmentcommun++;
                                    }
                            }
                        }
                        #####
                        
                        #End adding multiple senses

                        
                        
                        
                        foreach $ConnectorSense (@EnConnectorsSenses)
                        {
                            #adding multiple senses
    
                            #if ( (($ConnectorSense eq "$Csrc"."CONTRAST") or( $ConnectorSense eq "$Csrc"."CONCESSION")or($ConnectorSense eq "$Csrc"."TEMPORAL")or($ConnectorSense eq "$Csrc"."CAUSAL")or($ConnectorSense eq "$Csrc"."ADVERB"))   and ($Cref=~/^($$ConnectorSense)/) and ($Ccand=~/^($$ConnectorSense)/)   )
                            if ( (($ConnectorSense eq "$Csrc"."CONTRAST") or( $ConnectorSense eq "$Csrc"."CONCESSION")or($ConnectorSense eq "$Csrc"."TEMPORAL")or($ConnectorSense eq "$Csrc"."CAUSAL")or($ConnectorSense eq "$Csrc"."ADVERB"))   and ($Cref=~/^($$ConnectorSense)/) and ($Ccand=~/^($$ConnectorSense)/)  and ($NberSensesofCcand >= $NberSensesofCref) and ($elmentcommun >=$NberSensesofCref) )
                            #End adding multiple senses

                           
                                {
                                #adding multiple senses, 
                                if ($NberSensesofCref <=1)
                                {
                                    print "\nSENTENCE $NumLine: Csrc = $Csrc ($ConnectorSense)\tCref = $Cref\tCcand = $Ccand\t==> case 2: Synonym connectives in Ref and Cand ==>likely ok !  \n" if ($PrintReport);
                                    if($PrintReport and $PrintLine )
                                    {
                                        
                                        print  "\nSOURCE $NumLine: $line1";
                                        print  "REFERENCE $NumLine: $line2";
                                        print  "CANDIDATE $NumLine: $line3";
                                        $PrintLine=0;  
                                    }
                                    
                                    #Modification, adding position
                                    
                                    if($PrintPosition)
                                    {
                                    print REPORT "SENTENCE $NumLine: Csrc = $Csrc ($ConnectorSense)\tCref = $Cref\tCcand = $Ccand\tPositionCref=$PCref\t==> case 2: Synonym connectives in Ref and Cand ==>likely ok !  \n";
                                    }
                                    else
                                    {
                                    print REPORT "SENTENCE $NumLine: Csrc = $Csrc ($ConnectorSense)\tCref = $Cref\tCcand = $Ccand\t==> case 2: Synonym connectives in Ref and Cand ==>likely ok !  \n";
                                    }
                                    
                                    $case2++;
                                    print CASE2 "***SENTENCE $NumLine: Csrc = $Csrc ($ConnectorSense)\tCref = $Cref\tCcand = $Ccand***\n";
                                    print CASE2 "SOURCE $NumLine: $line1";
                                    print CASE2 "REFERENCE $NumLine: $line2";
                                    print CASE2 "CANDIDATE $NumLine: $line3\n";
                                    
                                    $NotInCase2=0;
                                 
                                
                                }else # ($NberSensesofCref >=1, si deux connecteurs ambiguis sont  dans deux sens différents à la fois dans cand et dans ref)
                                    {
                                        print "\nSENTENCE $NumLine: Csrc = $Csrc \tCref = $Cref\tCcand = $Ccand\t==> case 2: Synonym connectives in Ref and Cand ==>likely ok !  \n" if ($PrintReport);
                                        if($PrintReport and $PrintLine )
                                        {
                                            
                                            print  "\nSOURCE $NumLine: $line1";
                                            print  "REFERENCE $NumLine: $line2";
                                            print  "CANDIDATE $NumLine: $line3";
                                            $PrintLine=0;  
                                        }
                                        
                                        #Modification, adding position
                                        
                                        if($PrintPosition)
                                        {
                                            print REPORT "SENTENCE $NumLine: Csrc = $Csrc \tCref = $Cref\tCcand = $Ccand\tPositionCref=$PCref\t==> case 2: Synonym connectives in Ref and Cand ==>likely ok !  \n";
                                        }
                                        else
                                        {
                                            print REPORT "SENTENCE $NumLine: Csrc = $Csrc \tCref = $Cref\tCcand = $Ccand\t==> case 2: Synonym connectives in Ref and Cand ==>likely ok !  \n";
                                        }
                                        
                                        $case2++;
                                        print CASE2 "***SENTENCE $NumLine: Csrc = $Csrc \tCref = $Cref\tCcand = $Ccand***\n";
                                        print CASE2 "SOURCE $NumLine: $line1";
                                        print CASE2 "REFERENCE $NumLine: $line2";
                                        print CASE2 "CANDIDATE $NumLine: $line3\n";
                                        
                                        $NotInCase2=0;

                                        goto CONTUNIE;
                                    }
                                    
                                
                                }
                                
                        }#end foreach
                        CONTUNIE:
                    }
            
                if (($Cref ne $Ccand) and ($NotInCase2))
                    {
					print "\nSENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\t==> case 3: Incompatible connectives \n" if ($PrintReport);
                        if($PrintReport and $PrintLine )
                        {
                            
                            print  "\nSOURCE $NumLine: $line1";
                            print  "REFERENCE $NumLine: $line2";
                            print  "CANDIDATE $NumLine: $line3";
                            $PrintLine=0;  
                        }
                        
                        #Modification, adding position
                        if($PrintPosition)
                        {
                            print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\tPositionCref=$PCref\t==> case 3: Incompatible connectives \n";
                        }
                        else
                        {
                            print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\t==> case 3: Incompatible connectives \n";
                        }
                    $case3++;
					print CASE3 "***SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand***\n";
					print CASE3 "SOURCE $NumLine: $line1";
					print CASE3 "REFERENCE $NumLine: $line2";
					print CASE3 "CANDIDATE $NumLine: $line3\n";

					}
			}
            else 
			{
				$Ccand="0";
				$VF=$VF+1;   
				print "\nSENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\t==> case 4: Not translated in Cand ==> likely not ok \n" if ($PrintReport);
                if($PrintReport and $PrintLine )
                {
                    
                    print  "\nSOURCE $NumLine: $line1";
                    print  "REFERENCE $NumLine: $line2";
                    print  "CANDIDATE $NumLine: $line3";
                    $PrintLine=0;  
                }

                #Modification, adding position
                if($PrintPosition)
                {
                    print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\tPositionCref=$PCref\t==> case 4: Not translated in Cand ==> likely not ok \n";

                }
                else
                {
                    print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\t==> case 4: Not translated in Cand ==> likely not ok \n";
                }
                $case4++;
				print CASE4 "***SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand***\n";
				print CASE4 "SOURCE $NumLine: $line1";
				print CASE4 "REFERENCE $NumLine: $line2";
				print CASE4 "CANDIDATE $NumLine: $line3\n";

			}
		
        }elsif( $Ligne3=~/^(.*?)($string)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$|--)(.*\s*$)/)

				{
					$Cref="0";
                    #adding position
                    $PCref=0;
                    #End adding position
					$Ccand=$2;
                    if( $Ccand=~/( )(.*)/)
                    {
                        $Ccand=$2;  
                    }
                    $CopieCcand=$Ccand;                    
                    #************** Adding alignment *******************
                    if ($UsingAlignment)
                    {   
                    $Copie2Ligne3=$Ligne3;
                    
                    if( $Ccand eq $CC)
                    {
                        $CcandEqCC++;  
                    }
                    else
                    {
                        $CcandNotEqCC++;  
                    }
                    my @ListCcand2=();
                    while( $Copie2Ligne3=~/^(.*?)($string)(\s|\,|\.|\?|\!|\:|\;|\'|\’|$|--)(.*\s*$)/)
                    {
                        @ListCcand2 = (@ListCcand2,$2);
                        $Copie2Ligne3 =~ s/$2//;
                    }
                    $NberPossibleCandTrans2=@ListCcand2;
                    if( $NberPossibleCandTrans2 > 1)
                    {
                        foreach $Elemt2 (@ListCcand2)
                        {
                            print "\n SENTENCE $NumLine Csrc:$Csrc have as possible translation in Cand:$Elemt2" if ($PrintAligInfos); # to test 
                        }
                        if( $CC =~ /($string)/)
                        {   
                            # if ($CC ne $Ccand)
                            # {
                            print "\n SENTENCE $NumLine Csrc:$Csrc and Ccand:$CopieCcand will be replaced/confirmed by CC:$1 " if ($PrintAligInfos); # to test 
                            $Ccand=$1;
                                
                            #}
                        }
                        elsif ($CSrcNotAliginCand)# CC is not a connector and Csr is not aligned in Cand
                        {
                            $NbMotsdsCand=@WordsCand;
                            my %ConnecteursCand_Position=();
                            
                            foreach $Elemt (@ListCcand2)
                            {
                                for ($i=0;$i<$NbMotsdsCand;$i++ )
                                {
                                    if (($Elemt eq $WordsCand[$i]) or ($Elemt eq " "."$WordsCand[$i]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                    elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                    elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                    elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                    elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"." $WordsCand[$i+4]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"." $WordsCand[$i+4]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                }
                            }
                            
                            
                            $NbMotsdsSrc=@WordsSrc;
                            $PositionConnecteurSrc=0;
                            for ($i=0;$i<$NbMotsdsSrc;$i++ )
                            {
                                if ($Csrc eq $WordsSrc[$i])
                                {
                                    $PositionConnecteurSrc=$i+1;
                                }
                                elsif ($Csrc eq "$WordsSrc[$i]"." $WordsSrc[$i+1]")
                                {
                                    $PositionConnecteurSrc=$i+1;
                                }
                                elsif ($Csrc eq "$WordsSrc[$i]"." $WordsSrc[$i+1]"." $WordsSrc[$i+2]")
                                {
                                    $PositionConnecteurSrc=$i+1;
                                }
                            }
                            $Diffactual=0;
                            $MinDiff=1000;
                            $CoonecteurFinalCand="";
                            foreach  $Ci (keys %ConnecteursCand_Position) 
                            {
                                $Diffactual = abs ($ConnecteursCand_Position{$Ci}-$PositionConnecteurSrc);
                                if ($Diffactual<$MinDiff)
                                {
                                    $MinDiff=$Diffactual;
                                    #$Pfinal = $ConnecteursCand_Position{$Ci}; 
                                    $CoonecteurFinalCand= $Ci;
                                }
                                
                            }
                            print "\n SENTENCE $NumLine Csrc:$Csrc and Ccand :$CopieCcand will be replaced/confirmed by the nearest connective to the source one:$CoonecteurFinalCand " if ($PrintAligInfos); # to test 
                            $Cref=$CoonecteurFinalCand;
                            
                            
                        }
                        
                        
                        else
                        {  
                            $NbMotsdsCand=@WordsCand;
                            my %ConnecteursCand_Position=();
                            
                            foreach $Elemt (@ListCcand2)
                            {
                                for ($i=0;$i<$NbMotsdsCand;$i++ )
                                {
                                    if (($Elemt eq $WordsCand[$i]) or ($Elemt eq " "."$WordsCand[$i]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                    elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                    elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                    elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                    elsif (($Elemt eq "$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"." $WordsCand[$i+4]") or ($Elemt eq " "."$WordsCand[$i]"." $WordsCand[$i+1]"." $WordsCand[$i+2]"." $WordsCand[$i+3]"." $WordsCand[$i+4]"))
                                    {
                                        $ConnecteursCand_Position{$Elemt}=$i+1;
                                    }
                                }
                            }
                            
                            $PositionAlignment=$NumWordsinCandAlignCsrc[0]-1;                        
                            
                            $Diffactual=0;
                            $MinDiff=1000;
                            $CoonecteurFinalCand="";
                            foreach  $Ci (keys %ConnecteursCand_Position) 
                            {

                                $Diffactual = abs ($ConnecteursCand_Position{$Ci}-$PositionAlignment);
                                if ($Diffactual<$MinDiff)
                                {
                                    $MinDiff=$Diffactual;
                                    #$Pfinal = $ConnecteursCand_Position{$Ci}; 
                                    $CoonecteurFinalCand= $Ci;
                                }
                                
                            }
                            print "\n SENTENCE $NumLine Csrc:$Csrc and Ccand :$CopieCcand will be replaced/confirmed by the nearest connective to the alignment:$CoonecteurFinalCand " if ($PrintAligInfos); # to test 
                            $Ccand=$CoonecteurFinalCand; 
                            
                            
                        }#end else
                        
                    } 
                    } #end of   if ($UsingAlignment)
                    #**************End Adding alignment *******************

                    
                    
					$FV=$FV+1;
					print "\nSENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\t==> case 5: Not translated in Ref but translated in Cand==> indecide, to check by Human \n" if ($PrintReport);
                    if($PrintReport and $PrintLine )
                    {
                        
                        print  "\nSOURCE $NumLine: $line1";
                        print  "REFERENCE $NumLine: $line2";
                        print  "CANDIDATE $NumLine: $line3";
                        $PrintLine=0;  
                    }

                    #Modification, adding position
                    if($PrintPosition)
                    {
                        print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\tPositionCref=$PCref\t==> case 5: Not translated in Ref but translated in Cand==> indecide, to check by Human \n";
                        
                    }
                    else
                    {
                        print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\t==> case 5: Not translated in Ref but translated in Cand==> indecide, to check by Human \n";
                    }
                    $case5++;
					print CASE5 "***SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand***\n";
					print CASE5 "SOURCE $NumLine: $line1";
					print CASE5 "REFERENCE $NumLine: $line2";
					print CASE5 "CANDIDATE $NumLine: $line3\n";

				}
				else 
				{
					$Cref="0";
                    #adding position
                    $PCref=0;
                    #End adding position
					$Ccand="0";
					$FF=$FF+1;
					print "\nSENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\t==> case 6: Not translated in Ref nor in Cand ==> indecide \n" if ($PrintReport);
                    if($PrintReport and $PrintLine )
                    {
                        
                        print  "\nSOURCE $NumLine: $line1";
                        print  "REFERENCE $NumLine: $line2";
                        print  "CANDIDATE $NumLine: $line3";
                        $PrintLine=0;  
                    }

                    #Modification, adding position
                    if($PrintPosition)
                    {
                        print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\tPositionCref=$PCref\t==> case 6: Not translated in Ref nor in Cand ==> indecide \n";
                        
                    }
                    else
                    {
                        print REPORT "SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand\t==> case 6: Not translated in Ref nor in Cand ==> indecide \n";
                    }

                    $case6++;
					print CASE6 "***SENTENCE $NumLine: Csrc = $Csrc\tCref = $Cref\tCcand = $Ccand***\n";
					print CASE6 "SOURCE $NumLine: $line1";
					print CASE6 "REFERENCE $NumLine: $line2";
					print CASE6 "CANDIDATE $NumLine: $line3\n";

				}
	
        START:    
	} #End While (while connector exists in source)
	
	
	
			
}#End While  line exists in files
print "\n****************************** \n";
print "****************************** \n";

close(CASE5);

if ($PrintCase5)
{

open (CASE5TOCHECK,"<$WorkingDir/Case5.txt")|| die ("Can't open $CASE5TOCHECK  \n");
while ($linecase5=<CASE5TOCHECK>) 
{
print "$linecase5";

}
}
print "*** \n";
print "****************************** \n";


print SCORE "\$SourceFile=$SourceFile \n";
print SCORE "\$ReferenceFile=$ReferenceFile \n";
print SCORE "\$CandidateFile=$CandidateFile \n";
print SCORE "\$ACTHOME=$ACTHOME \n";
print SCORE "\$WorkingDir=$WorkingDir \n";
print SCORE "\$SourceLanguage=$SourceLanguage \n";
print SCORE "\$TargetLanguage=$TargetLanguage \n";
print SCORE "\$case5manual=$case5manual \n";
print SCORE "\$case6manual=$case6manual \n";
print SCORE "\$PrintReport=$PrintReport \n";
print SCORE "\$PrintCase5=$PrintCase5 \n";
print SCORE "\$Preprocessing=$Preprocessing \n";
print SCORE "\$UsingAlignment=$UsingAlignment \n";
print SCORE "\$PrintAligInfos=$PrintAligInfos \n";
print SCORE "\$GizaModel=$GizaModel \n";
print SCORE "\$RunGiza=$RunGiza \n";
print SCORE "\$PathToGIZA=$PathToGIZA \n";
print SCORE "\$SavingModel=$SavingModel \n";
print SCORE "\$SavingModel_Src_Ref=$SavingModel_Src_Ref \n";
print SCORE "\$SavingModel_Src_Cand=$SavingModel_Src_Cand \n";


print SCORE "****************************** \n\n";

print "Number of different sentences: $NumLine \n";
print SCORE "Number of different sentences: $NumLine \n";
print "Number of discourse connectives: $NumSent \n";
print SCORE "Number of discourse connectives: $NumSent \n";

if ($UsingAlignment)
{
print "*************Statistical informations about the correspondence between alignment information and detected connectors ***************** \n";
print "The reference connector is equal to the alignment information (Cref Eq CR): $CrefEqCR \n";
print "The reference connector is not equal to the alignment information (Cref Not Eq CR): $CrefNotEqCR \n";

print "The candidate connector is equal to the alignment information (Ccand Eq CC): $CcandEqCC \n";
print "The candidate connector is not equal to the alignment information (Ccand Not Eq CC): $CcandNotEqCC \n";
print "****************************** \n";
}

print "*** \n";
print SCORE "*** \n";


print "case 1: $case1 \n";
print SCORE "case 1: $case1 \n";
print "case 2: $case2 \n";
print SCORE "case 2: $case2 \n";
print "case 3: $case3 \n";
print SCORE "case 3: $case3 \n";
print "case 4: $case4 \n";
print SCORE "case 4: $case4 \n";
print "case 5: $case5 \n";
print SCORE "case 5: $case5 \n";
print "case 6: $case6 \n";
print SCORE "case 6: $case6 \n";


#caluclation of scores: ACTa, ACTa5, and ACTm

$ACTa=($case1+$case2)/($case1+$case2+$case3+$case4+$case5+$case6);
#$ACTa5=($case1+$case2)/($case1+$case2+$case3+$case4+$case6);
$ACTa56=($case1+$case2)/($case1+$case2+$case3+$case4);
#$ACTm=($case1+$case2+$case5manual)/($case1+$case2+$case3+$case4+$case5+$case6);
$ACTm=($case1+$case2+$case5manual+$case6manual)/($case1+$case2+$case3+$case4+$case5+$case6);

my $ACTa1=sprintf "%7.3f",$ACTa; 
my $ACTa561=sprintf "%7.3f",$ACTa56; 
my $ACTm1=sprintf "%7.3f",$ACTm; 


print "*** \n";

print "ACTa: $ACTa1 \n";
print SCORE "ACTa: $ACTa1 \n";
print "ACTa5+6: $ACTa561 \n";
print SCORE "ACTa5+6: $ACTa561 \n";
print "ACTm: $ACTm1 \n";
print SCORE "ACTm: $ACTm1 \n";


print "*** \n";

#print "VV: $VV \n";	
#print "FF: $FF \n";
#print "FV: $FV \n";
#print "VF: $VF \n";
#print "*** \n";

close(SCR2);
close(REF2);
close(CAND2);
if ($UsingAlignment)
{
close(SRCREFGIZA);
close(SRCCANDGIZA);
}

close(CASE1);
close(CASE2);
close(CASE3);
close(CASE4);
close(CASE5TOCHECK);
close(CASE6);
print "****************************** \n";
print REPORT "****************************** \n";

print "\n Done in  ".(time-$temps)." seconds\n";
print REPORT "\n Done in  ".(time-$temps)." seconds\n";

print "****************************** \n";
close(REPORT);
close(SCORE);

