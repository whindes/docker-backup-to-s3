#!/bin/sh

set -e

: ${ACCESS_KEY:?"ACCESS_KEY env variable is required"}
: ${SECRET_KEY:?"SECRET_KEY env variable is required"}
: ${S3_PATH:?"S3_PATH env variable is required"}
DATA_PATH=${DATA_PATH:-/data/}
CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}

echo "access_key=$ACCESS_KEY" >> /root/.s3cfg
echo "secret_key=$SECRET_KEY" >> /root/.s3cfg

if [[ "$1" == 'no-cron' ]]; then
    exec /sync.sh
elif [[ "$1" == 'get' ]]; then
    exec /get.sh
elif [[ "$1" == 'delete' ]]; then
    exec /usr/bin/s3cmd del -r "$S3_PATH"
else #CRON
    sed -i "s|#PARAMS=|export PARAMS=$PARAMS|g" /sync.sh
    sed -i "s|#DATA_PATH=|export DATA_PATH=$DATA_PATH|g" /sync.sh
    sed -i "s|#S3_PATH=|export S3_PATH=$S3_PATH|g" /sync.sh
    LOGFIFO='/var/log/cron/cron.log'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    echo -e "$CRON_SCHEDULE /sync.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    openrc default && tail -f "$LOGFIFO"
fi