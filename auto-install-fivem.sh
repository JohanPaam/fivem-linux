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
tar xvfJ fx.tar.xz
apt install git
apt install sudo
echo "Paquets installer avec succès"
sleep 4

echo "Démarrage de l'installation du serveur Five M"
sleep 3
cd /home
mkdir fivem
cd /home/fivem
git clone https://github.com/JohanPaam/cubix-fivem-install.git
cd /home/fivem/cubix-install-fivem
mv resources/ server.cfg /home/fivem
cd /home/fivem
rm -fr cubix-install-fivem/
cd
echo "Serveur Five M installer dans le répertoire /home/fivem"
sleep 6


echo "Démarrage de l'installation de Apache + PhpMyAdmin + MySQL"
sleep 4

echo "Installation de Maria-DB"
sleep 3
apt-get -y install mariadb-server mariadb-client
mysql_secure_installation
apt-get -y install php7.0 curl libapache2-mod-php7.0 build-essential apache2 php7.0-mysql aptgit php7.0-curl git php7.0-gd php7.0-intl php-pear php-imagick php7.0-imap php7.0-mcrypt php-memcache php7.0-pspell php7.0-recode php7.0-sqlite3 php7.0-tidy php7.0-xmlrpc php7.0-xsl php-apcu php7.0-ssh2 php7.0-opcache
service apache2 restart

echo "Installation de PhpMyAdmin"
sleep 3
apt install phpmyadmin

echo "Création d'un utilisateur possédant les privièges Administrateur"
mysql -u root -p
CREATE USER 'auto-install'@'localhost' IDENTIFIED BY 'auto-install';
GRANT ALL PRIVILEGES ON * . * TO 'auto-install'@'localhost';
FLUSH PRIVILEGES;
quit


echo "Utilisateur : 'auto-install' avec comme mot de pass 'auto-install' a bien été crée"
echo "Attenion ! Pensez a changer le mot de passe de cet utilisateur !"
sleep 5
echo "Vous pouvez désormais transférer votre serveur Five M et votre base de données en vous connectant sur ce lien 'http://ip-du-serveur/phpmyadmin
