#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
# Getting
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

BURIQ () {
    curl -sS https://raw.githubusercontent.com/bokir-tampan/test/main/ip > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f /root/tmp
}

MYIP=$(curl -sS ipinfo.io/ip)
Name=$(curl -sS https://raw.githubusercontent.com/bokir-tampan/test/main/ip | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)

Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}

PERMISSION () {
    MYIP=$(curl -sS ipinfo.io/ip)
    IZIN=$(curl -sS https://raw.githubusercontent.com/bokir-tampan/test/main/ip | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
red='\e[1;31m'
green='\e[1;32m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
PERMISSION

if [ -f /home/needupdate ]; then
red "Your script need to update first !"
exit 0
elif [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
red "Permission Denied!"
exit 0
fi
clear
echo -e "\e[36m${asu}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
asu=$(tput bold)
ISP=$(curl -s ip-api.com| grep isp | cut -d ':' -f 2 | cut -d '"' -f2 )
CITY=$(curl -s ip-api.com| grep city | cut -d ':' -f 2 | cut -d '"' -f2 )
WKT=$(curl -s ip-api.com| grep timezone | cut -d ':' -f 2 | cut -d '"' -f2 )
IPVPS=$(wget -qO- ifconfig.me/ip)
cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
tram=$( free -m | awk 'NR==2 {print $2}' )
swap=$( free -m | awk 'NR==4 {print $2}' )
up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
echo -e "\e[032;1mNumber Of Cores:\e[0m $cores"
echo -e "\e[032;1mCPU Frequency:\e[0m $freq MHz"
echo -e "\e[032;1mTotal Amount Of RAM:\e[0m $tram MB"
echo -e "\e[032;1mSystem Uptime:\e[0m $up"
echo -e "\e[032;1mIsp Name:\e[0m $ISP"
echo -e "\e[032;1mCity:\e[0m $CITY"
echo -e "\e[032;1mTime:\e[0m $WKT"
echo -e "\e[033;1mIPVPS:\e[0m  $IPVPS"
echo -e "\e[36m${asu}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m           ${asu} V2RAY - MENU            \E[0m"
echo -e "\e[36m${asu}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " [\e[36m•01\e[0m] Menu SSH"
echo -e " [\e[36m•02\e[0m] Menu WIREGUARD "
echo -e " [\e[36m•03\e[0m] Menu SHADOWSOCKS/R"
echo -e " [\e[36m•04\e[0m] Menu PPTP/L2TP"
echo -e " [\e[36m•05\e[0m] Menu V2RAY"
echo -e " [\e[36m•06\e[0m] Menu VLESS"
echo -e " [\e[36m•07\e[0m] Menu TROJAN"
echo -e " [\e[36m•08\e[0m] Menu TROJAN-GO"
echo -e "\e[36m${asu}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m         ${asu} SYSTEM SETTINGS          \E[0m"
echo -e "\e[36m${asu}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " [\e[36m•09\e[0m] Add Subdomain Host For VPS"
echo -e " [\e[36m•10\e[0m] Change Port All Account"
echo -e " [\e[36m•11\e[0m] Renew Certificate V2RAY"
echo -e " [\e[36m•12\e[0m] Auto Backup Data VPS"
echo -e " [\e[36m•13\e[0m] Backup VPS"
echo -e " [\e[36m•14\e[0m] Restore Data VPS"
echo -e " [\e[36m•15\e[0m] Webmin Menu"
echo -e " [\e[36m•16\e[0m] Limit Bandwith Speed Server"
echo -e " [\e[36m•17\e[0m] Speedtest VPS"
echo -e " [\e[36m•18\e[0m] Clear Log"
echo -e " [\e[36m•19\e[0m] Restart All Service"
echo -e " [\e[36m•20\e[0m] Change Banner"
echo -e " [\e[36m•21\e[0m] Reboot Server"
echo -e " [\e[36m•22\e[0m] Kernel Update"
echo -e " [\e[36m•23\e[0m] Update Script"
echo -e " [\e[36m•69\e[0m] Install Xolpanel Bot Free"
echo -e ""
echo -e " [\e[31m•0\e[0m] \e[31m${asu}BACK TO MENU\033[0m"
echo -e "\e[36m${asu}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "\E[0;41;36m ${asu}  Press x or [ Ctrl+C ] • To-Exit \e[0m"
echo -e "\e[36m${asu}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e ""
read -p " Select menu : " opt
echo -e ""
case $opt in
1) clear ; ssh ;;
2) clear ; wgr;;
3) clear ; ssssr;;
4) clear ; l2tp ;;
5) clear ; v2raay;;
6) clear ; vleess;;
7) clear ; trojaan;;
8) clear ; menu-trojanws;;
9) clear ; add-host ;;
10) clear ; change-port ;;
11) clear ; certv2ray ;;
12) clear ; autobackup ;;
13) clear ; backup ;;
14) clear ; restore ;;
15) clear ; webmin ;;
16) clear ; limit-speed ;;
17) clear ; speedtest ;;
18) clear ; clear-log ;;
19) clear ; restart ;;
20) clear ; nano /etc/issue.net ; exit  ;;
22) clear ; reboot ;;
22) clear ; kernel-update ;;
23) clear ; wget https://raw.githubusercontent.com/bokir-tampan/ranjau-darate/main/update.sh;chmod +x update.sh;./update.sh;rm -f update.sh ;;
69) clear ; wget https://raw.githubusercontent.com/bokir-tampan/ranjau-darate/main/xolpanel-free.sh;bash xolpanel-free.sh ;;

0) clear ; menu ;;
x) exit ;;
*) echo -e "" ; echo "Press any key to back on menu" ; sleep 1 ; menu ;;
esac

