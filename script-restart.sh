#!/bin/bash
# Script Auto Install Five M
#=====================================================================================
# Author: Johan_Paam 
#=====================================================================================
#=====================================================================================
echo "***********************************************************"
echo `date '+%d-%B-%Y_%H:%M:%S'` " - Arrêt du serveur..."
echo "Script Restart Serveur Five M by Johan_Paam for Valoria"y
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
