#!/bin/bash
### version 1.0  - 11JAN 2020 - commented dnsmasq and added radvd, and bind9  and new dhcpd and dhcppd6.conf files
### version 1.1 - 02MAY2020 - added sudo mkdir -p /var/www/html/CRYPTO/ 2>&1 | tee -a /tmp/IB/installer.log
### version 1.1.1 - 1 June 2020 - installed sudo cpan -i Crypt::Twofish and added below crontabs:
##############
##############
### version 1.1.2 - added sudo apt-get -y install netfilter-persistent ipset-persistent iptables-persistent 
### version 1.1.3 - enabled ssh with 
      ###### sudo systemctl enable ssh
      ###### sudo systemctl start ssh 


echo "HANDLE THE BLOCKED COUNTRIES-YES OR NO"
dt=`date '+%d_%m_%Y_%H_%M_%S'`
echo "$dt" 2>/dev/null 2>&1  | tee -a /tmp/IB/installer.log
sudo rfkill unblock all
sudo rm /dev/rfkill  ####### wlan0 blocked by fkill

echo "Enable SSH"
sudo systemctl enable ssh 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl start ssh  2>&1  | tee -a /tmp/IB/installer.log


sudo apt update 2>&1  | tee -a /tmp/IB/installer.log
apt-get -y upgrade   2>&1  | tee -a /tmp/IB/installer.log
 apt-get install -y libcgi-pm-perl 2>&1  | tee -a /tmp/IB/installer.log
######################## PI4 ###########################################################


#### packets to be installed ######################## 
 sudo apt-get -y install tar sed ipset dos2unix apache2 nmap  arp-scan libcgi-session-perl libssl-dev libdevice-serialport-perl libdevice-modem-perl tcpdump pulseaudio-module-bluetooth evtest 2>&1  | tee -a /tmp/IB/installer.log
sudo apt-get -y install isc-dhcp-server radvd bind9 bind9utils dnsutils hostapd  mc 2>&1  | tee -a /tmp/IB/installer.log
sudo apt-get -y install netfilter-persistent ipset-persistent iptables-persistent


################# install AP #######################
###################################################
sudo systemctl disable wpa_supplicant.service 2>&1  | tee -a /tmp/IB/installer.log

#### edit /etc/sysctl.conf and uncomment net.ipv4.ip_forward=1 also for Ipv6
    sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 2>&1  | tee -a /tmp/IB/installer.log
    sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT  2>&1  | tee -a /tmp/IB/installer.log
    sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT 2>&1  | tee -a /tmp/IB/installer.log

 #### in sysctl.conf:
  sudo sysctl -w net.ipv4.ip_forward=1 2>&1  | tee -a /tmp/IB/installer.log
  sleep 1s 2>&1  | tee -a /tmp/IB/installer.log
######sudo sysctl -w net.ipv6.conf.all.forwarding=1  ### de mutat mai jos
 
 
sudo iptables-save > /etc/iptables.ipv4.nat 2>&1  | tee -a /tmp/IB/installer.log

### routing Ipv6  #########
sudo echo "2" > /proc/sys/net/ipv6/conf/eth0/accept_ra 2>&1  | tee -a /tmp/IB/installer.log
sudo ip -6 addr add fdda:8765:4321:fdda::1/64 dev wlan0  2>&1  | tee -a /tmp/IB/installer.log
sudo sh -c "echo 1 > /proc/sys/net/ipv6/conf/all/forwarding"  2>&1  | tee -a /tmp/IB/installer.log

 sudo ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE 2>&1  | tee -a /tmp/IB/installer.log
    sudo ip6tables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT 2>&1  | tee -a /tmp/IB/installer.log
    sudo ip6tables -A FORWARD -i wlan0 -o eth0 -j ACCEPT  2>&1  | tee -a /tmp/IB/installer.log

 sudo sysctl -w net.ipv6.conf.all.forwarding=1 2>&1  | tee -a /tmp/IB/installer.log
sudo ip6tables-save > /etc/iptables.ipv6.nat 2>&1  | tee -a /tmp/IB/installer.log

##############################################

iptables -N BLOCKED 2>&1  | tee -a /tmp/IB/installer.log   ###

###################################### END PI4   ####################################################



#####echo " supposed root ssh keys are generated with ssh-keygen "
echo " unzip piwall.tar.gz "  2>&1 | tee -a /tmp/IB/installer.log
sudo wget https://www.2transfer.eu/iblocker/IBlocker.tar.gz -P /tmp/IB 2>&1 | tee -a /tmp/IB/installer.log
sudo chmod 755 /tmp/IB/IBlocker*.tar.gz 2>&1 | tee -a /tmp/IB/installer.log
sudo tar xvzf /tmp/IB/IBlocker*.tar.gz -C /tmp/IB 2>&1 | tee -a /tmp/IB/installer.log
sudo mkdir /opt/IB 2>&1 | tee -a /tmp/IB/installer.log
sudo mv /tmp/IB/home/BACKUP/* /tmp/IB/ARCHIVE 2>&1 | tee -a /tmp/IB/installer.log
#####sudo rm -R /etc/apache2 2>&1 | tee -a /tmp/IB/installer.log
echo "Installing Apache..."
sudo cp -R /tmp/IB/ARCHIVE/apache2/* /etc/apache2/ 2>&1 | tee -a /tmp/IB/installer.log
sudo cp /tmp/IB/ARCHIVE/index.html /var/www/html/ 2>&1 | tee -a /tmp/IB/installer.log
sudo cp /tmp/IB/ARCHIVE/blacklist /var/www/html/ 2>&1 | tee -a /tmp/IB/installer.log
sleep 1s
sudo chown root:root /tmp/IB/ARCHIVE/mac-vendor.txt
sudo cp /tmp/IB/ARCHIVE/mac-vendor.txt /usr/share/arp-scan/ 2>&1 | tee -a /tmp/IB/installer.log
sleep 1s
sudo mkdir -p /var/www/html/piwall/ 2>&1 | tee -a /tmp/IB/installer.log
sudo mkdir -p /var/www/html/CRYPTO/ 2>&1 | tee -a /tmp/IB/installer.log
sudo mkdir /home/BACKUP 2>&1 | tee -a /tmp/IB/installer.log
sudo chown www-data:www-data -R /home/BACKUP 2>&1 | tee -a /tmp/IB/installer.log
echo "Installing html, cgi, .ssh..." 2>&1 | tee -a /tmp/IB/installer.log
sudo mkdir -p /usr/lib/cgi-bin/piwall/ 2>&1 | tee -a /tmp/IB/installer.log
sudo cp -R /tmp/IB/ARCHIVE/piwall_html/* /var/www/html/piwall/ 2>&1 | tee -a /tmp/IB/installer.log
####sudo mkdir -p /etc/bind/
sudo cp -R /tmp/IB/ARCHIVE/bind/* /etc/bind/ 2>&1 | tee -a /tmp/IB/installer.log

sudo cp -R /tmp/IB/ARCHIVE/piwall_cgi/* /usr/lib/cgi-bin/piwall/ 2>&1 | tee -a /tmp/IB/installer.log
####sudo  mv /usr/lib/cgi-bin/piwall/restore_from_zip.cgi /usr/lib/cgi-bin/ 2>&1 | tee -a /tmp/IB/installer.log
sudo cp -R /tmp/IB/ARCHIVE/css/ /var/www/html/ 2>&1 | tee -a /tmp/IB/installer.log
sudo cp -R /tmp/IB/ARCHIVE/BLOCKED_COUNTRIES/ /opt/IB/ 2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/iptables*  /etc  2>&1 | tee -a /tmp/IB/installer.log
###sudo iptables-restore < /etc/iptables.ipv4.nat  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/hostapd/*  /etc/hostapd  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/dhcp/dhcpd.conf*  /etc/dhcp/  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/dhcp/dhcpd6.conf*  /etc/dhcp/  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/dhcp/dhcpd6.conf*  /etc/dhcp/  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/dhcp/dhclient.conf  /etc/dhcp/  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/radvd.conf*  /etc/  2>&1 | tee -a /tmp/IB/installer.log
sudo chown root:root /etc/radvd.conf
sudo chmod 644 /etc/radvd.conf
sudo cp  /tmp/IB/ARCHIVE/interfaces*  /etc/network/  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/dhcpcd.conf* /etc/  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/rc.local  /etc/  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/wpa_supplicant.conf*  /etc/wpa_supplicant/  2>&1 | tee -a /tmp/IB/installer.log
sudo cp  /tmp/IB/ARCHIVE/sudoers  /etc/  2>&1 | tee -a /tmp/IB/installer.log
sudo htpasswd -cbd /etc/apache2/.htpasswd iblocker test1234
sudo cp  /tmp/IB/ARCHIVE/piwall_html/.htaccess  /var/www/html/piwall  2>&1 | tee -a /tmp/IB/installer.log
sudo sed -i  '/DAEMON_CONF/c\DAEMON_CONF="/etc/hostapd/hostapd.conf"' /etc/init.d/hostapd  2>&1 | tee -a /tmp/IB/installer.log

################ SSH ############################

   echo "delete keys for user (pi and root and /var/www)" 2>&1  | tee -a /tmp/IB/installer.log
sudo rm -rf /root/.ssh 2>&1  | tee -a /tmp/IB/installer.log
sudo rm -rf /home/pi/.ssh/ 2>&1  | tee -a /tmp/IB/installer.log
 sudo rm -rf /var/www/.ssh/ 2>&1  | tee -a /tmp/IB/installer.log
     echo " END delete keys for user (pi and root)" 2>&1 | tee -a /tmp/IB/installer.log
     sudo ssh-keygen -t rsa -q -f "/root/.ssh/id_rsa" -N ""  2>&1 | tee -a /tmp/IB/installer.log &
     wait
     sudo cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys 2>&1  | tee -a /tmp/IB/installer.log
        sudo ssh -o StrictHostKeyChecking=no root@localhost "exit" 2>&1  | tee -a /tmp/IB/installer.log &
        wait
        sudo cp /root/.ssh /var/www -R 2>&1  | tee -a /tmp/IB/installer.log
        sudo cp /root/.ssh /home/pi -R 2>&1  | tee -a /tmp/IB/installer.log
        sudo chown pi:pi /home/pi/.ssh -R 2>&1  | tee -a /tmp/IB/installer.log
        ###     sudo chown lab_muciotcla1:adusers /home/lab_muciotcla1/.ssh -R   | tee -a /tmp/IB/installer.log
        sudo chmod 755  /var/www/.ssh/  2>&1 | tee -a /tmp/IB/installer.log
        sudo chmod 755  /var/www/.ssh/* 2>&1  | tee -a /tmp/IB/installer.log
        sudo chown www-data:www-data /var/www/.ssh -R 2>&1  | tee -a /tmp/IB/installer.log
        sudo chown root:root /var/www/.ssh/* 2>&1  | tee -a /tmp/IB/installer.log
           echo "Restart service, please check ssh root@localhost  works without password /tmp/IB/installer.log" 2>&1  | tee -a /tmp/IB/installer.log
        echo "END SSH_KEYS" 2>&1 | tee -a /tmp/IB/installer.log
################### END SSH ########################################
####sudo sed -i  '/#net.ipv4.ip_forward=1/c\net.ipv4.ip_forward=1' /etc/sysctl.conf 2>&1 | tee -a /tmp/IB/installer.log
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"   2>&1 | tee -a /tmp/IB/installer.log
sudo sh -c "echo 1 > /proc/sys/net/ipv6/conf/all/forwarding"   2>&1 | tee -a /tmp/IB/installer.log
  sudo  sysctl -p /etc/sysctl.conf 2>&1  | tee -a /tmp/IB/installer.log



sudo cp /tmp/IB/ARCHIVE/sysctl.conf /etc/ 2>&1 | tee -a /tmp/IB/installer.log
sudo cp /tmp/IB/ARCHIVE/ipsec.conf-ORI /etc/ 2>&1 | tee -a /tmp/IB/installer.log
sudo cp /tmp/IB/ARCHIVE/isc-dhcp-server  /etc/default/  2>&1 | tee -a /tmp/IB/installer.log 
sudo  chmod 644 /etc/sysctl.conf 2>&1 | tee -a /tmp/IB/installer.log
sudo  chmod 644 /etc/iptables.ipv* 2>&1 | tee -a /tmp/IB/installer.log
sudo cp /tmp/IB/ARCHIVE/hostapd-etc /etc/init.d/hostapd 2>&1 | tee -a /tmp/IB/installer.log
sudo chown www-data:www-data /usr/lib/cgi-bin/piwall/INSERTED/    ########### 
###sudo systemctl unmask hostapd
####sudo systemctl enable hostapd
####sudo systemctl start hostapd
sudo /etc/init.d/apache2 restart 2>&1  | tee -a /tmp/IB/installer.log
sudo /etc/init.d/hostapd restart 2>&1  | tee -a /tmp/IB/installer.log
####sudo /etc/init.d/dhcpcd restart 2>&1  | tee -a /tmp/IB/installer.log
echo "Updating iBlocker"  2>&1 | tee -a /tmp/IB/installer.log

########## sudo ifconfig wlan0 down   sudo iwconfig wlan0 mode Ad-Hoc
echo "#### Install MotionEYE on iBlocker #####"
sudo apt-get install -y ffmpeg libmariadb3 libpq5 libmicrohttpd12 2>&1 | tee -a /tmp/IB/installer.log
sudo wget https://github.com/Motion-Project/motion/releases/download/release-4.2.2/pi_buster_motion_4.2.2-1_armhf.deb  2>&1 | tee -a /tmp/IB/installer.log
sudo  dpkg -i pi_buster_motion_4.2.2-1_armhf.deb 2>&1 | tee -a /tmp/IB/installer.log
sudo apt-get update 2>&1 | tee -a /tmp/IB/installer.log
sudo apt-get install -y python-pip python-dev libssl-dev libcurl4-openssl-dev libjpeg-dev libz-dev 2>&1 | tee -a /tmp/IB/installer.log
sudo pip install motioneye 2>&1 | tee -a /tmp/IB/installer.log
sudo  mkdir -p /etc/motioneye 2>&1 | tee -a /tmp/IB/installer.log
sudo  cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf 2>&1 | tee -a /tmp/IB/installer.log
sudo  mkdir -p /var/lib/motioneye  2>&1 | tee -a /tmp/IB/installer.log
sudo cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service 2>&1 | tee -a /tmp/IB/installer.log
sudo systemctl daemon-reload 2>&1 | tee -a /tmp/IB/installer.log
sudo systemctl enable motioneye 2>&1 | tee -a /tmp/IB/installer.log
sudo systemctl start motioneye 2>&1 | tee -a /tmp/IB/installer.log
echo "#### END Install MotionEYE on iBlocker #####"

 sudo systemctl disable dnsmasq 2>&1  | tee -a /tmp/IB/installer.log
 sudo systemctl stop dhcpcd 2>&1  | tee -a /tmp/IB/installer.log
 sudo systemctl disable dhcpcd 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl unmask hostapd 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl enable hostapd 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl start hostapd  2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl enable radvd 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl start radvd 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl enable bind9 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl start bind9 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl enable isc-dhcp-server 2>&1  | tee -a /tmp/IB/installer.log
sudo systemctl start isc-dhcp-server  2>&1  | tee -a /tmp/IB/installer.log
##sudo /usr/sbin/dhcpd -6 -q -cf /etc/dhcp/dhcpd6.conf
echo "################ SAVE NETFILTER (iptables) ###################"  2>&1 | tee -a /tmp/IB/installer.log
sudo iptables-restore < /etc/iptables.ipv4.nat  2>&1 | tee -a /tmp/IB/installer.log
sudo iptables-restore < /etc/iptables.ipv6.nat  2>&1 | tee -a /tmp/IB/installer.log
sudo cp /etc/iptables.ipv4.nat /etc/iptables/rules.v4
sudo cp /etc/iptables.ipv6.nat /etc/iptables/rules.v6
#sudo /sbin/iptables-save > /etc/iptables/rules.v4
#sudo /sbin/ip6tables-save > /etc/iptables/rules.v6
sudo netfilter-persistent save

sudo cp /etc/bind/resolv.conf /etc 2>&1 | tee -a /tmp/IB/installer.log
sudo /etc/init.d/ssh restart  2>&1 | tee -a /tmp/IB/installer.log
###sudo /etc/init.d/bind9 restart 2>&1  | tee -a /tmp/IB/installer.log    #### VASI ISSUE - to comment or not????
###sudo systemctl enable dnsmasq 2>&1  | tee -a /tmp/IB/installer.log
####sudo systemctl start dnsmasq 2>&1  | tee -a /tmp/IB/installer.log
################# END install AP #######################

echo "################ APACHE a2enmod START ###################"  2>&1 | tee -a /tmp/IB/installer.log
sudo a2enmod cgi -q 2>&1  | tee -a /tmp/IB/installer.log
sleep 1s
sudo a2enmod rewrite -q | tee -a /tmp/IB/installer.log
sleep 1s
sudo a2dismod -f deflate  | tee -a /tmp/IB/installer.log
sleep 1s
sudo service apache2 restart 2>&1  | tee -a /tmp/IB/installer.log
 echo "################ APACHE a2enmod STOP ###################"  2>&1 | tee -a /tmp/IB/installer.logc
 

sudo apt autoremove -y 2>&1 | tee -a /tmp/IB/installer.log
sudo cp /tmp/IB/installer.log /home/pi/ 2>&1 | tee -a /tmp/IB/installer.log
sudo rm /tmp/IB -R
sudo reboot
