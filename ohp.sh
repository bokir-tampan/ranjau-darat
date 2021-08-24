#!/bin/bash

wget https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip
unzip ohpserver-linux32.zip
rm ohpserver-linux32.zip
mv ohpserver /usr/local/bin/
chmod +x /usr/local/bin/ohpserver

cat > /etc/systemd/system/dropbear-ohp.service << END
[Unit]
Description=DROPBEAR OHP Redirection Service
Documentation=https://t.me/bokirtampan
Documentation=https://t.me/CustomVPN
Documentation=https://t.me/friendly_teams
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8181 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:143
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target

END

cat > /etc/systemd/system/ovpn-ohp.service << END

[Unit]
Description=OpenVPN OHP Redirection Service
Documentation=https://t.me/bokirtampan
Documentation=https://t.me/CustomVPN
Documentation=https://t.me/friendly_teams
After=network.target nss-lookup.target

[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/ohpserver -port 8282 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:1194
Restart=on-failure
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target

END

systemctl enable dropbear-ohp.service 
systemctl enable ovpn-ohp.service 
systemctl start dropbear-ohp.service 
systemctl start ovpn-ohp.service 
