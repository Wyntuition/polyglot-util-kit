#!/bin/sh
NEXUS_SERVER="<URL>"
NEXUS_USER=jenkins
NEXUS_PASSWORD=PASSWORDword
NEXUS_REPO="my-nexus-repo"
BIN_FILENAME='sonarqube-8.2.0.32929.zip'
BIN_FILE=$1
BIN_GROUP="sonarqube"

if [ -z "$NEXUS_PASSWORD" ]; then
    echo "Enter ${NEXUS_USER} password:"; read NEXUS_PASSWORD
else
    echo "Nexus password loaded from NEXUS_PASSWORD env var"
fi

echo "curl --fail -k -u ${NEXUS_USER}:********* --upload-file ${BIN_FILE} ${NEXUS_SERVER}/${NEXUS_REPO}/${BIN_GROUP}/${BIN_FILENAME}"
curl --fail -k -u ${NEXUS_USER}:${NEXUS_PASSWORD} --upload-file ${BIN_FILE} ${NEXUS_SERVER}/${NEXUS_REPO}/${BIN_GROUP}/${BIN_FILENAME}
