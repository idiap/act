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


#****** 8 connectives ********************************************************************************************************************************************************************************

$EnConnectors="although|eventhough|since|though|meanwhile|^while| while|notyet|^yet| yet|however"; 

@EnConnectorsSenses = ("althoughCONTRAST","althoughCONCESSION","thoughCONTRAST","thoughCONCESSION","eventhoughCONTRAST","eventhoughCONCESSION","sinceTEMPORAL","sinceCAUSAL","whileCONTRAST","whileCONCESSION","whileTEMPORAL","whileCAUSAL","meanwhileTEMPORAL","meanwhileCONTRAST","yetCONCESSION","yetCONTRAST","yetADVERB","notyetADVERB","howeverCONTRAST","howeverCONCESSION");#keep the same structure of the connector sense name
#add of "whileCAUSAL" the 13/12/2012, 
#$NotEnConnectors="in the meanwhile|a while"; the 24/10/12
$NotEnConnectors="in the meanwhile| a while|^a while|a short while|asthough"; 

$although = "obwohl|auch wenn|auchwenn|^zwar| zwar|wenngleich|obgleich|^aber| aber|wenn auch|wennauch|trotzdem|^trotz| trotz|allerdings|jedoch|^doch| doch|wobei|^während| während|dennoch|^indes| indes|^dabei| dabei"; 
$althoughCONTRAST = "^zwar| zwar|^aber| aber|^trotz| trotz|jedoch|^doch| doch|^indes| indes|^während| während"; 
$althoughCONCESSION = "obwohl|auch wenn|auchwenn|wenngleich|obgleich|wenn auch|wennauch|allerdings|wobei|dennoch|trotzdem|^aber| aber|jedoch|^während| während";


$though	= "obwohl|jedoch|auch wenn|auchwenn|allerdings|wenngleich|wenn auch|wennauch|^zwar| zwar|wobei|obgleich|selbst wenn|selbstwenn|trotzdem|aber dennoch|aberdennoch|aber doch|aberdoch|gleichwohl|^indes| indes|nichtsdestotrotz|sondern|^während| während|^aber| aber|dennoch|^trotz| trotz|^doch| doch";
$thoughCONTRAST = "^aber| aber|jedoch|^doch| doch|^zwar| zwar|^trotz| trotz|^indes| indes|^während| während";
$thoughCONCESSION = "obwohl|auch wenn|auchwenn|allerdings|wenngleich|wenn auch|wennauch|wobei|obgleich|selbst wenn|selbstwenn|trotzdem|aber dennoch|aberdennoch|aber doch|aberdoch|gleichwohl|nichtsdestotrotz|sondern|^aber| aber|jedoch|^während| während|dennoch";




$eventhough = "obwohl|auch wenn|auchwenn|obgleich|selbst wenn|selbstwenn|wenngleich|^zwar| zwar|^trotz| trotz|wenn auch|wennauch|jedoch|^während| während";	
$eventhoughCONTRAST = "^zwar| zwar|^trotz| trotz|jedoch|^während| während";
$eventhoughCONCESSION = "obwohl|auch wenn|auchwenn|obgleich|selbst wenn|selbstwenn|wenngleich|wenn auch|wennauch|jedoch|^während| während";



$since = "^da| da|seitdem|^weil| weil|^denn| denn|seither|^nach| nach|inzwischen|zumal|angesichts|^bisher| bisher|^seit| seit"; 
$sinceTEMPORAL = "seitdem|seither|^nach| nach|inzwischen|^bisher| bisher|^seit| seit";
$sinceCAUSAL = "^da| da|^weil| weil|^denn| denn|zumal|angesichts";



$while	= "^zwar| zwar|obwohl|wobei|jedoch|zugleich|solange|andererseits|auch wenn|auchwenn|bei gleichzeitige(r|m)|beigleichzeitige(r|m)|^doch| doch|wenngleich|^trotz| trotz|wenn auch|wennauch|wohingegen|^dabei| dabei|aberauch|allerdings|ansonsten|^hingegen| hingegen|stattdessen|während gleichzeitig|währendgleichzeitig|weiterhin|zur gleichen zeit|zurgleichenzeit|^aber| aber|^während| während|^gleichzeitig| gleichzeitig|^da| da|^wenn| wenn";
$whileCONTRAST	= "^zwar| zwar|^aber| aber|andererseits|^trotz| trotz|ansonsten|^hingegen| hingegen|^dabei| dabei|jedoch|^während| während|^doch| doch";	
$whileCONCESSION	= "obwohl|wobei|auch wenn|auchwenn|wenngleich|wenn auch|wennauch|wohingegen|aberauch|allerdings|stattdessen|^aber| aber|jedoch|^während| während";	
$whileTEMPORAL	= "zugleich|solange|bei gleichzeitige(r|m)|beigleichzeitige(r|m)|^wenn| wenn|während gleichzeitig|währendgleichzeitig|weiterhin|zur gleichen zeit|zurgleichenzeit|^während| während|^gleichzeitig| gleichzeitig";
$whileCAUSAL	= "^da| da";

#while	da	causal	==> but we dont have "da" causal


$meanwhile = "in der zwischenzeit|inderzwischenzeit|inzwischen|^gleichzeitig| gleichzeitig|unterdessen|währenddessen|während dessen|zwischenzeitlich|mittlerweile|indessen|^während| während|andererseits|dagegen|derweil|^derzeit| derzeit|^indes| indes|jedoch"; 
$meanwhileTEMPORAL = "in der zwischenzeit|inderzwischenzeit|inzwischen|^gleichzeitig| gleichzeitig|unterdessen|währenddessen|während dessen|zwischenzeitlich|mittlerweile|^derzeit| derzeit";#während ?
$meanwhileCONTRAST = "indessen|andererseits|dagegen|derweil|^indes| indes|jedoch|^während| während";
		



$yet = "dennoch|trotzdem|jedoch|bislang|^erneut| erneut|^dabei| dabei|^gleichzeitig| gleichzeitig|obwohl|andererseits|bereits|bisher noch|bishernoch|^derzeit| derzeit|zunächst einmal|zunächsteinmal|^einmal| einmal|nach wie vor|nachwievor|nochmals|wenngleich|abermals|bis jetzt|bisjetzt|bisweilen|dagegen|^indes| indes|selbst wenn|selbstwenn|^während| während|^aber| aber|^noch| noch|^doch| doch|^bisher| bisher";

$yetCONCESSION = "dennoch|trotzdem|obwohl|wenngleich|selbst wenn|selbstwenn|^aber| aber|jedoch|^während| während";
$yetCONTRAST = "^aber| aber|andererseits|dagegen|^indes| indes|zunächst einmal|zunächsteinmal|jedoch|^während| während|^doch| doch";
$yetADVERB = "bislang|^erneut| erneut|^gleichzeitig| gleichzeitig|bereits|bisher noch|bishernoch|^derzeit| derzeit|^einmal| einmal|nach wie vor|nachwievor|nochmals|abermals|bis jetzt|bisjetzt|bisweilen|^noch| noch|^bisher| bisher";


$notyet = "noch nicht|nochnicht|bisher nicht|bishernicht";
$notyetADVERB = "noch nicht|nochnicht|bisher nicht|bishernicht";

$however = "jedoch|^aber| aber|^doch| doch|dagegen|durchaus|hoffentlich|ausserdem|natürlich|trotzdem|nichtsdestotrotz|^trotz| trotz|allenfalls|andererseits|allerdings|dennoch|^hingegen| hingegen|obwohl|gleichwohl|^dabei| dabei|jedenfalls|nichtsdestoweniger|dessenungeachtet|unterdessen|indessen|sondern|^indes| indes|aberauch|aber auch"; 
$howeverCONTRAST = "jedoch|^aber| aber|^doch| doch|dagegen|durchaus|hoffentlich|ausserdem|natürlich|^trotz| trotz|allenfalls|andererseits|unterdessen|indessen|hingegen|^dabei| dabei|^indes| indes|aberauch|aber auch";
$howeverCONCESSION = "jedoch|allerdings|dennoch|^aber| aber|trotzdem|^hingegen| hingegen|obwohl|gleichwohl|^dabei| dabei|jedenfalls|nichtsdestotrotz|nichtsdestoweniger|dessenungeachted|unterdessen|sondern";




our @EXPORT = qw($EnConnectors @EnConnectorsSenses $NotEnConnectors $although $althoughCONTRAST $althoughCONCESSION $though $thoughCONTRAST $thoughCONCESSION $eventhough $eventhoughCONTRAST $eventhoughCONCESSION $since $sinceTEMPORAL $sinceCAUSAL $while $whileCONTRAST $whileCONCESSION $whileTEMPORAL $whileCAUSAL $meanwhile $meanwhileTEMPORAL $meanwhileCONTRAST $yet $yetCONCESSION $yetCONTRAST $yetADVERB $notyet $notyetADVERB $however $howeverCONTRAST $howeverCONCESSION);
1;

#****** End 8 connectives *******************************************************************************************************************************************************
