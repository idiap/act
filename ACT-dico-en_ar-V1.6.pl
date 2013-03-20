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


use Exporter;

#20/12/2012
##Preprocessing of the "+" symbol ==> replacing it by "--" and deleting the space " "
#b+ Alrgm  ==> b--Alrgm or An +hA ==> An--hA
#Preprocessing of the "*" symbol ==> replacing it by "§" 
#mn* ==> mn§
#Preprocessing of multi-words: "kmA kAnt" ==> "kmA__kAnt"



#****** 8 connectives ********************************************************************************************************************************************************************************
$EnConnectors="although|eventhough|since|though|meanwhile|^while| while|notyet|^yet| yet|however"; 
@EnConnectorsSenses = ("althoughCONTRAST","althoughCONCESSION","thoughCONTRAST","thoughCONCESSION","eventhoughCONTRAST","eventhoughCONCESSION","sinceTEMPORAL","sinceCAUSAL","whileCONTRAST","whileCONCESSION","whileTEMPORAL","meanwhileTEMPORAL","meanwhileCONTRAST","yetCONCESSION","yetCONTRAST","yetADVERB","notyetADVERB","howeverCONTRAST","howeverCONCESSION");#keep the same structure of the connector sense name
#$NotEnConnectors="in the meanwhile|a while"; the 24/10/12
$NotEnConnectors="in the meanwhile| a while|^a while|a short while|asthough"; 

#the 21/12/12  add mE An|mE__An| 
$although = "mE An|mE__An|(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|(^| )mE|A§A kAnt|A§A__kAnt|A§A kAn|A§A__kAn|(l--|l)An kAnt|(l--|l)An__kAnt|(l--|l)An kAn|(l--|l)An__kAn|(l--|l)An|An kAnt|An__kAnt|An kAn|An__kAn|An lm|An__lm|(^| )lw|gyr An|gyr__An|lkn|fy Hyn|fy__Hyn|kmA kAn|kmA__kAn|kmA kAnt|kmA__kAnt|AnmA"; 
$althoughCONTRAST = "(^| )lw|gyr An|gyr__An|lkn|(l--|l)An kAnt|(l--|l)An__kAnt|(l--|l)An kAn|(l--|l)An__kAn|(l--|l)An|An lm|An__lm|fy Hyn|fy__Hyn";#fy Hyn ok
$althoughCONCESSION = "mE An|mE__An|(Ely |b--)Alrgm|(Ely__|b--)Alrg|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|(^| )mE|A§A kAnt|A§A__kAnt|A§A kAn|A§A__kAn|An kAnt|An__kAnt|An kAn|An__kAn|fy Hyn|fy__Hyn|kmA kAn|kmA__kAn|kmA kAnt|kmA__kAnt|AnmA"; #fy Hyn ok


$though = "mE An|mE__An|mA lw|mA__lw|(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|(^| )mE|A§A kAnt|A§A__kAnt|A§A kAn|A§A__kAn|(l--|l)An kAnt|(l--|l)An__kAnt|(l--|l)An kAn|(l--|l)An__kAn|(l--|l)An|An kAnt|An__kAnt|An kAn|An__kAn|(^| )lw|gyr An|gyr__An|lkn"; # k-- mA lw ?
$thoughCONTRAST = "(^| )lw|gyr An|gyr__An|lkn|(l--|l)An kAnt|(l--|l)An__kAnt|(l--|l)An kAn|(l--|l)An__kAn|(l--|l)An"; 
$thoughCONCESSION = "mE An|mE__An|mA lw|mA__lw|(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|(^| )mE|A§A kAnt|A§A__kAnt|A§A kAn|A§A__kAn|An kAnt|An__kAnt|An kAn|An__kAn";

$eventhough = "Hty w--An|Hty__w--An|Hty w--lw|Hty__w--lw|Hty lw|Hty__lw|Hty mE|Hty__mE|Hty An|Hty__An|Hty b--Alrgm|Hty__b--Alrgm|Hty b--rgm|Hty__b--rgm|Hty rgm|Hty__rgm|Hty A§A|Hty__A§A|(^| )mE An|(^| )mE__An|(^| )mE|(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|(l--|l)An kAnt|(l--|l)An__kAnt|(l--|l)An kAn|(l--|l)An__kAn|(l--|l)An|An kAnt|An__kAnt|An kAn|An__kAn|b--§lk"; 
$eventhoughCONTRAST = "(^| )mE An|(^| )mE__An|(^| )mE|(l--|l)An kAnt|(l--|l)An__kAnt|(l--|l)An kAn|(l--|l)An__kAn|(l--|l)An";
$eventhoughCONCESSION = "Hty w--An|Hty__w--An|Hty w--lw|Hty__w--lw|Hty lw|Hty__lw|Hty mE|Hty__mE|Hty An|Hty__An|Hty b--Alrgm|Hty__b--Alrgm|Hty b--rgm|Hty__b--rgm|Hty rgm|Hty__rgm|Hty A§A|Hty__A§A|(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|An kAnt|An kAn|b-- §lk";


$since = "(^| )mn§|(^| )m§|nZrA|b--AlnZr|Hyv|(^| )A§|bEd|AEtbArA|(^| )lmA|TAlmA|mA dAmt|mA__dAmt|mA dAm|mA__dAm|wmn§}§|b--mA An|b--mA__An|mA An|mA__An|A§A|l--An"; 
$sinceTEMPORAL = "(^| )mn§|(^| )m§|bEd|TAlmA|mA dAmt|mA__dAmt|mA dAm|mA__dAm|wmn§}§";
$sinceCAUSAL = "nZrA|b--AlnZr|Hyv|(^| )A§|(^| )lmA|AEtbArA|b--mA An|b--mA__An|mA An|mA__An|A§A|l--An"; #mA dAmt?


$while	= "bynmA|Ely Hyn|Ely__Hyn|fy Hyn|fy__Hyn|(^| )mE An|(^| )mE__An|(^| )mE|(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|A§A|(^| )A§|(l--|l)An|lkn";	#|(l-- |l)An?, fymA ?
$whileCONTRAST	= "(^| )mE An|(^| )mE__An|(^| )mE|(l-- |l)An|lkn|fy Hyn|fy__Hyn";	#fy Hyn ok
$whileCONCESSION	= "(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|A§A|(^| )A§|fy Hyn|fy__Hyn";	#fy Hyn ok,
$whileTEMPORAL	= "bynmA|Ely Hyn|Ely__Hyn|fy Hyn|fy__Hyn";	#fy Hyn ok,


$meanwhile = "fy (Alwqt|AlAn) nfs--h|fy__(Alwqt|AlAn)__nfs--h|fy (Alwqt|AlAn) (nfs|AlHADr)|fy__(Alwqt|AlAn)__(nfs|AlHADr)|(Alwqt|AlAn) nfs|(Alwqt|AlAn)__nfs|fy (Alwqt|AlAn) §At--h|fy__(Alwqt|AlAn)__§At--h|fy (Alwqt|AlAn) §At|fy__(Alwqt|AlAn)__§At|(Alwqt|AlAn) §At|(Alwqt|AlAn)__§At|fy nfs (Alwqt|AlAn)|fy__nfs__(Alwqt|AlAn)|nfs (Alwqt|AlAn)|nfs__(Alwqt|AlAn)|fy §At (Alwqt|AlAn)|fy__§At__(Alwqt|AlAn)|fy gDwn §lk|fy__gDwn__§lk|fy gDwn|fy__gDwn|fy tlk AlgDwn|fy__tlk__AlgDwn|fy Alwqt AlrAhn|fy__Alwqt__AlrAhn|fy Alwqt|fy__Alwqt|fy h§h AlAvnA\'|fy__h§h__AlAvnA\'|fy tlk AlAvnA\'|fy__tlk__AlAvnA\'|fy AlAvnA\'|fy__AlAvnA\'|fy h§h AlAvnA\'|fy__h§h__AlAvnA\'|AlAvnA\'|fy Hyn|fy__Hyn|ryvmA|b--Swrp mwAzyp|b--Swrp__mwAzyp|fy Alftrp nfs--hA|fy__Alftrp__nfs--hA|fy Alftrp nfs|fy__Alftrp__nfs|Alftrp nfs|Alftrp__nfs|fy Alftrp §At--hA|fy__Alftrp__§At--hA|fy Alftrp §At|fy__Alftrp__§At|Alftrp §At|Alftrp__§At|fy nfs Alftrp|fy__nfs__Alftrp|nfs Alftrp|nfs__Alftrp|fy §At Alftrp|fy__§At__Alftrp|fy AvnA\' h§h Alftrp|fy__AvnA\'__h§h__Alftrp|AvnA\' h§h Alftrp|AvnA\'__h§h__Alftrp|fy xlAl h§h Alftrp|fy__xlAl__h§h__Alftrp|xlAl h§h Alftrp|xlAl__h§h__Alftrp|fy Alwqt Al§y|fy__Alwqt__Al§y|fy AntZAr h§lk|fy__AntZAr__h§lk|fy AntZAr|fy__AntZAr|fy AvnA\' §lk|fy__AvnA\'__§lk|fy AvnA\'|fy__AvnA\'|gyr An|gyr__An|l--§A|mn nAHyp Axry|mn__nAHyp__Axry|mA bEd|mA__bEd|Aly An|Aly__An"; 
$meanwhileTEMPORAL = "fy (Alwqt|AlAn) nfs--h|fy__(Alwqt|AlAn)__nfs--h|fy (Alwqt|AlAn) (nfs|AlHADr)|fy__(Alwqt|AlAn)__(nfs|AlHADr)|(Alwqt|AlAn) nfs|(Alwqt|AlAn)__nfs|fy (Alwqt|AlAn) §At--h|fy__(Alwqt|AlAn)__§At--h|fy (Alwqt|AlAn) §At|fy__(Alwqt|AlAn)__§At|(Alwqt|AlAn) §At|(Alwqt|AlAn)__§At|fy nfs (Alwqt|AlAn)|fy__nfs__(Alwqt|AlAn)|nfs (Alwqt|AlAn)|nfs__(Alwqt|AlAn)|fy §At (Alwqt|AlAn)|fy__§At__(Alwqt|AlAn)|fy Alwqt|fy__Alwqt|fy h§h AlAvnA\'|fy__h§h__AlAvnA\'|fy tlk AlAvnA\'|fy__tlk__AlAvnA\'|fy AlAvnA\'|fy__AlAvnA\'|fy h§h AlAvnA\'|fy__h§h__AlAvnA\'|AlAvnA\'|ryvmA|b--Swrp mwAzyp|b--Swrp__mwAzyp|fy Alftrp nfs--hA|fy__Alftrp__nfs--hA|fy Alftrp nfs|fy__Alftrp__nfs|Alftrp nfs|Alftrp__nfs|fy Alftrp §At--hA|fy__Alftrp__§At--hA|fy Alftrp §At|fy Alftrp §At|fy__Alftrp__§At|Alftrp §At|Alftrp__§At|fy nfs Alftrp|fy__nfs__Alftrp|nfs Alftrp|nfs__Alftrp|fy §At Alftrp|fy__§At__Alftrp|fy AvnA\' h§h Alftrp|fy__AvnA\'__h§h__Alftrp|AvnA\' h§h Alftrp|AvnA\'__h§h__Alftrp|fy xlAl h§h Alftrp|fy__xlAl__h§h__Alftrp|xlAl h§h Alftrp|xlAl__h§h__Alftrp|fy AntZAr h§lk|fy__AntZAr__h§lk|fy AntZAr|fy AntZAr|fy__AntZAr|fy AvnA\' §lk|fy__AvnA\'__§lk|fy AvnA\'|fy__AvnA\'|mA bEd|mA__bEd|Aly An|Aly__An|fy Hyn|fy__Hyn"; #fy Hyn ok,
$meanwhileCONTRAST = "fy gDwn §lk|fy__gDwn__§lk|fy gDwn|fy__gDwn|fy tlk AlgDwn|fy__tlk__AlgDwn|fy Alwqt AlrAhn|fy__Alwqt__AlrAhn|fy Hyn|fy__Hyn|fy Alwqt Al§y|fy__Alwqt__Al§y|gyr An|gyr__An|l--§A|mn nAHyp Axry|mn__nAHyp__Axry";#  l-- §A ?



$yet = "mE §lk|mE__§lk|mE h§A|mE__h§A|mE|lkn|gyr An|gyr__An|AlA An|AlA__An|bEd|lA yzAl|lA__yzAl|Hty AlAn|Hty__AlAn|mA zAl|mA__zAl|Ely An|Ely__An|byd An|byd__An";
$yetCONCESSION = "mE §lk|mE__§lk|mE h§A|mE__h§A|mE|Ely An|Ely__An";
$yetCONTRAST = "lkn|gyr An|gyr__An|AlA An|AlA__An|byd An|byd__An";
$yetADVERB = "bEd|lA yzAl|lA__yzAl|Hty AlAn|Hty__AlAn|mA zAl|mA__zAl";



$notyet = "lA yzAl|lA__yzAl|mA zAl|mA__zAl|bEd";
$notyetADVERB = "lA yzAl|lA__yzAl|mA zAl|mA__zAl|bEd";

$however = "byd An|byd__An|gyr An|gyr__An|mE §lk|mE__§lk|mE h§A|mE__h§A|mE An|mE__An|mE|AlA An|AlA__An|lkn|Ely An|Ely__An|(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|AmA|rgmA En|rgmA__En|mhmA|gyr AlA|gyr__AlA"; 
$howeverCONTRAST = "byd An|byd__An|gyr An|gyr__An|AlA An|AlA__An|lkn|AmA";
$howeverCONCESSION = "mE §lk|mE__§lk|mE h§A|mE__h§A|mEmE §lk|mE__§lk|mE h§A|mE__h§A|mE An|mE__An|mE|Ely An|Ely__An|(Ely |b--)Alrgm|(Ely__|b--)Alrgm|Alrgm|(Ely |b--)rgm|(Ely__|b--)rgm|rgm|rgmA En|rgmA__En|mhmA|gyr AlA|gyr__AlA";


our @EXPORT = qw($EnConnectors @EnConnectorsSenses $NotEnConnectors $although $althoughCONTRAST $althoughCONCESSION $though $thoughCONTRAST $thoughCONCESSION $eventhough $eventhoughCONTRAST $eventhoughCONCESSION $since $sinceTEMPORAL $sinceCAUSAL $while $whileCONTRAST $whileCONCESSION $whileTEMPORAL $meanwhile $meanwhileTEMPORAL $meanwhileCONTRAST $yet $yetCONCESSION $yetCONTRAST $yetADVERB $notyet $notyetADVERB $however $howeverCONTRAST $howeverCONCESSION);
1;

#****** End 8 connectives *******************************************************************************************************************************************************
