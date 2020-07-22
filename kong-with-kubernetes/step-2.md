## Deploy a Sample Service

### Deploy Echo Service
```
kubectl apply -f https://bit.ly/echo-service
```{{ execute T4 }}

### Verify Deployment
```
kubectl get svc
```{{ execute T5 }}

### Verify Endpoint
```
export ECHO_ENDPOINT=$(kubectl get -o jsonpath="{.spec.clusterIP}" service echo)

curl -i $ECHO_ENDPOINT
```{{ execute T6 }}