pipeline {
    agent any
    stages {
        stage('Backup Database') {
            steps {
                sh 'pg_dump -U user -h db_host dbname > /backups/db_backup.sql'
            }
        }
        stage('Backup Files') {
            steps {
                sh 'tar -czvf /backups/files_backup.tar.gz /data/files'
            }
        }
        stage('Upload Backup to S3') {
            steps {
                sh 'aws s3 cp /backups/ s3://backup-bucket/ --recursive'
            }
        }
    }
}

