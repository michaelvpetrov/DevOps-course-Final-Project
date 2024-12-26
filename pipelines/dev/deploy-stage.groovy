def call(env) {
    stage("Deploy to ${env.toUpperCase()} Environment") {
        steps {
            echo "Deploying to ${env} environment..."
            sh "./deploy.sh --env=${env}"
        }
    }
}

