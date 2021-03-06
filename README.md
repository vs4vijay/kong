# kong

Try at KataCode: https://katacoda.com/vs4vijay/scenarios/kong-with-kubernetes

## Getting Start

### Kong with Docker

- Run Kong with Postgres DB: 
```
docker-compose up
```
- Run with Konga UI:
```
docker-compose -f docker-compose.yml -f docker-compose.konga.yml up
```
- Stop Kong
```
docker-compose down
```

### Kong with Kubernetes

- Acts as north-south traffic gateway
- Declarative configuration
- DB-less

Installation:
```shell
kubectl apply -f https://bit.ly/k4k8s

kubectl get services -n kong

export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

Try Sample Service:
```shell
kubectl apply -f https://bit.ly/echo-service


kubectl apply -f - <<DOC
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: viz-request-id
config:
  header_name: viz-request-id
plugin: correlation-id
DOC


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

```

Notes:
- Kong Plugins can be applied to k8s Ingress or Service
- Can use `KongClusterPlugin` for cluster-level resources

References:
- https://github.com/Kong/kubernetes-ingress-controller
- https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/guides/getting-started.md
- https://github.com/Kong/kubernetes-ingress-controller/blob/master/docs/guides/using-external-service.md
- https://www.konglabs.io/get-started-with-kong-free-access/


---

## Screenshots

### Konga UI

![Konga UI](/.screenshots/konga_ui.png)

---

### Development Notes

```shell

kubectl apply -f https://bit.ly/k8s-httpbin

kubectl patch service ext-httpbin -p '{"metadata":{"annotations":{"konghq.com/plugins":"viz-rate-limit"}}}'

kubectl annotate service httpbin konghq.com/plugins=viz-request-id

kubectl apply -f - <<DOC

DOC

https://raw.githubusercontent.com/istio/istio/master/samples/bookinfo/platform/kube/bookinfo.yaml

https://github.com/kubernetes/examples/tree/master/guestbook-go

https://bit.ly/k4k8s
https://bit.ly/echo-service
https://bit.ly/k8s-redis
https://bit.ly/k8s-httpbin
https://bit.ly/kong-ingress-dbless


#####################
# Inline HTTP Server

## Using Python
python -m SimpleHTTPServer
python3 -m http.server

## Using Bash
while true; do nc -l -p 8000 -c 'echo -e "HTTP/1.1 200 OK\n\n $(date)"'; done
while true; do echo -e "HTTP/1.1 200 OK\n\n $(date)" | nc -l localhost 8000; done

## Using Ruby
ruby -run -e httpd . -p 8000

## Using PHP
php -S localhost:8000
#####################

export PROXY_IP=$(kubectl get -o jsonpath="{.spec.clusterIP}" service -n kong kong-proxy)

```