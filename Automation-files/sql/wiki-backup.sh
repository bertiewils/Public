#!/bin/bash
echo "Creating SQL dump in /tmp" >> /var/log/syslog
mysqldump -u <REDACTED> -p<REDACTED> --databases cloudwiki >cloudwiki-backup.sql
echo "Local SQL backup complete" >> /var/log/syslog

echo "Copying sql backup to on premise server" >> /var/log/syslogs
scp -i /root/.ssh/sql_rsa -o StrictHostKeyChecking=no /tmp/cloudwiki-backup.sql root@<REDACTED>:/tmp/cloudwiki-backup.sql
echo "On-premise backup complete" >> /var/log/syslog
