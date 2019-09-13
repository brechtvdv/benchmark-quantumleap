#!/bin/bash

#######
# install metrics-server
git clone https://github.com/kubernetes-incubator/metrics-server.git
cd metrics-server/
# vi deploy/1.8+/metrics-server-deployment.yaml
#Add following lines under image:
# command:
#     - /metrics-server
#     - --metric-resolution=30s
#     - --kubelet-insecure-tls
#     - --kubelet-preferred-address-types=InternalIP

# Deploy
# kubectl apply -f deploy/1.8+/

# Verify
# kubectl get po -n kube-system |grep metrics

# Check 
# kubectl top pod --all-namespaces