#!/bin/bash
ssh root@host01 "rm -rf /root/projects"
ssh root@host01 "rm -rf /root/temp-pom.xml"
ssh root@host01 "mkdir -p /root/projects/ocf && mkdir -p /root/openwhisk/bin/"
ssh root@host01 "wget -c https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz -P /root/installation"
ssh root@host01 "tar -zxvf /root/installation/OpenWhisk_CLI-latest-linux-386.tgz -C /root/openwhisk/bin/"
ssh root@host01 "oc new-project faas --display-name='FaaS - OpenShift Cloud Functions'"
ssh root@host01 "oc adm policy add-role-to-user admin developer -n faas"
ssh root@host01 "oc process -f https://git.io/vpnUR | oc create -f -"
ssh root@host01 "git clone https://github.com/apache/incubator-openwhisk-devtools openwhisk-devtools"
ssh root@host01 "cd openwhisk-devtools/java-action-archetype \
    && mvn -DskipTests clean install  \
    && cd  \
    && rm -rf /tmp/openwhisk-devtools"
