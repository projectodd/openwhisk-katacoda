#!/bin/bash
rm -rf /root/projects
export OPENWHISK_HOME="${HOME}/openwhisk"
mkdir -p $OPENWHISK_HOME/bin
mkdir -p /root/projects/getting-started

wget https://github.com/apache/incubator-openwhisk-cli/releases/download/latest/OpenWhisk_CLI-latest-linux-386.tgz
tar -zxf OpenWhisk_CLI-latest-linux-386.tgz -C $OPENWHISK_HOME/bin

export PATH="${OPENWHISK_HOME}/bin:${PATH}"

oc new-project faas --display-name="FaaS- Apache OpenWhisk"
oc adm policy add-role-to-user admin developer -n faas
oc process -f https://git.io/openwhisk-template | oc create -f -

PASSED=false
TIMEOUT=0
until $PASSED || [ $TIMEOUT -eq 60 ]; do
  OC_DEPLOY_STATUS=$(oc get pods -o wide | grep "controller-0" | awk '{print $3}')
  if [ "$OC_DEPLOY_STATUS" == "Running" ]; then
    PASSED=true
    break
  fi
  let TIMEOUT=TIMEOUT+1
  sleep 10
done
PASSED=false
TIMEOUT=0
until $PASSED || [ $TIMEOUT -eq 5 ]; do
  INVOKER_HEALTH=$(oc logs controller-0 -n faas | grep "invoker status changed" | grep " Healthy" | awk '{print $11}')
  if [ "$INVOKER_HEALTH" == "Healthy" ]; then
    PASSED=true
    break
  fi
  let TIMEOUT=TIMEOUT+1
  sleep 5
done
PASSED=false
TIMEOUT=0
until $PASSED || [ $TIMEOUT -eq 10 ]; do
  SUCCESSFUL_JOB=$(oc get jobs -o wide | grep "$1" | awk '{print $3}')
    if [ "$SUCCESSFUL_JOB" == "1" ]; then
      PASSED=true
      break
    fi
    let TIMEOUT=TIMEOUT+1
    sleep 5
  done

oc patch route openwhisk --namespace faas -p '{"spec":{"tls": {"insecureEdgeTerminationPolicy": "Allow"}}}'
AUTH_SECRET=$(oc get secret whisk.auth -o yaml | grep "system:" | awk '{print $2}' | base64 --decode)
wsk property set --auth $AUTH_SECRET --apihost $(oc get route/openwhisk --template="{{.spec.host}}")
wsk -i property get
wsk -i action list
