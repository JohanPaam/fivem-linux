#!/bin/bash
# Script install Five M 
#=====================================================================================
# Author: Johan_Paam 
#=====================================================================================
#=====================================================================================
echo "***********************************************************"
echo "Mise a jour des dépots"
apt update
apt upgrade

echo "Installation des paquets nécessaires"
sleep 3
apt install ipset htop nload tcpdump curl screen wget sudo git zip unzip
echo "Paquets installer avec succès"
sleep 4

echo "Démarrage de l'installation du serveur Five M"
sleep 3
cd /home
mkdir fivem
cd /home/fivem
wget "lien de l'artefact https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/"
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

echo "Création d'un utilisateur possédant les privièges Administrateur"
mysql -u root -p
UPDATE mysql.user SET plugin = 'mysql_native_password',Password = PASSWORD('NEWPASSWORD') WHERE User = 'root';
FLUSH PRIVILEGES;

echo "Installation de PhpMyAdmin"
sleep 3
apt install phpmyadmin
sudo ln -s /usr/share/phpmyadmin /var/www/html

sleep 5
echo "Vous pouvez désormais transférer votre serveur Five M et votre base de données en vous connectant sur ce lien 'http://ip-du-serveur/phpmyadmin
