## Deploy another app

Now we will create a Service with `ExternalName` type, and try to configure kong from Service resource.
- In previous step, we have added kong annotations to Ingress resource, now we will add annotations to Service

### Add External Service

```
kind: Service
apiVersion: v1
metadata:
  name: ext-httpbin
spec:
  ports:
  - protocol: TCP
    port: 80
  type: ExternalName
  externalName: httpbin.org
```{{ execute T1 }}

- We just created a simple Kubernetes Service which points to external URL: httpbin.org

### Add Ingress Rule for it

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ext-bin
spec:
  rules:
  - host: ext-bin.org
    http:
      paths:
      - backend:
          serviceName: ext-httpbin
          servicePort: 80
```{{ execute T1 }}

- Here we have created simple Ingress Rule which diverts the traffic from host `ext-bin.org` to our service `ext-httpbin`

### Verify Before Kong is Configured

```
curl -i -H "Host: ext-bin.org" $PROXY_IP/get
```{{ execute T1 }}

### Patch Kubernetes Service to Add Kong Configuration

Lets apply `rate-limiting` plugin to our service.

```
kubectl patch service ext-httpbin -p '{"metadata":{"annotations":{"konghq.com/plugins":"viz-rate-limit"}}}'
```{{ execute T1 }}

- This will apply annotation to service

### Verify

```
curl -i -H "Host: ext-bin.org" $PROXY_IP/get
```{{ execute T1 }}

- Notice the response headers and try hitting it multiple time to see rate limiting in action