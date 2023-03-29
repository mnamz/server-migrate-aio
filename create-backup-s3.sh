#!/bin/bash

MYSQL_USER="root"
MYSQL_PASSWORD="your_password_here"
S3_BUCKET_NAME="your_bucket_name_here"
FOLDER_NAME=$(date +%Y-%m-%d)

BACKUP_FILENAME="mysql_${FOLDER_NAME}.sql.gz"

# dump all db
mysqldump --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --all-databases | gzip > ${BACKUP_FILENAME}
aws s3api put-object --bucket ${S3_BUCKET_NAME} --key ${FOLDER_NAME}/
aws s3 cp ${BACKUP_FILENAME} s3://${S3_BUCKET_NAME}/${FOLDER_NAME}/
rm ${BACKUP_FILENAME}

# remove S3 folders older than a week
for s3_folder in $(aws s3 ls s3://${S3_BUCKET_NAME}/ | awk '{print $2}' | grep ${FOLDER_NAME} -v); do
  folder_date=$(echo ${s3_folder} | awk -F'-' '{print $1"-"$2"-"$3}')
  if [[ $(( ($(date +%s) - $(date -d ${folder_date} +%s)) / 86400 )) -gt 7 ]]; then
    aws s3 rm s3://${S3_BUCKET_NAME}/${s3_folder} --recursive
  fi
done
