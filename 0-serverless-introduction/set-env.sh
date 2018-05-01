#!/bin/bash
rm -rf /root/projects
export OPENWHISK_HOME="${HOME}/openwhisk"
mkdir -p $OPENWHISK_HOME/bin

wget https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
tar -zxf OpenWhisk_CLI-latest-linux-386.tgz -C $OPENWHISK_HOME/bin

export PATH="${OPENWHISK_HOME}/bin:${PATH}"
