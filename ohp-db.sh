#!/bin/bash
# Program: OHPServer ohp-dropbear

export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

# installing ohpserver
if [[ -e /usr/bin/ohpserver  ]]; then
echo -e "ohpserver already install"
sleep 3;clear
else
echo -e "installing ohpserver"
sleep 3;clear
wget https://github.com/lfasmpao/open-http-puncher/releases/download/0.1/ohpserver-linux32.zip
unzip ohpserver-linux32.zip
rm *.zip
mv ohpserver /usr/bin/
chmod +x /usr/bin/ohpserver
fi

# adding ohp-dropbear for ohpserver
if [[ -e /usr/bin/ohp-dropbear  ]]; then
echo -e "ohp-dropbear for ohpserver exist but will be update"
sleep 3;clear
rm /usr/bin/ohp-dropbear
cat> /usr/bin/ohp-dropbear << END
#!/bin/bash
screen -dmS dropbear ohpserver -port 50001 -proxy $MYIP:80443 -tunnel $MYIP:143
screen -dmS openvpn ohpserver -port 50000 -proxy $MYIP:80443 -tunnel $MYIP:1194
#screen -dmS vless ohpserver -port 8058 -proxy $MYIP:80443 -tunnel $MYIP:880
END
chmod +x /usr/bin/ohp-dropbear
else
echo -e "adding ohp-dropbear for ohpserver"
sleep 3;clear
cat> /usr/bin/ohp-dropbear << END
#!/bin/bash
screen -dmS dropbear ohpserver -port 50001 -proxy $MYIP:80443 -tunnel $MYIP:143
screen -dmS openvpn ohpserver -port 50000 -proxy $MYIP:80443 -tunnel $MYIP:1194
#screen -dmS vless ohpserver -port 8058 -proxy $MYIP:80443 -tunnel $MYIP:880
END
chmod +x /usr/bin/ohp-dropbear
fi

# adding ohp-dropbear service for running
if [[ -e /etc/systemd/system/ohp-dropbear.service  ]]; then
echo -e "ohp-dropbear service already adding"
sleep 3;clear
else
echo -e "adding ohp-dropbear service for running"
sleep 3;clear
cat> /etc/systemd/system/ohp-dropbear.service << END
[Unit]
Description=OHP ohp-dropbear
[Service]
Type=forking
ExecStart=/usr/bin/ohp-dropbear
[Install]
WantedBy=multi-user.target
END
systemctl daemon-reload
service ohp-dropbear start
systemctl enable ohp-dropbear
fi

if [[ -e /root/log-ohp.txt  ]]; then
rm /root/log-ohp.txt
echo -e "Installation has been completed!!"
echo ""
echo ""
echo "DROPBEAR : 8170" | tee -a log-ohp.txt
echo "Openvpn Non : 50000" | tee -a log-ohp.txt
echo ""
echo ""
read -n 1 -r -s -p $'Press any key to reboot...\n';reboot
else
echo -e "Installation has been completed!!"
echo ""
echo ""
echo "DROPBEAR : 50001" | tee -a log-ohp.txt
echo "OPENVPN : 50000" | tee -a log-ohp.txt
echo ""
fi
