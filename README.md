# Home Server

## Providing :

- Monitoring
  - InfluxDB : metrics persistence
  - Grafana : dashboards
  - Loki : logs collection
  - Telegraf : metrics agent
  - Promtail : logs agent

- Network
  - pi-hole
  - unbound
  - cups

## Getting started

Create folders requiring special permissions

```` sh
mkdir -p data/loki
sudo chown -R 1000:1000 data/loki
mkdir -p data/grafana
sudo chown -R 1000:1000 data/grafana
````

For collecting logs of docker containers, the easiest way is to change the default logging driver to `journald`, to aggregate them into systemd journal. From there they will be collected by promtail.

```` json
{
    "log-driver": "journald"
}
````

Then restart the docker service using `sudo systemctl restart docker.service`

## Todo

- more docs
- backups
