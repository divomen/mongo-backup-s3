#!/bin/bash

set -e

: ${MONGO_HOST:?}
: ${MONGO_DB:?}
: ${MONGO_USER:?}
: ${MONGO_PASSWORD:?}
: ${S3_BUCKET:?}
: ${S3_GRANTS:?}
: ${AWS_ACCESS_KEY_ID:?}
: ${AWS_SECRET_ACCESS_KEY:?}
: ${DATE_FORMAT:?}
: ${FILE_PREFIX:?}

FILE_NAME=$(date -u +${DATE_FORMAT}).gz

echo "[$(date)] Starting backup..."

mongodump --username=${MONGO_USER} --password=${MONGO_PASSWORD} --host=${MONGO_HOST} --db=${MONGO_DB} --gzip --archive=${FILE_NAME}

echo "[$(date)] Uploading to S3..."

aws s3 cp ${FILE_NAME} s3://${S3_BUCKET}/${FILE_PREFIX}${FILE_NAME} --grants ${S3_GRANTS}

echo "[$(date)] Removing backup file..."

rm -f ${FILE_NAME}

echo "[$(date)] Done!"
