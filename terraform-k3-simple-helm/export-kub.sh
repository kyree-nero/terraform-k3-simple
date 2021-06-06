#!/bin/sh

kubeconfig=`ls -d ../k3s-myk3*.yaml`
echo $kubeconfig
echo '...found kube at '$kubeconfig
export KUBECONFIG=$kubeconfig

