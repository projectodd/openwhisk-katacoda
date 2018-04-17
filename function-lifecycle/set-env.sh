#!/bin/bash
rm -rf /root/projects
mkdir -p /root/projects

PROJECTODD_LEARN_TAG=learn
docker pull projectodd/busybox:${PROJECTODD_LEARN_TAG}
docker pull projectodd/nginx:${PROJECTODD_LEARN_TAG}
docker pull projectodd/alarmprovider:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-java-8:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-nodejs-6:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-nodejs-8:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-php-7:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-python-2:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-python-3:${PROJECTODD_LEARN_TAG}
docker pull projectodd/action-swift-3:${PROJECTODD_LEARN_TAG}
docker pull projectodd/controller:${PROJECTODD_LEARN_TAG}
docker pull projectodd/invoker:${PROJECTODD_LEARN_TAG}
docker pull projectodd/whisk_alarms:${PROJECTODD_LEARN_TAG}
docker pull projectodd/whisk_catalog:${PROJECTODD_LEARN_TAG}
docker pull projectodd/whisk_couchdb:${PROJECTODD_LEARN_TAG}
docker pull projectodd/cluster-controller:${PROJECTODD_LEARN_TAG}
docker pull projectodd/kafka:${PROJECTODD_LEARN_TAG}
docker pull projectodd/zookeeper:${PROJECTODD_LEARN_TAG}

cd /tmp
[ -f OpenWhisk_CLI-latest-linux-386.tgz ] || \
    wget -N -nv https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
[ -f /usr/local/bin/wsk ] || sudo tar xzvf OpenWhisk_CLI-latest-linux-386.tgz -C /usr/local/bin wsk

until $(oc status &> /dev/null); do sleep 1; done; oc adm policy add-cluster-role-to-user cluster-admin admin
oc new-project faas --display-name="FaaS - Apache OpenWhisk"
oc adm policy add-role-to-user admin developer -n faas

oc process -f https://git.io/openwhisk-template | oc create -f -
#oc process -f https://github.com/projectodd/openwhisk-openshift/master/learn-template.yml | oc create -f -

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
