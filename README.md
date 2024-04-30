# Tanssi Network Kurulum. v0.6.1  - Ubuntu 22.04 olması gerekiyor aksi taktirde çalışmaz !

## Linkler
 * [Hercules Telegram](https://t.me/HerculesNode)
 * [Hercules Twitter](https://twitter.com/Herculesnode)

## Form
 * [Form](https://www.tanssi.network/testnet-campaign/block-producers-waitlist)
 * [Explorer](https://polkadot.js.org/apps/?rpc=wss://fraa-dancebox-rpc.a.dancebox.tanssi.network#/accounts)
 * [DanceBox Telemetry](https://telemetry.polkadot.io/#stats/0x27aafd88e5921f5d5c6aebcd728dacbbf5c2a37f63e2eda301f8e0def01c43ea)
 - Telemetry üzerinde node isminizi görmeniz lazım kurulum sonrası

## Sistem özellikleri

| 2-4 Gb Ram  | Ubuntu 22.04 |  200+ Gb SSD | 
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
sudo mkdir /root/tanssi-data/
```
```shell
cd /root/tanssi-data/
```

```shell
mv /root/tanssi-node /root/tanssi-data
```

## Servis oluşturalım

- 3 YERİ DEĞİŞTİRECEKSİNİZ. HEPSİNE AYNI İSMİ YAZIN BEN HERCULESNODE YAZDIM.

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


## Node key alalım ( burada bulunan SS58 ADRES ÇIKTISINI FORMA YAZACAĞIZ )  Bu çıktıları kaydedin !

```shell
./tanssi-node key generate -w 24
```

![image](https://github.com/HerculesNode/Tansi-Network/assets/101635385/800386a4-157c-4b46-8aa6-9f732a773c2d)

<br>
- Form yazılacak yer:

![image](https://github.com/HerculesNode/Tansi-Network/assets/101635385/6c01baa1-dcdc-4241-aa06-3df8d0c8911f)



## Polkadot cüzdanı injected etme

- bu adrese gidin : https://polkadot.js.org/apps/?rpc=wss://dancebox.tanssi-api.network#/chainstate

- Cüzdanınızı seçin ( daha önce kelimeleri vermişti onu aktarın polkadot cüzdana
- Session seçin
- setKeys (keys, Prof ) seçin
- Public key yazın ( daha önce Node key alalım ./tanssi-node key generate -w 24 bu kodla almıştık orada yazan public key   ) 
- proof: Bytes : 0x yazın
- Altta sağda Submit Transaction basın

![image](https://github.com/HerculesNode/Tanssi-Network/assets/101635385/595f6510-1e33-423c-9d74-3b5135b56e08)

- işlem sonrası cüzdanınız böyle görünecek.

![image](https://github.com/HerculesNode/Tanssi-Network/assets/101635385/825cb7a3-59cb-4a0b-91d4-ebfbfaca67bd)



