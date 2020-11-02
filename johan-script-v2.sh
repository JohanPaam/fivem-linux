#!/bin/bash +x

### Script By Johan_Paam ###
# ATTENTION !!! #
# V 1.2 Beta #
# C'est un script de prévention contre les attaques, les attaques ne seront pas totalement contrer uniquement atténué et réduite au maximum ! #

# Fermeture de tout les ports et ouverture des ports nécessaire
iptables -A INPUT -p udp -m udp --dport 0:21 -j DROP
iptables -A INPUT -p udp -m udp --dport 23:79 -j DROP
iptables -A INPUT -p udp -m udp --dport 81:30119 -j DROP
iptables -A INPUT -p udp -m udp --dport 30121:65565 -j DROP

iptables -A INPUT -p tcp -m tcp --dport 0:21 -j DROP
iptables -A INPUT -p tcp -m tcp --dport 23:79 -j DROP
iptables -A INPUT -p tcp -m tcp --dport 81:30119 -j DROP
iptables -A INPUT -p tcp -m tcp --dport 30121:65565 -j DROP

# On autorise les connexions deja établies 
iptables -A INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT

# On Drop tout les paquets malformer ou les paquets Nul
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP

# On force la vérification des paquets de type SYN 
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP

# On Drop tout les paquets de type XMAS
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP

# Packet Matching Based on TTL Values
iptables -A INPUT -s 1.2.3.4 -m ttl --ttl-lt 40 -j REJECT

# On Drop tout l'ICMP 
iptables -A OUTPUT -p icmp --icmp-type echo-request -j DROP

# On Drop les attaques de type Portscan
iptables -A INPUT -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -A INPUT -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -A INPUT -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP

# Protection contre les attaques de type Spoofing
iptables -N spoofing
iptables -I spoofing -j LOG --log-prefix "IP Source Spoof"
iptables -I spoofing -j DROP
iptables -A INPUT -s 255.0.0.0/8 -j spoofing
iptables -A INPUT -s 0.0.0.8/8 -j spoofing

# Protection contre les attaques de type UDP 
iptables -A INPUT -p udp --sport 30120 -m limit --limit 12/s --limit-burst 14 -j ACCEPT

# Protection contre les attaques de type TCP SYN
iptables -A INPUT -p tcp  --syn --sport 30120 -m limit --limit 12/s -j ACCEPT

# Protection contre les attaques de type SYN Flood par SYN Proxy
iptables -t raw -A PREROUTING -p tcp -m tcp --syn -j CT --notrack
iptables -A INPUT -p tcp -m tcp -m conntrack --ctstate INVALID,UNTRACKED -j SYNPROXY --sack-perm --timestamp --wscale 7 --mss 1460
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# On active le RP Filter dans le Kernel
sudo sysctl -w net.ipv4.conf.default.rp_filter=1
sudo sysctl -w net.ipv4.conf.all.rp_filter=1
sudo sysctl -w net.ipv4.conf.all.log_martians=1
sudo sysctl -w net.ipv4.conf.default.log_martians=1

# Autorisation des différentes IPs de Five M
iptables -A INPUT -s 104.22.46.177 -j ACCEPT # Liste Five M
iptables -A INPUT -s 104.22.47.177 -j ACCEPT # Liste Five M
iptables -A INPUT -s 172.67.38.114 -j ACCEPT # Servers Ingress Five M
iptables -A INPUT -s 51.91.21.135 -j ACCEPT # Serveur d'authentification des clés Nucleus
iptables -A INPUT -s 45.95.114.64 -j ACCEPT 
