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
@EnConnectorsSenses = ("althoughCONTRAST","althoughCONCESSION","thoughCONTRAST","thoughCONCESSION","eventhoughCONTRAST","eventhoughCONCESSION","sinceTEMPORAL","sinceCAUSAL","whileCONTRAST","whileCONCESSION","whileTEMPORAL","meanwhileTEMPORAL","meanwhileCONTRAST","yetCONCESSION","yetCONTRAST","yetADVERB","notyetADVERB","howeverCONTRAST","howeverCONCESSION");#keep the same structure of the connector sense name
#$NotEnConnectors="in the meanwhile|a while"; the 24/10/12
$NotEnConnectors="in the meanwhile| a while|^a while|a short while|asthough";  


$although = "même si|mêmesi|cependant|bien qu(e|'| ')|bienqu(e|'| ')|quoiqu(e|'| ')|sans qu(e|'| ')|sansqu(e|'| ')|malgré|encore qu(e|'| ')|encorequ(e|'| ')| mais|^mais|alors qu(e|'| ')|alorsqu(e|'| ')|toutefois| si|^si|en dépit|endépit"; 
$althoughCONTRAST = " mais|^mais|alors qu(e|'| ')|alorsqu(e|'| ')|encore qu(e|'| ')|encorequ(e|'| ')"; #sans que?
$althoughCONCESSION = " mais|^mais|cependant|bien qu(e|'| ')|bienqu(e|'| ')|même si|mêmesi|quoiqu(e|'| ')|malgré| si|^si|en dépit|endépit|toutefois";


$though	= "bien qu(e|'| ')|bienqu(e|'| ')|alors qu(e|'| ')|alorsqu(e|'| ')|cependant|même si|mêmesi|toutefois| mais|^mais|quoiqu(e|'| ')|pourtant|malgré|tout de même|toutdemême|néanmoins| si|^si";
$thoughCONTRAST = " mais|^mais|alors qu(e|'| ')|alorsqu(e|'| ')";	#pourtant?
$thoughCONCESSION = " mais|^mais|cependant|bien qu(e|'| ')|bienqu(e|'| ')|même si|mêmesi|quoiqu(e|'| ')|malgré|néanmoins|toutefois| si|^si";	# tout de même?


$eventhough = "bien qu(e|'| ')|bienqu(e|'| ')|alors qu(e|'| ')|alorsqu(e|'| ')|cependant|même si|mêmesi|toutefois| mais|^mais|quoiqu(e|'| ')|pourtant|malgré|tout de même|toutdemême|néanmoins|quand bien même|quandbienmême";	
$eventhoughCONTRAST = " mais|^mais|alors qu(e|'| ')|alorsqu(e|'| ')";	#pourtant?
$eventhoughCONCESSION = " mais|^mais|cependant|bien qu(e|'| ')|bienqu(e|'| ')|même si|mêmesi|quoiqu(e|'| ')|malgré|néanmoins|toutefois|quand bien même|quandbienmême";	# tout de même?


$since = "depuis qu(e|'| ')|depuisqu(e|'| ')|depuis|étant donné qu(e|'| ')|étantdonnéqu(e|'| ')|puisqu(e|'| ')|car|dès qu(e|'| ')|dèsqu(e|'| ')|parce qu(e|'| ')|parcequ(e|'| ')|entre-temps|entre temps|entretemps|comme"; 
$sinceTEMPORAL = "depuis qu(e|'| ')|depuisqu(e|'| ')|depuis|dès qu(e|'| ')|dèsqu(e|'| ')|entre-temps|entre temps|entretemps";
$sinceCAUSAL = "étant donné qu(e|'| ')|étantdonnéqu(e|'| ')|puisqu(e|'| ')|car|parce qu(e|'| ')|parcequ(e|'| ')|comme";


$while	= "même si|mêmesi|alors qu(e|'| ')|alorsqu(e|'| ')|tout en|touten|bien qu(e|'| ')|bienqu(e|'| ')| mais|^mais|lorsqu(e|'| ')|tandis qu(e|'| ')|tandisqu(e|'| ')| tant qu(e|'| ')| tantqu(e|'| ')|^tant qu(e|'| ')|^tantqu(e|'| ')|cependant|quand|pendant qu(e|'| ')|pendantqu(e|'| ')|pendant|s(i |'| '|' | ' )il est vrai qu(e|'| ')|silestvraique|siilestvraique| si|^si";
$whileCONTRAST	= "alors qu(e|'| ')|alorsqu(e|'| ')| mais|^mais|tandis qu(e|'| ')|tandisqu(e|'| ')";	
$whileCONCESSION	= " mais|^mais|cependant|bien qu(e|'| ')|bienqu(e|'| ')|même si|mêmesi|s(i |'| '|' | ' )il est vrai qu(e|'| ')|silestvraique|siilestvraique| si|^si";	
$whileTEMPORAL	= "tout en|touten|lorsqu(e|'| ')| tant qu(e|'| ')| tantqu(e|'| ')|^tant qu(e|'| ')|^tantqu(e|'| ')|pendant qu(e|'| ')|pendantqu(e|'| ')|quand|pendant";	#tandis que? 


$meanwhile = "d('| '|' | ' )ici là|deicilà|entre-temps|entre temps|entretemps|alors qu(e|'| ')|alorsqu(e|'| ')|pendant ce temps|pendantcetemps|en attendant|enattendant|parallèlement|à présent|àprésent|en revanche|enrevanche|par contre|parcontre|cependant|dans le même temps|danslemêmetemps|dans l('| '|' | ' )intervalle|dansleintervalle|depuis|toutefois|pour autant|pourautant|quoi qu('| '|' | ' )il en soit|quoiqueilensoit"; 
$meanwhileTEMPORAL = "d('| '|' | ' )ici là|deicilà|entre-temps|entre temps|entretemps|pendant ce temps|pendantcetemps|en attendant|enattendant|parallèlement|à présent|àprésent|dans le même temps|danslemêmetemps|dans l('| '|' | ' )intervalle|dansleintervalle|depuis";
$meanwhileCONTRAST = "alors qu(e|'| ')|alorsqu(e|'| ')|en revanche|enrevanche|par contre|parcontre|pour autant|pourautant|quoi qu('| '|' | ' )il en soit|quoiqueilensoit|cependant";


$yet = "alors qu(e|'| ')|alorsqu(e|'| ')|pas encore|pasencore|encore|de plus|deplus|plus|cependant|néanmoins|toutefois|pourtant|déjà|jusqu('| '|' | ' )à présent|jusqueàprésent|jusqu('| '|' | ' )à maintenant|jusqueàmaintenant|pour l('| '|' | ' )instant|pourleinstant|alors même qu(e|'| ')|alorsmêmeque| mais|^mais|voilà qu(e|'| ')|voilàque| or|^or";
$yetCONCESSION = " mais|^mais|cependant|néanmoins|toutefois";
$yetCONTRAST = "alors qu(e|'| ')|alorsqu(e|'| ')| mais|^mais|voilà qu(e|'| ')|voilàque| or|^or|alors même qu(e|'| ')|alorsmêmeque";
$yetADVERB = "pas encore|pasencore|encore|de plus|deplus|plus|pour l('| '|' | ' )instant|pourleinstant|jusqu('| '|' | ' )à présent|jusqueàprésent|jusqu('| '|' | ' )à maintenant|jusqueàmaintenant";

$notyet = "pas encore|pasencore|non encore|nonencore";
$notyetADVERB = "pas encore|pasencore|non encore|nonencore";

$however = "toutefois|cependant| mais|^mais|néanmoins|pourtant| or|^or|par contre|parcontre|en revanche|enrevanche|cela dit|celadit|quoi qu('| '|' | ' )il en soit|quoiqueilensoit|aussi|même si|mêmesi|quand même|quandmême|tout de même|toutdemême|par ailleurs|parailleurs|d(e|')ailleurs|deailleurs|pour autant|pourautant|ceci étant dit|ceciétantdit|ceci étant|ceciétant|ceci dit|cecidit|cela étant dit|celaétantdit|cela étant|celaétant|cela dit|celadit|malgré|en tout cas|entoutcas|bien qu(e|'| ')|quelle que|quelleque|quel que|quelque|seulement|au contraire|aucontraire|en effet|eneffet|en outre|enoutre|certes|alors qu(e|'| ')|alorsqu(e|'| ')|quelqu(e|')|quoiqu(e|')"; # |plutôt , on a enlevé
$howeverCONTRAST = " mais|^mais|par contre|parcontre|en revanche|enrevanche|au contraire|aucontraire|en effet|eneffet|alors qu(e|'| ')|alorsqu(e|'| ')";
$howeverCONCESSION = "toutefois|cependant| mais|^mais|néanmoins|pourtant| or|^or|quoi qu('| '|' | ' )il en soit|quoiqueilensoit|aussi|même si|mêmesi|quand même|quandmême|tout de même|toutdemême|pour autant|pourautant|ceci étant dit|ceciétantdit|ceci étant|ceciétant|ceci dit|cecidit|cela étant dit|celaétantdit|cela étant|celaétant|cela dit|celadit|malgré|en tout cas|entoutcas|bien qu(e|'| ')|bienqu(e|'| ')|quelle que|quelleque|quel que|quelque|quoiqu(e|')";


our @EXPORT = qw($EnConnectors @EnConnectorsSenses $NotEnConnectors $although $althoughCONTRAST $althoughCONCESSION $though $thoughCONTRAST $thoughCONCESSION $eventhough $eventhoughCONTRAST $eventhoughCONCESSION $since $sinceTEMPORAL $sinceCAUSAL $while $whileCONTRAST $whileCONCESSION $whileTEMPORAL $meanwhile $meanwhileTEMPORAL $meanwhileCONTRAST $yet $yetCONCESSION $yetCONTRAST $yetADVERB $notyet $notyetADVERB $however $howeverCONTRAST $howeverCONCESSION);
1;

#****** End 8 connectives *******************************************************************************************************************************************************
