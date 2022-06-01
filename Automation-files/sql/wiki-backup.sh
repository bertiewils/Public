#!/bin/bash
echo "Creating SQL dump in /tmp" >> /var/log/syslog
mysqldump -u tekore -ppassword1 --databases cloudwiki >cloudwiki-backup.sql
echo "Local SQL backup complete" >> /var/log/syslog

echo "Copying sql backup to on premise server" >> /var/log/syslogs
scp -i /root/.ssh/sql_rsa -o StrictHostKeyChecking=no /tmp/cloudwiki-backup.sql root@10.8.0.3:/tmp/cloudwiki-backup.sql
echo "On-premise backup complete" >> /var/log/syslog
