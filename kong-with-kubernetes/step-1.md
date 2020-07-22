## Install Kong to Kubernetes Cluster

Lets install the official Kong Ingress Controller using `kubectl`.

### Install

```
kubectl apply -f https://bit.ly/k4k8s
```{{ execute T1 }}

### Verify

```
kubectl get services -n kong
```{{ execute T1 }}

- It should give you the list of services in `kong` namespace

### Get Proxy Endpoint

```
export PROXY_IP=$(kubectl get -o jsonpath="{.spec.clusterIP}" service -n kong kong-proxy)
```{{ execute T1 }}

### Access the API

```
curl -i $PROXY_IP/demo
```{{ execute T1 }}

- It will give some warning, as we haven't configured Kong