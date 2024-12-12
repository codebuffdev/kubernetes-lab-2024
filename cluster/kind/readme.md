# KIND

## set up kind env :

1. sudo apt update
2. sudo apt install golang

Add the following lines to your `~/.bashrc` or `~/.zshrc` to ensure your Go binaries are in your PATH: 3. export GOPATH=$HOME/go
4. export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

reload your shell configuration: 5. source ~/.bashrc

6. go install [sigs.k8s.io/kind@latest](http://sigs.k8s.io/kind@latest)

7. kind --version

## cluster setup :

kind create cluster --image kindest/node:v1.30.0@sha256:047357ac0cfea04663786a612ba1eaba9702bef25227a794b52890dd8bcd692e --name cka-cluster1

## See current context

- kubectl config current-context
- kubectl config get-contexts
- kubectl config set-cluster my-cluster-name
- kubectl config use-context kind-cka-cluster1  
   Switched to context "kind-cka-cluster1".

## kubeconfig file

- ${HOME}/.kube/config
- kubectl config view

## Cluster info

kubectl cluster-info --context cluster-name
kubectl cluster-info --context kind-cka-cluster1

## Cluster interactions

kubectl get nodes

## Multi nodes cluster

vi config.yaml

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
```

kind create cluster --config kind-example-config.yaml

kind create cluster --image kindest/node:v1.30.0@sha256:047357ac0cfea04663786a612ba1eaba9702bef25227a794b52890dd8bcd692e --name cka-cluster1 --config config.yaml

> get cluster nodes
> kind get nodes --name cluster-name
> kind get nodes --name cka-cluster1

## delete kind cluster

> kind get clusters
> cka-cluster1

> kind delete cluster --name cka-cluster
> Deleting cluster "cka-cluster" ...
