def call() {
    stage('Run Unit Tests') {
        steps {
            echo 'Running unit tests...'
            sh './run-unit-tests.sh'
        }
    }
    stage('Run Integration Tests') {
        steps {
            echo 'Running integration tests...'
            sh './run-integration-tests.sh'
        }
    }
    stage('Test Results') {
        steps {
            junit '**/test-results/*.xml'
        }
    }
}

