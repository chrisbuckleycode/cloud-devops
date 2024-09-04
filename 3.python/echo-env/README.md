# Python App Echo Container Environment Variables

A Python Flask app echos the container's environment variables.

## Build Instructions

- Create a repo at DockerHub and substitute below.
- Substitute your DockerHub username below.
- Create a PAT for authentication.

```
$ docker build -t <repo>/echo-env:latest -f Dockerfile .
$ docker login -u <username> docker.io
$ docker push <repo>/echo-env:latest
```

## Kubernetes Deploy Instructions

- Replace 'prefix' with your own repo name in `deployment_and_service.yaml`

```
# Apply manifest to create objects (namespace, deployment and ClusterIP service)
$ kubectl apply -f deployment_and_service.yaml

# Watch pods till READY
$ kubectl get pods -n echo-env -w

# Port forward the service:
kubectl port-forward service/echo-env-service -n echo-env 8080:80

# Visit http://localhost:8080 or use curl:
$ curl localhost:8080
```
