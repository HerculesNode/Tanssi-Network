# Tansi Network Kurulum.

## Linkler
 * [Hercules Telegram](https://t.me/HerculesNode)
 * [Hercules Twitter](https://twitter.com/Herculesnode)

## Form
 * [Form](www.tanssi.network/block-producer-form)

## Sistem özellikleri

| 2-4 Gb Ram  | Ubuntu 22.04 |  2000 Gb SSD | 
| ----------------- | ----------------- | ----------------- |


## Sistem Güncelleme ve kütüphaneler
```shell
sudo apt update && sudo apt upgrade -y
```

## Repo indirelim
```shell
wget https://github.com/moondance-labs/tanssi/releases/download/v0.6.1/tanssi-node 
```
```shell
chmod +x ./tanssi-node
```
```shell
cd /root/tanssi-data/
```

```shell
mv /root/tanssi-node /root/tanssi-data
```

## Servis oluşturalım

- 3 YERİ DEĞİŞTİRECEKSİNİZ.

1 - NODE-İSMİNİZİ-YAZIN
2 - BLOCK-PRODUCER-İSMİNİZİ-YAZIN
3 - RELAY-İSMİNİZİ-YAZIN

```shell
sudo tee /etc/systemd/system/tanssid.service > /dev/null <<'EOF'
[Unit]
Description="Tanssi systemd service"
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=on-failure
RestartSec=10
User=root
SyslogIdentifier=tanssi
SyslogFacility=local7
KillSignal=SIGHUP
ExecStart=/root/tanssi-data/tanssi-node \
--chain=dancebox \
--name=NODE-İSMİNİZİ-YAZIN \
--sync=warp \
--base-path=/root/tanssi-data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--database paritydb \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' 
-- \
--name=BLOCK-PRODUCER-İSMİNİZİ-YAZIN \
--base-path=/root/tanssi-data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' 
-- \
--chain=westend_moonbase_relay_testnet \
--name=RELAY-İSMİNİZİ-YAZIN \
--sync=fast \
--base-path=/root/tanssi-data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 
--database paritydb \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' 

[Install]
WantedBy=multi-user.target
EOF
```

## Sistemi Başlatalım

```shell
sudo systemctl daemon-reload
sudo systemctl enable tanssid.service
sudo systemctl restart tanssid.service
```

- Aşağıdaki gibi çıktı almalısınız.

![image](https://github.com/HerculesNode/Tansi-Network/assets/101635385/d2921ea1-b5da-426a-8266-8457680cd90c)

Loglara bakmak için.

```shell
journalctl -u tanssid -fo cat
```


## Node key alalım ( burada bulunan SS58 ADRES ÇIKTISINI FORMA YAZACAĞIZ )

```shell
./tanssi-node key generate -w 24
```

![image](https://github.com/HerculesNode/Tansi-Network/assets/101635385/800386a4-157c-4b46-8aa6-9f732a773c2d)

<br>
- Form yazılacak yer:

![image](https://github.com/HerculesNode/Tansi-Network/assets/101635385/6c01baa1-dcdc-4241-aa06-3df8d0c8911f)



## Node key alalım ( burada bulunan SS58 ADRES ÇIKTISINI FORMA YAZACAĞIZ )

```shell
./tanssi-node key generate -w 24
```
