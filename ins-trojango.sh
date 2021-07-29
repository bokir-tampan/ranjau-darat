#!/bin/bash
# Trojan Go Auto Setup 
# =========================

apt update -y
apt upgrade -y
apt install wget -y
apt install screen -y
apt install curl -y
apt install zip
# Domain 
domain=$(cat /etc/v2ray/domain)

# Uuid Service
uuid=$(cat /proc/sys/kernel/random/uuid)

# Trojan Go Akun 
mkdir -p /etc/trojan-go/
touch /etc/trojan-go/akun.conf

# Installing Trojan Go
mkdir -p /etc/trojan-go/
chmod 755 /etc/trojan-go/
touch /etc/trojan-go/trojan-go.pid
wget -O /usr/local/bin/trojan-go https://github.com/bokir-tampan/ranjau-darate/raw/main/trojan-go
wget -O /usr/local/bin/geoip.dat https://raw.githubusercontent.com/bokir-tampan/ranjau-darate/main/geoip.dat
wget -O /usr/local/bin/geosite.dat https://raw.githubusercontent.com/bokir-tampan/ranjau-darate/main/geosite.dat
chmod +x /usr/local/bin/trojan-go

# Service
cat > /etc/systemd/system/trojan-go.service << END
[Unit]
Description=Trojan-Go - An unidentifiable mechanism that helps you bypass GFW
Documentation=https://p4gefau1t.github.io/trojan-go/
After=network.target nss-lookup.target

[Service]
User=root
NoNewPrivileges=true
ExecStart=/usr/local/bin/trojan-go -config /etc/trojan-go/config.json
Restart=on-failure
RestartSec=10s
LimitNOFILE=infinity

[Install]
WantedBy=multi-user.target
END

# Config
cat > /etc/trojan-go/config.json << END
{
    "run_type": "server",
    "local_addr": "0.0.0.0",
    "local_port": 2096, # Port Untuk Trojan-Go
    "remote_addr": "127.0.0.1",
    "remote_port": 81, # Port Nginx / Apache ( Wajib Ada )
    "password": [
        "BokirTampan" # Semua Password Client
    ],
    "ssl": {
        "cert": "/etc/v2ray/cert.crt", # Path Certificate
        "key": "/etc/v2ray/cert.key", # Path Certificate Key
        "sni": "$domain" # Domain Name ( Harus Sama Dengan Cert )
    },
    "router": {
        "enabled": true,
        "block": [
            "geoip:private"
        ],
        "geoip": "/usr/local/bin/geoip.dat",
        "geosite": "/usr/local/bin/geosite.dat"
    }
}
END
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 2096 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 2096 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Starting
systemctl daemon-reload
systemctl enable trojan-go
systemctl start trojan-go
