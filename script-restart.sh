#!/bin/bash
# Script Auto Install Five M
#=====================================================================================
# Author: Johan_Paam 
# Si votre serveur se trouve dans un autre répertoire, modifiez le chemin d'accès vers le votre
# Ce script est fait pour redémarrer votre serveur Five M en vidant automtiquement le cache de votre serveur
#=====================================================================================
#=====================================================================================
echo "***********************************************************"
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Arrêt du serveur..."
echo "Script Restart Serveur Five M by Johan_Paam"
kill -9 `ps -ef | grep "/home/fivem/" | grep -v grep | awk '{print $2}'`
sleep 2
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Nettoyage du cache..."
rm -R /home/fivem/cache/
sleep 2
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Démarrage du serveur..."
screen -x serveur -X stuff 'cd /home/fivem/
/home/fivem/run.sh +exec server.cfg
'
sleep 18
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Serveur Démarrer avec succès"
