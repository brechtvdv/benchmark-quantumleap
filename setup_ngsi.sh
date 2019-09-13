#!/bin/bash

# "crate-service.yaml" created
# INFO Kubernetes file "grafana-service.yaml" created
# INFO Kubernetes file "mongo-service.yaml" created
# INFO Kubernetes file "orion-service.yaml" created
# INFO Kubernetes file "quantumleap-service.yaml" created
# INFO Kubernetes file "redis-service.yaml" created
# INFO Kubernetes file "crate-deployment.yaml" created
# INFO Kubernetes file "cratedata-persistentvolumeclaim.yaml" created
# INFO Kubernetes file "grafana-deployment.yaml" created
# INFO Kubernetes file "mongo-deployment.yaml" created
# INFO Kubernetes file "mongodata-persistentvolumeclaim.yaml" created
# INFO Kubernetes file "orion-deployment.yaml" created
# INFO Kubernetes file "quantumleap-deployment.yaml" created
# INFO Kubernetes file "redis-deployment.yaml" created
# INFO Kubernetes file "redisdata-persistentvolumeclaim.yaml" created

kubectl delete daemonsets,replicasets,services,deployments,pods,rc --all

kubectl create -f ./crate-db-deployment.yaml
kubectl create -f ./crate-db-persistentvolumeclaim.yaml
kubectl create -f ./crate-db-service.yaml
kubectl create -f ./mongo-db-deployment.yaml
kubectl create -f ./mongo-db-persistentvolumeclaim.yaml
kubectl create -f ./mongo-db-service.yaml

sleep 20

kubectl create -f ./orion-deployment.yaml
#kubectl create -f ./orion-service.yaml
kubectl create -f ./quantumleap-deployment.yaml
kubectl create -f ./quantumleap-service.yaml

