#!/usr/bin/env bash

set -eu

CONFIG_FOLDER=/home/mathieu/services/config
DOCKER_FOLDER=/home/mathieu/services/iot

export AWS_SHARED_CREDENTIALS_FILE=$CONFIG_FOLDER/aws_credentials
RCLONE_CONFIG=$CONFIG_FOLDER/rclone.conf

DATA_FOLDER=$DOCKER_FOLDER/data
RCLONE_BACKUP_NEXTCLOUD_ROOT=$DATA_FOLDER/nextcloud
RCLONE_BACKUP_NEXTCLOUD_FOLDERS=(config data themes)

NEXTCLOUD_DB_BACKUP_FILE=$DATA_FOLDER/nextcloud_backup.sql.gz

echo "==== Starting google photos backup ===="
rclone --config "$RCLONE_CONFIG" --log-level INFO copy gphotos-perso:media/by-month nextcloud:photos/gphotos
echo "==== Done google photos backup ===="

echo "==== Starting nextcloud backup ===="

echo "==== Starting backup to s3 : database"
docker-compose -f $DOCKER_FOLDER/docker-compose.yaml exec -T db_postgres_nextcloud bash -c 'PGPASSWORD="$POSTGRES_PASSWORD" pg_dump nextcloud -U nextcloud' | gzip -9 > "$NEXTCLOUD_DB_BACKUP_FILE"
rclone --config "$RCLONE_CONFIG" --s3-no-check-bucket --update --use-server-modtime --fast-list --log-level INFO sync "$NEXTCLOUD_DB_BACKUP_FILE" aws-backups-crypt:nextcloud/database
rm "$NEXTCLOUD_DB_BACKUP_FILE"
echo "==== Done backup to s3 : database"

for FOLDERNAME in ${RCLONE_BACKUP_NEXTCLOUD_FOLDERS[@]}
do
  echo "==== Starting backup to s3 : $FOLDERNAME ===="
  rclone --config "$RCLONE_CONFIG" --s3-no-check-bucket --update --use-server-modtime --fast-list --log-level INFO sync --exclude '.comments/*' --exclude 'appdata_*/preview/**' "$RCLONE_BACKUP_NEXTCLOUD_ROOT/$FOLDERNAME" aws-backups-crypt:nextcloud/files/$FOLDERNAME
  echo "==== Done backup to s3 : $FOLDERNAME ===="
done

echo "==== Done nextcloud backup ===="

echo "==== Starting backup iot config to s3 ===="
rclone --config "$RCLONE_CONFIG" --s3-no-check-bucket --update --use-server-modtime --fast-list --log-level INFO sync $DATA_FOLDER/nodered/flows.json aws-backups-crypt:nodered
rclone --config "$RCLONE_CONFIG" --s3-no-check-bucket --update --use-server-modtime --fast-list --log-level INFO sync $DATA_FOLDER/nodered/flows_cred.json aws-backups-crypt:nodered
rclone --config "$RCLONE_CONFIG" --s3-no-check-bucket --update --use-server-modtime --fast-list --log-level INFO sync $DATA_FOLDER/zigbee2mqtt/configuration.yaml aws-backups-crypt:zigbee2mqtt
rclone --config "$RCLONE_CONFIG" --s3-no-check-bucket --update --use-server-modtime --fast-list --log-level INFO sync $DATA_FOLDER/zigbee2mqtt/database.db aws-backups-crypt:zigbee2mqtt
echo "==== Starting backup iot config to s3 ===="

echo "==== All done ===="
