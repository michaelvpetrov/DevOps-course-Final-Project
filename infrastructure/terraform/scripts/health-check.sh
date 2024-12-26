#!/bin/bash
JENKINS_URL="http://jenkins-master:8080"
JENKINS_CLI="/var/lib/jenkins/jenkins-cli.jar"

echo "Checking Jenkins Master..."
curl -s -o /dev/null -w "%{http_code}" $JENKINS_URL | grep -q "200"
if [ $? -eq 0 ]; then
    echo "Jenkins Master is running."
else
    echo "Jenkins Master is down!"
    exit 1
fi

echo "Checking Worker Nodes..."
java -jar $JENKINS_CLI -s $JENKINS_URL list-nodes | grep -q "worker"
if [ $? -eq 0 ]; then
    echo "All worker nodes are connected."
else
    echo "Some worker nodes are disconnected!"
    exit 1
fi

