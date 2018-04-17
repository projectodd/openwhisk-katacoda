#!/bin/bash

PASSED=false
TIMEOUT=0
until $PASSED || [ $TIMEOUT -eq 60 ]; do
  OC_DEPLOY_STATUS=$(oc get pods -o wide | grep -m 1 "controller" | awk '{print $3}')
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
