#!/usr/bin/env bash

set -eu

export AWS_SHARED_CREDENTIALS_FILE=/credentials/aws_credentials

DATA_FOLDER_CLEAR=/data/clear
DATA_FOLDER_CRYPT=/data/crypt
RCLONE_CONFIG=/credentials/rclone.conf
RCLONE_ARGS="--s3-no-check-bucket --update --use-server-modtime --fast-list --log-level INFO"

echo "= Starting backups"

echo "== Starting backup iot config to s3"
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER_CLEAR/nodered/flows.json aws-backups-crypt:nodered
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER_CLEAR/nodered/flows_cred.json aws-backups-crypt:nodered
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER_CLEAR/zigbee2mqtt/configuration.yaml aws-backups-crypt:zigbee2mqtt
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER_CLEAR/zigbee2mqtt/database.db aws-backups-crypt:zigbee2mqtt
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER_CLEAR/grafana/grafana.db aws-backups-crypt:grafana
echo "== Done backup iot config to s3"

# echo "==== Starting google photos backup"
# rclone --config "$RCLONE_CONFIG" --log-level INFO copy gphotos-perso:media/by-month nextcloud:photos/gphotos
# echo "==== Done google photos backup"

echo "== Starting nextcloud backup"

echo "=== Starting backup to s3 : nextcloud database"
NEXTCLOUD_DB_BACKUP_FILE=$DATA_FOLDER_CRYPT/nextcloud_backup.sql.gz
pg_dump postgres://${NEXTCLOUD_DB_USER}:${NEXTCLOUD_DB_PASSWORD}@${NEXTCLOUD_DB_HOST}:5432/${NEXTCLOUD_DB_DATABASE} | gzip -9 > "$NEXTCLOUD_DB_BACKUP_FILE"
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync "$NEXTCLOUD_DB_BACKUP_FILE" aws-backups-crypt:nextcloud/database
rm "$NEXTCLOUD_DB_BACKUP_FILE"
echo "=== Done backup to s3 : nextcloud database"

for FOLDERNAME in config data themes;
do
  echo "=== Starting backup to s3 : $FOLDERNAME"
  rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync --exclude-from /config/rclone_excludes "$DATA_FOLDER_CRYPT/nextcloud/$FOLDERNAME" aws-backups-crypt:nextcloud/files/$FOLDERNAME
  echo "=== Done backup to s3 : $FOLDERNAME"
done

echo "== Done nextcloud backup"

echo "== Starting firefly backup"
echo "=== Starting backup to s3 : firefly database"
FIREFLY_DB_BACKUP_FILE=$DATA_FOLDER_CRYPT/firefly_backup.sql.gz
pg_dump postgres://${FIREFLY_DB_USER}:${FIREFLY_DB_PASSWORD}@${FIREFLY_DB_HOST}:5432/${FIREFLY_DB_DATABASE} | gzip -9 > "$FIREFLY_DB_BACKUP_FILE"
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync "$FIREFLY_DB_BACKUP_FILE" aws-backups-crypt:firefly/database
rm "$FIREFLY_DB_BACKUP_FILE"
echo "=== Done backup to s3 : firefly database"

echo "== Done firefly backup"

echo "= All done"
