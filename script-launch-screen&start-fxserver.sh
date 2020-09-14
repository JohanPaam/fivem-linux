#!/bin/bash
# Script Auto Install Five M
#=====================================================================================
# Author: Johan_Paam 
# Si votre serveur se trouve dans un autre répertoire, modifiez le chemin d'accès vers le votre
# Ce script est fait pour crée un screen en démarrant le serveur Five M dans celui ci
#=====================================================================================
#=====================================================================================
echo "***********************************************************"
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Création du Screen + Démarrage du serveur ..."
echo "Script Screen + Serveur Five M by Johan_Paam"
screen -S serveur -S stuff 'cd /home/fivem/
/home/fivem/run.sh +exec server.cfg
'
sleep 10
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Serveur Démarrer avec succès"
