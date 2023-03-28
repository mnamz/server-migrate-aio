#!/bin/bash

backup_dir="/backup"
www_dir="/var/www"
date=$(date +%Y-%m-%d_%H-%M-%S)
mysql_root_password="your_mysql_root_password"

# create backup directory
mkdir -p $backup_dir

# dump all db
databases=$(mysql -u root -p$mysql_root_password -e "SHOW DATABASES;" -s --skip-column-names | grep -vE "(mysql|information_schema|performance_schema)")

for db in $databases; do
    echo "Dumping database: $db"
    mysqldump -u root -p$mysql_root_password $db > "$backup_dir/$db.sql"
done

# zip contents of /var/www directory
echo "Zipping contents of $www_dir directory"
zip -rq "$backup_dir/www_content_$date.zip" $www_dir/* > /dev/null

echo "Backup complete. Contents of backup directory:"
ls -l $backup_dir
