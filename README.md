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

## Setup metrics server

```
git clone https://github.com/kubernetes-incubator/metrics-server.git
cd metrics-server/
```

```
vi deploy/1.8+/metrics-server-deployment.yaml
#Add following lines under image:
# command:
#     - /metrics-server
#     - --metric-resolution=30s
#     - --kubelet-insecure-tls
#     - --kubelet-preferred-address-types=InternalIP
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
kubectl top pod --all-namespaces
```

## Add table in CrateDB by creating subscription in Orion

```
./setup_subscription.sh
```

## Load data in CrateDB

Go to <KUBERNETES_IP>:4200 and run query with the content from `test_data`.

You can test if everything works by going to `http://localhost:8668/v2/entities/lora.343233384C377A18`

## Start client deployment that runs time series queries

```
kubectl create -f ./setup_client.yaml
```

Scale up the client deployments
```
 kubectl scale deployment/client --replicas=10
```