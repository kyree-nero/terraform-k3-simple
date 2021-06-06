#!/bin/sh

kubeconfig=`ls ../k3.yaml`
echo $kubeconfig
echo '...found kube at '$kubeconfig
export KUBECONFIG=$kubeconfig

