#!/bin/bash
BACKUP_DIR="/backups/jenkins"
JENKINS_HOME="/var/lib/jenkins"

mkdir -p $BACKUP_DIR
tar -czvf $BACKUP_DIR/jenkins_backup_$(date +%F).tar.gz -C $JENKINS_HOME .
aws s3 cp $BACKUP_DIR/jenkins_backup_$(date +%F).tar.gz s3://backup-bucket/jenkins/

