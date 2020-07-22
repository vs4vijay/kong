## Install Kong to Kubernetes Cluster


### Install
```
kubectl apply -f https://bit.ly/k4k8s
```{{ execute T1 }}

### Verify
```
kubectl get services -n kong
```{{ execute T2 }}

### Get Proxy Endpoint
```
export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
echo "Proxy IP is ${PROXY_IP}"
```