pipeline {
    agent any
    stages {
        stage('Validate Input') {
            steps {
                input message: 'Enter snapshot ID for revert:',
                      parameters: [string(name: 'SNAPSHOT_ID', defaultValue: '', description: 'Snapshot ID to revert')]
            }
        }
        stage('Revert Database') {
            steps {
                echo 'Reverting database to snapshot ${params.SNAPSHOT_ID}...'
                sh "aws rds restore-db-instance-from-snapshot --db-instance-identifier mydb --snapshot-identifier ${params.SNAPSHOT_ID}"
            }
        }
        stage('Revert Files') {
            steps {
                echo 'Reverting files from backup...'
                sh 'aws s3 sync s3://backup-bucket/files /data/files --exact-timestamps'
            }
        }
    }
    post {
        always {
            echo 'Revert process completed.'
        }
        failure {
            mail to: 'ops-team@example.com',
                 subject: 'Data Revert Failed: ${env.JOB_NAME} #${env.BUILD_NUMBER}',
                 body: 'Check Jenkins for details: ${env.BUILD_URL}'
        }
    }
}

