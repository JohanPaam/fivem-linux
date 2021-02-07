#!/bin/bash
# Script install Five M 
#=====================================================================================
# Author: Johan_Paam 
# Ce script est fait pour modifier les paramètres Ulimit de votre serveur VPS / Dédié pour augmenter le nombre d'ouverture de fichiers
#=====================================================================================
#=====================================================================================
echo "***********************************************************"
echo "Mise a jour des dépots"
apt update
apt upgrade

echo "Installation des paquets nécessaires"
sleep 3
apt install git
apt install sudo
echo "Paquets installer avec succès"
sleep 4

echo "Démarrage de l'installation du serveur Five M"
sleep 3
cd /home
mkdir fivem
cd /home/fivem
tar xvfJ fx.tar.xz
cd
echo "Serveur Five M installer dans le répertoire /home/fivem"
sleep 6


echo "Démarrage de l'installation de Apache + PhpMyAdmin + MySQL"
sleep 4

echo "Installation de Maria-DB"
sleep 3
apt-get -y install mariadb-server mariadb-client
mysql_secure_installation
service apache2 restart

echo "Installation de PhpMyAdmin"
sleep 3
apt install phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/html

echo "Création d'un utilisateur possédant les privièges Administrateur"
mysql -u root -p
UPDATE mysql.user SET plugin = 'mysql_native_password',Password = PASSWORD('NEWPASSWORD') WHERE User = 'root';
FLUSH PRIVILEGES;

echo "Utilisateur : 'auto-install' avec comme mot de pass 'auto-install' a bien été crée"
echo "Attenion ! Pensez a changer le mot de passe de cet utilisateur !"
sleep 5
echo "Vous pouvez désormais transférer votre serveur Five M et votre base de données en vous connectant sur ce lien 'http://ip-du-serveur/phpmyadmin
