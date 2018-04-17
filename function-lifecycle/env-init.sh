ssh root@host01 "yum -y install wget tree"
ssh root@host01 "until $(oc status &> /dev/null); do sleep 1; done; oc adm policy add-cluster-role-to-user cluster-admin admin"
ssh root@host01 "mkdir -p ~/projects/openwhisk-devtools"