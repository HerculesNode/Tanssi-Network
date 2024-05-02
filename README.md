# Tanssi Network Kurulum. v0.6.1  / 2 farklı kurulum var SystemD ve Docker 

# Systemd Ubuntu 22.04 olması gerekiyor
# Docker ubuntu 20.04 ile çalışıyor

- Node kurduktan sonra Form doldurun ve Discord rolü alın.

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


Bu kurulum Systemd ile olmaktadır . 2. kurulum yapmak isterseniz aşağıda bulunan Docker kurulumu yapabilirsiniz. 

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




## Docker kurulum

```shell
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

```shell
docker pull moondancelabs/tanssi
```

```shell
mkdir /var/lib/dancebox
```

```shell
sudo chown -R $(id -u):$(id -g) /var/lib/dancebox
```

```shell
mkdir /var/lib/dancebox
```

Aşağıdaki alanlardaki ISMINIZ bölümüne isminizi yazın ve kodu direk çalıştırın

```shell
docker run --network="host" -v "/var/lib/dancebox:/data" \
-u $(id -u ${USER}):$(id -g ${USER}) \
moondancelabs/tanssi \
--chain=dancebox \
--name=ISMINIZ \
--sync=warp \
--base-path=/data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \
-- \
--name=ISMINIZ \
--base-path=/data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
-- \
--chain=westend_moonbase_relay_testnet \
--name=ISMINIZ \
--sync=fast \
--base-path=/data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb
```

## log için

```shell
docker logs -f funny_bhabha
```

## Key için 

```shell
curl http://127.0.0.1:9944 -H \
"Content-Type:application/json;charset=utf-8" -d \
  '{
    "jsonrpc":"2.0",
    "id":1,
    "method":"author_rotateKeys",
    "params": []
  }'
```

![image](https://github.com/HerculesNode/Tanssi-Network/assets/101635385/d72d84e4-0ea2-454d-afc3-21d3a25f4bd1)

