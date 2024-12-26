#!/bin/bash
JENKINS_URL="http://jenkins-master:8080"
JENKINS_CLI="/var/lib/jenkins/jenkins-cli.jar"
NODE_NAME=$1
WORK_DIR="/var/jenkins"

if [ -z "$NODE_NAME" ]; then
    echo "Usage: $0 <node_name>"
    exit 1
fi

java -jar $JENKINS_CLI -s $JENKINS_URL create-node $NODE_NAME <<EOF
<slave>
  <name>${NODE_NAME}</name>
  <remoteFS>${WORK_DIR}</remoteFS>
  <numExecutors>2</numExecutors>
  <launcher>
    <hudson.slaves.JNLPLauncher/>
  </launcher>
</slave>
EOF

