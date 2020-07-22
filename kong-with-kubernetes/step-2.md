## Deploy an app

Now we will deploy a sample app, this will be used by Kong in next step

### Deploy Echo Service

```
kubectl apply -f https://bit.ly/echo-service
```{{ execute T1 }}

### Verify Deployment

```
kubectl get svc
```{{ execute T1 }}

### Get Endpoint

```
export ECHO_ENDPOINT=$(kubectl get -o jsonpath="{.spec.clusterIP}" service echo)
```{{ execute T1 }}

### Verify Endpoint

```
curl -i $ECHO_ENDPOINT
```{{ execute T1 }}

- It should give you some response, notice the headers