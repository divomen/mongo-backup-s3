#!/bin/bash

set -e

: ${MONGO_HOST:?}
: ${MONGO_DB:?}
: ${MONGO_USER:?}
: ${MONGO_PASSWORD:?}
: ${S3_BUCKET:?}
: ${AWS_ACCESS_KEY_ID:?}
: ${AWS_SECRET_ACCESS_KEY:?}
: ${DATE_FORMAT:?}
: ${FILE_PREFIX:?}

FILE_NAME=$(date -u +${DATE_FORMAT}).gz

echo "[$(date)] Starting backup..."

mongodump --username=${MONGO_USER} --password=${MONGO_PASSWORD} --host=${MONGO_HOST} --db=${MONGO_DB} --gzip --archive=${FILE_NAME}

echo "[$(date)] Uploading to S3..."

aws s3api put-object --bucket ${S3_BUCKET} --key ${FILE_PREFIX}${FILE_NAME} --body ${FILE_NAME}

echo "[$(date)] Removing backup file..."

rm -f ${FILE_NAME}

echo "[$(date)] Done!"
