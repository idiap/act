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
@EnConnectorsSenses = ("althoughCONTRAST","althoughCONCESSION","thoughCONTRAST","thoughCONCESSION","eventhoughCONTRAST","eventhoughCONCESSION","sinceTEMPORAL","sinceCAUSAL","whileCONTRAST","whileCONCESSION","whileTEMPORAL","meanwhileTEMPORAL","meanwhileCONTRAST","yetCONCESSION","yetCONTRAST","yetADVERB","notyetADVERB","howeverCONTRAST","howeverCONCESSION");

#$NotEnConnectors="in the meanwhile|a while"; the 24/10/12
$NotEnConnectors="in the meanwhile| a while|^a while|a short while|asthough";  

$although = "anche se|anchese|sebbene|benché|seppure|pure|pur|per quanto|perquanto|nonostante|malgrado|^ma| ma|tuttavia|mentre|invece|però|a prescindere da|aprescindereda"; 
$althoughCONTRAST = "^ma| ma|tuttavia|mentre|invece";# 'però' non car incertain, 'cio nonostante' contrastive: rare
$althoughCONCESSION = "anche se|anchese|sebbene|benché|nonostante|malgrado|seppure|per quanto|perquanto|a prescindere da|aprescindereda"; 
#Preprocessing: a prescindere dalla, ….. ==> a prescindere da il, pur ==> pure
#Preprocessing: da+il = dal 
#Preprocessing: di+il = del 
#Preprocessing: dall' = da+il+voyelle
#Preprocessing: dell' = di+il+voyelle (a seguito dell')
#New sense ?
#$althoughADDITIVE = "pure|per quanto|anche|certo|ugualmente"; # "pur" or "pure" or "pur tuttavia" ? 
#Not found in CS's List: anche se, pur, per quanto, 

# connectives found in CS's List
#PUR_TUTTAVIA	B	Contrastive
#PURE	C	Additive
#PER_QUANTO_CONCERNE	E	Additive
#PER_QUANTO_RIGUARDA	E	Additive
#NONOSTANTE	C	Concessive, contrastive
#NONOSTANTE	E	Concessive

$though	= "anche se|anchese|sebbene|tuttavia|però|per quanto|perquanto|benché|malgrado|magari|^ma| ma|seppure|eppure|pure|pur|nonostante|mentre|comunque|ancorché|invece|peraltro|quantunque"; 
$thoughCONTRAST = "tuttavia|però|^ma| ma|mentre|comunque|invece|eppure|peraltro";
$thoughCONCESSION = "anche se|anchese|sebbene|benché|nonostante|seppure|ancorché|malgrado|quantunque|magari|per quanto|perquanto"; 
#New sense ?
#$thoughADDITIVE = "pur|per quanto|quasi|anche|come|dunque|magari|poi"; # "pur" or "pure" or "pur tuttavia" ?
# connectives found in CS's List
#PUR_TUTTAVIA	B	Contrastive
#PURE	C	Additive
#ALMENO	B	Evaluative
#PERCIO'	C	Causal
#COME_SE	C	Hypothesis
#POI	B	Temporal, additive
#QUASI	C	Additive


$eventhough = "anche se|anchese|sebbene|benché|seppure|pure|pur|per quanto|perquanto|nonostante|anche quando|anchequando|malgrado|tuttavia|mentre|invece"; 
$eventhoughCONTRAST = "tuttavia|mentre|invece";
$eventhoughCONCESSION = "anche se|anchese|sebbene|benché|nonostante|malgrado|seppure|anche quando|anchequando|per quanto|perquanto";
#Preprocessing: pur ==> pure

#New sense ?
#$eventhoughADDITIVE = "pur|per quanto|anche|persino"; # "pur" or "pure" or "pur tuttavia" ?
# connectives found in CS's List
#PUR_TUTTAVIA	B	Contrastive
#PURE	C	Additive
#PER_QUANTO_CONCERNE	E	Additive
#PER_QUANTO_RIGUARDA	E	Additive
#NONOSTANTE	C	Concessive, contrastive
#NONOSTANTE	E	Concessive




$since = "poiché|da quando|daquando|dal momento|dalmomento|da il momento|dailmomento|da allora|daallora|dopo|a partire da|apartireda|fin da|finda|dato che|datoche|in quanto|inquanto|in seguito|inseguito|sin da|sinda|visto che|vistoche|perché|a seguito|aseguito|giacché|nel frattempo|nelfrattempo|poi|come|nel|tanto più che|tantopiùche|sin d'allora|sind'allora|^da| da";  

$sinceTEMPORAL = "da quando|daquando|dal momento|dalmomento|da il momento|dailmomento|da allora|daallora|dopo|a partire da|apartireda|sin da|sinda|fin da|finda|nel frattempo|nelfrattempo|poi|nel|sin d'allora|sind'allora|in seguito|inseguito|a seguito|aseguito|^da| da";
$sinceCAUSAL = "poiché|dato che|datoche|in quanto|inquanto|visto che|vistoche|perché|giacché|come|tanto più che|tantopiùche"; 
#Preprocessing: da+il = dal 
#Preprocessing: di+il = del 
#Preprocessing: dall' = da+il+voyelle
#Preprocessing: dell' = di+il+voyelle (a seguito dell')

#New senses
#$sinceCONCESSION = "dal momento che";
#$sinceADDITIVE = "soprattutto|come";
#other connectives found in CS's List
#IN_SEGUITO	B	Temporal
#AL_FINE_DI	E	Causative



$while	= "mentre|sebbene|al contempo|alcontempo|allo stesso tempo|allostessotempo|anche se|anchese|^ma| ma|benché|nel contempo|nelcontempo|al tempo stesso|altempostesso|contemporaneamente|seppure|durante|finché|quando|sempre|tuttavia|dato che|datoche|inoltre|invece|nello stesso tempo|nellostessotempo|nonostante|peraltro|poi|in quanto|inquanto|insieme|intanto|nel frattempo|nelfrattempo|^nel| nel|^se| se|pure|pur";
$whileCONTRAST	= "mentre|^ma| ma|invece|peraltro|tuttavia";	
$whileCONCESSION	= "sebbene|anche se|anchese|benché|seppure|finché|nonostante|^se| se"; 
$whileTEMPORAL	= "nel contempo|nelcontempo|allo stesso tempo|allostessotempo|al tempo stesso|altempostesso|contemporaneamente|durante|finché|quando|nello stesso tempo|nellostessotempo|poi|intanto|nel frattempo|nelfrattempo|^nel| nel|al contempo|alcontempo";
#Preprocessing: pur ==> pure

#New senses ?
#$whileADDITIVE = "pure|al contempo|inoltre|insieme|per quanto"; 
#$whileCAUSAL	= "in quanto|poiché|quindi|dato che";
#connectives found in CS's List
#PUR_TUTTAVIA	B	Contrastive
#PURE	C	Additive
#QUANDO	B	Temporal, contrastive
#QUANDO	C	Temporal, concessive


$meanwhile = "nel frattempo|nelfrattempo|al contempo|alcontempo|per intanto|perintanto|intanto|nel contempo|nelcontempo|frattanto|invece|mentre|per contro|percontro|allo stesso tempo|allostessotempo|attualmente|nello stesso tempo|nellostessotempo|^ora| ora|poi|per il momento|perilmomento";   

$meanwhileTEMPORAL = "nel frattempo|nelfrattempo|per intanto|perintanto|intanto|nel contempo|nelcontempo|allo stesso tempo|allostessotempo|nello stesso tempo|nellostessotempo|^ora| ora|poi|attualmente|per il momento|perilmomento|perilmomento|frattanto"; # frattanto  ? ok 
$meanwhileCONTRAST = "invece|mentre|per contro|percontro";
#New sense ?
#$meanwhileADDITIVE = "al contempo"; 
#CS's List
#ORA	B	Temporal, additive
#ORA	C	Temporal, additive



$yet = "ancora|eppure|tuttavia|invece|mentre|ciò nonostante|ciònonostante|ciononostante|nonostante|pure|pur|quindi|ciò nondimeno|ciònondimeno|per quanto|perquanto|al momento|almomento|contemporaneamente|finora|infatti|malgrado|nel frattempo|nelfrattempo|nonché|per ora|perora|tutt'oggi|tutt 'oggi|tutt' oggi|tutt ' oggi|al contempo|alcontempo|anche se|anchese|^ma| ma";  
$yetCONCESSION = "nonostante|per quanto|perquanto|al momento|almomento|malgrado|ciò nondimeno|ciònondimeno|anche se|anchese";#  al momento ?
$yetCONTRAST = "ciò nonostante|ciònonostante|ciononostante|eppure|^ma| ma|tuttavia|invece|mentre"; 
$yetADVERB = "ancora";#ancora?
#Preprocessing: pur ==> pure
#New senses ?
#$yetTEMPORAL = "contemporaneamente|finora|nel frattempo";#tutt'oggi ?
#$yetADDITIVE = "anche|pur|per quanto|infatti|nonché|al contempo";  #per quanto ? 
#$yetCAUSAL	= "quindi";


$notyet = "non ancora|nonancora|non hanno ancora|nonhannoancora|ancora"; 
$notyetADVERB = "non ancora|nonancora|non hanno ancora|nonhannoancora|ancora";

$however = "tuttavia|^ma| ma|però|comunque|invece|eppure|ciononostante|ciònonostante|nondimeno|^ora| ora|orbene|peraltro"; 
$howeverCONTRAST = "tuttavia|^ma| ma|però|comunque|invece|eppure|ciononostante|ciònonostante|peraltro";
$howeverCONCESSION = "nondimeno|^ora| ora|orbene";

#however	nondimeno	14
#however	orbene	1

our @EXPORT = qw($EnConnectors @EnConnectorsSenses $NotEnConnectors $although $althoughCONTRAST $althoughCONCESSION $though $thoughCONTRAST $thoughCONCESSION $eventhough $eventhoughCONTRAST $eventhoughCONCESSION $since $sinceTEMPORAL $sinceCAUSAL $while $whileCONTRAST $whileCONCESSION $whileTEMPORAL $meanwhile $meanwhileTEMPORAL $meanwhileCONTRAST $yet $yetCONCESSION $yetCONTRAST $yetADVERB $notyet $notyetADVERB $however $howeverCONTRAST $howeverCONCESSION);
1;

#****** End 8 connectives *******************************************************************************************************************************************************
