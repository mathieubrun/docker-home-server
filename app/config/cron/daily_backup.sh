#!/usr/bin/env bash

set -eu

export AWS_SHARED_CREDENTIALS_FILE=/credentials/aws_credentials

DATA_FOLDER=/data
RCLONE_CONFIG=/credentials/rclone.conf
RCLONE_ARGS="--s3-no-check-bucket --update --use-server-modtime --fast-list --log-level INFO"

echo "==== Starting backup iot config to s3 ===="
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER/nodered/flows.json aws-backups-crypt:nodered
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER/nodered/flows_cred.json aws-backups-crypt:nodered
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER/zigbee2mqtt/configuration.yaml aws-backups-crypt:zigbee2mqtt
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER/zigbee2mqtt/database.db aws-backups-crypt:zigbee2mqtt
rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync $DATA_FOLDER/grafana/grafana.db aws-backups-crypt:grafana
echo "==== Starting backup iot config to s3 ===="

# echo "==== Starting google photos backup ===="
# rclone --config "$RCLONE_CONFIG" --log-level INFO copy gphotos-perso:media/by-month nextcloud:photos/gphotos
# echo "==== Done google photos backup ===="

echo "==== Starting nextcloud backup ===="

# NEXTCLOUD_DB_BACKUP_FILE=$DATA_FOLDER/nextcloud_backup_$(date +"%Y%m%d_%H%M").sql.gz
# echo "==== Starting backup to s3 : database"
# pg_dump nextcloud -U nextcloud | gzip -9 > "$NEXTCLOUD_DB_BACKUP_FILE"
# rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync "$NEXTCLOUD_DB_BACKUP_FILE" aws-backups-crypt:nextcloud/database
# rm "$NEXTCLOUD_DB_BACKUP_FILE"
# echo "==== Done backup to s3 : database"

for FOLDERNAME in config data themes;
do
  echo "==== Starting backup to s3 : $FOLDERNAME ===="
  rclone --config "$RCLONE_CONFIG" $RCLONE_ARGS sync --exclude-from /config/rclone_excludes "$DATA_FOLDER/nextcloud/$FOLDERNAME" aws-backups-crypt:nextcloud/files/$FOLDERNAME
  echo "==== Done backup to s3 : $FOLDERNAME ===="
done

echo "==== Done nextcloud backup ===="

echo "==== All done ===="
