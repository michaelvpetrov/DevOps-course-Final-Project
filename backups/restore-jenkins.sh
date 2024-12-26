#!/bin/bash
BACKUP_FILE="/backups/jenkins_backup_latest.tar.gz"
JENKINS_HOME="/var/lib/jenkins"

aws s3 cp s3://backup-bucket/jenkins/$BACKUP_FILE /tmp/jenkins_backup.tar.gz
tar -xzvf /tmp/jenkins_backup.tar.gz -C $JENKINS_HOME
systemctl restart jenkins

