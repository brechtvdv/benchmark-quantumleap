# benchmark-quantumleap

This repository provides scripts to deploy and compare a Fiware Quantumleap (QL) API with a Linked Data Fragments (LDF) API for timeseries on a Kubernetes cluster. The NGSIv2 Orion context broker is deployed for ingesting new data. CrateDB is used for persisting the data and allowing spatial-temporal queries through a [QL API](https://github.com/smartsdk/ngsi-timeseries-api). The [LDF API](https://gitlab.ilabt.imec.be/brvdvyve/cratedb2fragments) also runs on top of the CrateDB and fragments the data per day by default.

A [HTTP client](https://gitlab.ilabt.imec.be/brvdvyve/ngsi-vs-fragments-client) is provided that can be configured to use the QL or LDF API and supports 4 scenarios:
1) Retrieving the latest data
2) Retrieving all data from a certain date up untill now (open interval - historical + realtime data)
3) Retrieving all data from a certain date up untill another datetime in the past (closed interval - only historical data)
4) Same as 3) + aggregation per hour

Following commands need to be run on the master node of a Kubernetes cluster to deploy everything:

## Git clone this repository

```
git clone https://github.com/brechtvdv/benchmark-quantumleap.git
cd benchmark-quantumleap
```

## Setup kubernetes with full NGSI setup

```
chmod +x *.sh
./fill-in-master-ip-address.sh
./setup_ngsi.sh
```

## Setup LDF on top of crateDB

```
kubectl create -f ./fragments-deployment.yaml
```

## Setup metrics server

```
git clone https://github.com/kubernetes-incubator/metrics-server.git
cd metrics-server/
```

```
vi deploy/1.8+/metrics-server-deployment.yaml
```

Add following lines under image:
```
command:
- /metrics-server
- --metric-resolution=10s
- --kubelet-insecure-tls
- --kubelet-preferred-address-types=InternalIP
```

When error with connectivity between nodes:
```
kubectl -n kube-system apply -f https://git.io/weave-kube-1.6
```

Failed create pod sandbox:
```
kubectl -n kube-system apply -f https://raw.githubusercontent.com/coreos/flannel/bc79dd1505b0c8681ece4de4c0d86c5cd2643275/Documentation/kube-flannel.yml
```

For ARM64 (or aarch64) architecture (don't forget to set kubernetes.io/arch to arm64):
```
 image: k8s.gcr.io/metrics-server-arm64:v0.3.6
        args:
          - --kubelet-preferred-address-types=InternalIP
          - --metric-resolution=20s
          - --kubelet-insecure-tls
          - --cert-dir=/tmp
          - --secure-port=4443
```
Deploy
```
kubectl apply -f deploy/1.8+/
```

Verify (takes one minute)
```
kubectl get po -n kube-system |grep metrics
```

With following command, you can check the CPU and memory performance of the server and clients:
```
kubectl top pod
```

## Add table in CrateDB by creating subscription in Orion

When testing locally, change the hostname of the notification url inside `setup_subscription.sh` to the value of the environment variable `QUANTUMLEAP_SERVICE_HOST`, because Orion cannot connect to Quantumleap through localhost. You can retrieve this value by going inside a running docker container and run `printenv | grep QUANTUMLEAP_SERVICE_HOST`.

Then run:
```
cd ..
./setup_subscription.sh
```

## Load data in CrateDB

Go to <KUBERNETES_IP>:4200 and run query with the content from `test_data`.
You can create a new test dataset by configuring and running `node create_test_data.js`.

You can test if everything works by going to `http://KUBERNETES_IP:8668/v2/entities/urn:ngsi-ld:Sensor:123`

## Start client deployment that runs time series queries

Configure the client inside `ngsi-vs-fragments-client.yaml` (API, PORT, AGGRPERIOD, FROMDATE and TODATE).

```
kubectl create -f ./ngsi-vs-fragments-client.yaml
```

Scale up the client deployments (now we're benchmarking)
```
 kubectl scale deployment/client --replicas=10
```

## Ingest new data

```
sudo apt-get install curl software-properties-common
curl -sL https://deb.nodesource.com/setup_10.x | sudo bash -
sudo apt-get install nodejs

screen
node setup_ingest.js
```

press CTRL+A+D to exit

## Check amount of requests on server

```
sudo apt-get install httpry
sudo httpry -i cni0 -s
```
