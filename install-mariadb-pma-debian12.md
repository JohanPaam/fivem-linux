#  **Installation MySQL & PhpMyAdmin Debian 12**


Pré-requis

- Avoir un VPS sous Debian 12


### Mise a jour des paquets 
```
apt update -y
```
```
apt upgrade -y
```

### Installation des dépendances de base
```
apt install sudo nload htop tcpdump curl zip unzip net-tools screen ipset -y
```

## INSTALLATION DE MARIADB

```
apt install mariadb-server-core mariadb-server mariadb-client
```
```
mysql_secure_installation
```

[ Enter current password for root (enter for none): ]
Mettre le mdp voulu 

[ Switch to unix_socket authentication [Y/n] ]
Mettre n 

[ Change the root password? [Y/n] ]
Mettre n

[ Remove anonymous users? [Y/n] ]
Mettre Y 

[ Disallow root login remotely? [Y/n] ]
Mettre n

Remove test database and access to it? [Y/n]
Mettre Y

Reload privilege tables now? [Y/n]
Mettre Y




## CREATION USER MYSQL
```
sudo mysql
```


Changez le votremdp par le mot de passe que vous voulez mettre, ne copiez pas bettement la ligne
```
CREATE USER 'admin'@'%' IDENTIFIED BY 'votremdp';
```

```
GRANT ALL ON *.* TO 'admin'@'%' WITH GRANT OPTION;
```

```
FLUSH PRIVILEGES;
```

```
exit
```

## ALLOW REMOTELY LOGIN

Se rendre dans le fichier

```
/etc/mysql/mariadb.conf.d/50-server.cnf
```

A la ligne "bind-address            = 127.0.0.1"  remplacer par "bind-address            = 0.0.0.0"
Enregistrez le fichier

Redémarrez mariadb avec la commande 
```
sudo mysql restart
```

### INSTALLATION PMA
```
apt install phpmyadmin -y
```

Selectionner Apache2
Attendre la fin de l'installation 

```
sudo ln -s /usr/share/phpmyadmin /var/www/html
```


MariaDB & PhpMyAdmin sont désormais installé et prêt pour utilisation . 
