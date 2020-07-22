## Use Kong API Gateway

Before adding any rules to the service, we must create Plugins in Kong Cluster.

Here we will be creating 2 plugins:

### Create Request ID Plugin

This plugin simply adds a unique id to each request's header

```
kubectl apply -f - <<DOC
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: viz-request-id
config:
  header_name: viz-request-id
plugin: correlation-id
DOC
```{{ execute T1 }}

### Create Rate Limiting Plugin

This plugin limits the no. requests coming to a service. Currently we're configuring 5 requests per minute.

```
kubectl apply -f - <<DOC
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: viz-rate-limit
config:
  minute: 5
  limit_by: ip
  policy: local
plugin: rate-limiting
DOC
```{{ execute T1 }}

### Add Ingress Rule

Kong Ingress Controller uses the Declarative style configuration to create kong resources like Services, Routes, Plugins etc etc.

This is where we configure kong plugins to be used by Kubernetes Resource. Right now we will be adding both "**viz-request-id**" and "**viz-rate-limit**" plugin to the "**echo**" service that we created in previous step. 

Lets apply add `konghq.com/plugins` with value `viz-request-id, viz-rate-limit` to annotations.

```
kubectl apply -f - <<DOC
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: demo
  annotations:
    konghq.com/plugins: viz-request-id, viz-rate-limit
spec:
  rules:
  - http:
      paths:
      - path: /demo
        backend:
          serviceName: echo
          servicePort: 80
DOC
```{{ execute T1 }}

- This ingress rule will divert all the traffic coming from `/demo` path to `echo` service while applying Kong plugins

### Verify

```
curl -i $PROXY_IP/demo
```{{ execute T1 }}

- Please note that, we're hitting `PROXY_IP` endpoint instead of `ECHO_ENDPOINT`, so request goes via Cluster Ingress only
- Now you will notice that Kong has added some extra header to request and response
- There will be a Request Header "**viz-request-id**" containing unique id
- Rate Limiting will also work, try to hit the same curl command more than 5 times