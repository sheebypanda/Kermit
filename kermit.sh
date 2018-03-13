#!/bin/bash
#
#  drKermit.sh
#
#    script pour lancer kermit
#    ( par D. Robert, 3 Sept. 2006 )

# # # Debut du script proprement dit # # #

prg=/usr/bin/kermit
port=/dev/ttyUSB0
param="SET CARRIER-WATCH OFF,set flow-control none,set handshake cr,set session-log timestamped-text,connect,exit"

 if [ -z $DISPLAY ]
  then
	DIALOG=dialog
  else
	DIALOG=Xdialog
 fi

DIALOG=dialog

# Definition d'une boite de cases a cocher
# Menu principal de choix des boites du script
function chec
{
# boite de cases a cocher proprement dite
$DIALOG --backtitle "Choix de la Vitesse pour l'émulateur KERMIT" --title "Choix Vitesse" \
--ok-label "Valider" --cancel-label "Quitter" \
--radiolist "
Cochez la vitesse souhaite pour KERMIT." 18 60 10 \
"96" "9600  8 n 1" on \
"19" "19200 8 n 1" off \
"38" "38400 8 n 1" off \
"11" "115200 8 n 1" off  2>$FICHTMP
# traitement de la reponse
# 0 est le code retour du bouton Valider
# ici seul le bouton Valider permet de continuer
# tout autre action (Quitter, Esc, Ctrl-C) arrete le script.
if [ $? = 0 ]
then
for i in `cat $FICHTMP`
do
case $i in
# Lancement Kermit en 9600
96*) vitesse=9600
     KermLance
     ;;
# Lancement Kermit en 19200
19*) vitesse=19200
     KermLance
     ;;
# Lancement Kermit en 38400
38*) vitesse=38400
     KermLance
     ;;
# Lancement Kermit en 115200
11*) vitesse=115200
     KermLance
     ;;
esac
done
else KermFin; exit 0
fi
}

# Lancement Kermit
function KermLance
{
clear screen
echo Bonjour
echo 
echo Bienvenue dans Kermit
echo
echo $1
echo
sudo $prg -l $port -b $vitesse -C "$param"
#cmde='sudo $prg -l $port -b $vitesse -C "$param"'
#script -c "$cmde" /tmp/ABC 
KermFin; exit 0
}


# Fin Kermit
function KermFin 
{
clear screen
echo Au Revoir
echo 
echo A bientot dans Kermit
echo
echo
exit 0
}

# Definition d'un fichier temporaire
# Il sert a conserver les sorties de dialog qui sont normalement
# redirigees vers la sortie d'erreur (2). trap sert a etre propre.
touch /tmp/dialogtmp && FICHTMP=/tmp/dialogtmp
#trap "rm -f $FICHTMP" 0 1 2 3 5 15

sleep 1
chec
sleep 1

KermFin
#kermit -l /dev/ttyUSB0 -b $1 -C "SET CARRIER-WATCH OFF,connect"

