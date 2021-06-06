#!/bin/sh

kubeconfig=`ls ../k3s.yaml`
echo $kubeconfig
echo '...found kube at '$kubeconfig
export KUBECONFIG=$kubeconfig

