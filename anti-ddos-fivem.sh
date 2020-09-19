#!/bin/bash +x

### Script By Johan_Paam ###
# ATTENTION !!! #
# C'est un script de prévention contre les attaques, les attaques ne seront pas totalement contrer uniquement atténué et réduite au maximum ! #

# On defini les variables
#SYSCTL=/usr/bin/sysctl
IPTABLES=/usr/bin/iptables
IPTABLES_SAVE=/usr/bin/iptables-save
IPTABLES_RULE_FILE=/etc/iptables/iptables.rules
IP_ADDR=192.168.1.70
BROADCAST=192.168.1.255
DNS_SERVERS="192.168.1.2"
SSH=22      # SSH port to connect
SSHD=22     # SSHd server port

# Active le rp_filter dans le Kernel (Cela protège la machine contre les attaques d'IP Spoofing)
#$SYSCTL net.ipv4.conf.all.rp_filter="1"

# Active la protection sur les connexions TCP en Time Wait
# Tout les paquets en Time Wait sont Drop
#$SYSCTL net.ipv4.tcp_rfc1337="1"

# On supprime toutes les règles deja existantes
sudo iptables -F
sudo iptables -X

# On Drop tout les paquets par défaut 
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT DROP

# Création de chaines
sudo iptables -N COMMON
sudo iptables -N PORTSCAN
sudo iptables -N SPOOFING
sudo iptables -N ICMP_IN
sudo iptables -N UDP_IN
sudo iptables -N TCP_IN
sudo iptables -N TCP_OUT




#
# On configure les chaines
#

# On envoi tout les traffic a la chaine Portscan
sudo iptables -A INPUT -j PORTSCAN

# On envoi tout le traffic a la chaine Common
sudo iptables -A INPUT -j COMMON

# On envoi tout le traffic a la chaine Spoofin
sudo iptables -A INPUT -j SPOOFING

# On envoi tout le traffic ICMP a la chaine ICMP
sudo iptables -A INPUT -p icmp -j ICMP_IN

# On envoi tout le traffic UDP a la chaine UDP_IN
sudo iptables -A INPUT -p udp -j UDP_IN

# On envoi tout le traffic TCP a la chaine TCP_IN
sudo iptables -A INPUT -p tcp -j TCP_IN

# On envoi tout les Ttaffic TCP a la chaine TCP_OUT
sudo iptables -A OUTPUT -p tcp -j TCP_OUT



#
# Chaine de règles Portscan
#

# Drop les attaques de type Portscan
sudo iptables -A PORTSCAN -p tcp --tcp-flags ACK,FIN FIN -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags ACK,PSH PSH -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags ACK,URG URG -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags ALL ALL -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags ALL NONE -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
sudo iptables -A PORTSCAN -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

# Return to parent chain
sudo iptables -A PORTSCAN -j RETURN 

# On bloque l'ICMP (le Ping)
sudo iptables -A ICMP_IN -j REJECT --reject-with icmp-proto-unreachable


#
# Anti-Spoofing règles
#

# Drop packets claiming to be the loopback interface (protects against source quench)
sudo iptables -A SPOOFING ! -i lo -d 127.0.0.0/8 -j DROP

# Drop spoofed packets pretending to be from your IP address
sudo iptables -A SPOOFING ! -i lo -s $IP_ADDR -j DROP

# Drop "Class D" multicast addresses. Multicast is illegal as a source address.
sudo iptables -A SPOOFING -s 224.0.0.0/4 -j DROP

# Refuse "Class E" reserved IP addresses
sudo iptables -A SPOOFING -s 240.0.0.0/5 -j DROP

# Drop broadcast address packets
sudo iptables -A SPOOFING ! -i lo -d $BROADCAST -j DROP

# Return to parent chain
sudo iptables -A SPOOFING -j RETURN



           ####
# Protection Serveur Five M #
           ####
           
# Limitation des paquets / secondes en UDP sur le port 30120
sudo iptables -A INPUT -p UDP_IN --destination-port 30120 -m state --state NEW -m limit --limit 8/s --limit-burst 10 -j ACCEPT
sudo iptables -A INPUT -p TCP_IN --destination-port 30120 -m limit --limit 14/s -j ACCEPT

# Limitation des paquets / secondes en TCP sur le port 30120 pour mieux encaisser les attaques de type Layer 7
sudo iptables -A OUTPUT -p TCP_OUT --destionation-port 30120 -m limit --limit 4/s -j ACCEPT

# Limitation des paquets / secondes en UDP sur les connexions établies sur le port 30120
sudo iptables -A INPUT -m state --state RELATED,ESTABLISHED -m limit --limit 16/s --limit-burst 20 -j ACCEPT


# Protection Machine
# On force la vérification des Paquets en SYN
sudo iptables -A COMMON -p tcp ! --syn -m state --state NEW -j DROP

# Ouvertures des Ports Indispensable 
sudo iptables -A TCP_IN -p tcp --dport 22 -j ACCEPT
sudo iptables -A TCP_OUT -p tcp --destionation-port 80 -m limit --limit 3/s --limit-burst 6 -j ACCEPT
sudo iptables -A TCP_OUT -p tcp --dport 22 -j ACCEPT


# Autoriser les connexions deja établies 
sudo iptables -A COMMON -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Partie Indispensable
# On autorise les connexions DNS sortantes
for DNS in $DNS_SERVERS; do
    sudo iptables -A UDP_OUT -p udp -d $DNS --sport 1024:65535 --dport 53 -j ACCEPT
done


# Faire en soirte de que tout les autres paquets sortant en TCP soit Drop et Logger
sudo iptables -A TCP_OUT -m limit --limit 2/min -j LOG --log-prefix "iptables TCP_OUT dropped: " --log-level 7
sudo iptables -A TCP_OUT -j DROP

# Faire en soirte de que tout les autres paquets sortant en UDP soit Drop et Logger
sudo iptables -A UDP_OUT -m limit --limit 2/min -j LOG --log-prefix "iptables UDP_OUT dropped: " --log-level 7
sudo iptables -A UDP_OUT -j DROP

# Script pas encore terminé 
