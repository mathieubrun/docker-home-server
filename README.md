# Home Server

## Providing :

- Network
  - pi-hole
  - unbound
  - cups

- Monitoring
  - InfluxDB : metrics persistence
  - Grafana : dashboards
  - Loki : logs collection
  - Telegraf : metrics agent
  - Promtail : logs agent

- IOT automation
  - Mosquitto : MQTT broker
  - Zigbee2mqtt : communication with devices
  - Nodered : automation
  - Telegraf : MQTT to InfluxDB bridge

- Collaboration
  - Nextcloud

## Getting started

Create folders requiring special permissions

```` sh
mkdir -p data/loki
sudo chown -R 1000:1000 data/loki
mkdir -p data/grafana
sudo chown -R 1000:1000 data/grafana
````

For collecting logs of docker containers, the easiest way is to change the default loggin driver to `journald`, to aggregate them into systemd journal. From there they will be collected by promtail.

```` json
{
    "log-driver": "journald"
}
````

Then restart the docker service using `sudo systemctl restart docker.service`

## Todo

- more docs
- backups
