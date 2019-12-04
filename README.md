# benchmark-quantumleap

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
- --metric-resolution=30s
- --kubelet-insecure-tls
- --kubelet-preferred-address-types=InternalIP
```

Deploy
```
kubectl apply -f deploy/1.8+/
```

Verify (takes one minute)
```
kubectl get po -n kube-system |grep metrics
```

Check 
```
kubectl top pod
```

## Add table in CrateDB by creating subscription in Orion

When testing locally, change the hostname of the notification url inside `setup_subscription.sh` to the value of the environment variable `QUANTUMLEAP_SERVICE_HOST`, because Orion cannot connect to Quantumleap through localhost. You can retrieve this value by going inside a running docker container and run `printenv`.

Then run:
```
cd ..
./setup_subscription.sh
```

## Load data in CrateDB

Go to <KUBERNETES_IP>:4200 and run query with the content from `test_data`.

You can test if everything works by going to `http://KUBERNETES_IP:8668/v2/entities/urn:ngsi-ld:Sensor:123`

## Start client deployment that runs time series queries

```
kubectl create -f ./ngsi-vs-fragments-client.yaml
```

Scale up the client deployments
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

## Benchmark client

```
screen
METHOD='latest' AGGRPERIOD='day' FROMDATE='2018-01-05T15:44:34' TODATE='2020-03-05T15:44:34' node benchmark_client.js
```

This will output the response time.

press CTRL+A+D to exit

## Check amount of requests on server

```
sudo apt-get install httpry
sudo httpry -i cni0 -s
```