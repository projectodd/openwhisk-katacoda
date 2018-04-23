#! /bin/bash

rm -rf /root/projects
mkdir -p /root/projects/

###  OpenWhisk images
PROJECTODD_VERSION=f5eae82
OPENWHISK_VERSION=rhdemo-b7724ef
STRIMZI_VERSION=0.2.0

docker pull busybox
docker pull centos/nginx-112-centos7@sha256:42330f7f29ba1ad67819f4ff3ae2472f62de13a827a74736a5098728462212e7
docker pull openwhisk/alarmprovider:1.9.0
docker pull projectodd/action-java-8:${PROJECTODD_VERSION}
docker pull projectodd/action-nodejs-6:${PROJECTODD_VERSION}
docker pull projectodd/action-nodejs-8:${PROJECTODD_VERSION}
docker pull projectodd/action-php-7:${PROJECTODD_VERSION}
docker pull projectodd/action-python-2:${PROJECTODD_VERSION}
docker pull projectodd/action-python-3:${PROJECTODD_VERSION}
docker pull projectodd/controller:${OPENWHISK_VERSION}
docker pull projectodd/invoker:${OPENWHISK_VERSION}
docker pull projectodd/whisk_alarms:${PROJECTODD_VERSION}
docker pull projectodd/whisk_catalog:da00e0c
docker pull projectodd/whisk_couchdb:${PROJECTODD_VERSION}
docker pull strimzi/cluster-controller:${STRIMZI_VERSION}
docker pull strimzi/kafka:${STRIMZI_VERSION}
docker pull strimzi/zookeeper:${STRIMZI_VERSION}

cd /tmp
[ -f OpenWhisk_CLI-latest-linux-386.tgz ] || \
    wget -N -nv https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
[ -f /usr/local/bin/wsk ] || sudo tar xzvf OpenWhisk_CLI-latest-linux-386.tgz -C /usr/local/bin wsk

until $(oc status &> /dev/null); do sleep 1; done; oc adm policy add-cluster-role-to-user cluster-admin admin
oc new-project faas --display-name="FaaS - Apache OpenWhisk"
oc adm policy add-role-to-user admin developer -n faas

oc process -f https://git.io/openwhisk-template | oc create -f -

git clone https://github.com/apache/incubator-openwhisk-devtools openwhisk-devtools

cd openwhisk-devtools/java-action-archetype \
    && mvn -DskipTests clean install  \
    && cd  \
    && rm -rf /tmp/openwhisk-devtools

while [ -z "`oc logs controller-0 -n faas 2>&1 | grep "invoker status changed"`" ]
do
    echo "Waiting for OpenWhisk to finish initializing (`date`)"
    sleep 10
done

oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'

AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode)
wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}")
