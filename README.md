# kubernetes-lab-23

Kubernetes is an open-source container management(orchestration) tool, which automates container deployment, container scaling & load balancing. <br>
It schedules, runs & manages isolated container which are running on virtual/physical/cloud machines.
All top cloud providers supports Kubernetes.

### k8s naming convention

It's inspired from Numeronym. <br>
i18n - Internationalization <br>
k8s - Kubernetes <br>

### History

Google developed an internal system called `brog` later named as `omega` that deployed & manage thousand google application & service on the cluster.
IN 2004, google introduced k8s as an open source platform written in "Golang" & later donated to **CNCF**.

### Online platform for k8s

1. Kubernetes playground
2. play with k8splay with Kubernetes classroom

### Cloud based k8s service

1. GKE - google Kubernetes service
2. AKS - Azure Kubernetes service
3. Amazon EKS - Elastic Kubernetes service

### Kubernetes' installation tool

1. Minicube
2. Kubeadm

## Problem with just container deployment

1. Containers can not communicate with each other.
2. Autoscaling & load balancing was not possible on container.
3. Container had to be managed carefully.

## Features of k8s

1. Orchestration (Clustering of any number of containers running on different network)
2. Autoscaling (vertical(preferred one),horizontal)
3. Auto healing
4. Load balancer
5. Platform independence
6. Fault tolerance
7. rollback
8. container health monitoring
9. batch execution (one time, sequential, parallel)

## Kubernetes vs Docker swam

**Installation & cluster configuration** - <br>
K8s - Complicated & time-consuming <br>
Docker swam - Fast & easy <br>

**container supports** - <br>
K8s - works with all type of container (docker,rocket etc.) <br>
Docker swam - works with only docker (biggest problem) <br>

**GUI** - <br>
K8s - Gui is available <br>
Docker swam - Gui is not available <br>

**Data volumes** - <br>
K8s - Only shared with containers in same pod <br>
Docker swam - can be shared with any other containers <br>

**Updates & rollback** - <br>
K8s - Process scheduling to maintain service while updating. <br>
Docker swam - progressive updates of service health monitoring throughout the update.

**Autoscaling** <br>
K8s - supports vertical & horizontal scaling <br>
Docker swam - Not supports Autoscaling <br>

**Logging & monitoring** <br>
K8s - inbuilt tool for monitoring <br>
Docker swam - use 3rd party tool like splunk <br>

# Working with K8s

## Architecture of Kubernetes

### manifest file

We create manifest file (json/yaml). <br>
Apply manifest to cluster(to master) to bring into desired state. <br>
Pod runs on worker nodes, which is controlled by master.

### Role of master node

1. K8s cluster contains containers, containers can be running on bare metal(on-premises)
   /VM-instances/cloud-instances/all mix.
2. K8s designates one or more of these as master & all other as worker.
    1. one master n worker nodes
    2. multiple master & worker nodes
3. The master is now going to run set of k8s processes(api-server,etcd,kube scheduler,Controller manager). These
   processes will ensure smooth functioning of cluster these processes are called "control plane".
4. Master runs control plane to run cluster smoothly.

### components of control plane/master

#### kube-api-server

1. kube-api-server is for all communication.
2. This api-server interacts directly with user(i.e. we apply yml or json manifest to kube-api-server).
3. This kube-api-server is meant to scale automatically as per the load.
4. kube-api-server is front-end of control plane.

#### etcd

1. Stores metadata & status of cluster.
2. etcd is consistent & high-available store.
3. Store in key-value format.
4. Source of touch for cluster state (holds information about state of cluster).

**features**

1. fully replicated - the entire state is available on every node in the cluster.
2. secure - Implements automatic TLS with optional client-certificate authentication.
3. fast - Benchmarked at 10,000 write per second.

#### kube-scheduler (action)

1. When users make request for the creation & management of PODS,kube-scheduler is going to take action on the requests.
2. It handles POD creation & management.
3. kube-scheduler match/assign any node to create & run pods.
4. A scheduler watches for newly created PODs that have no node assigned.
5. For every POD that the scheduler becomes responsible for finding the best node for that pod to run on.
6. Scheduler gets the information for hardware configuration form configuration file & schedules the PODs on nodes
   accordingly.

#### Controller-manager

1. Makes sure actual state cluster matches to desired state.
2. Two possible choices for controller manager.
    1. If k8s on cloud, then it will be Cloud-controller-manger
    2. If k8s on non-cloud, then it will be kube-controller-manger

**components on master that runs controller**

1. Node-controller - For checking the cloud provider to determine if a node has been detected if a node has been
   detected
   in the cloud after it stops responding.
2. Route-controller - responsible for setting up network, routes on your cloud.
3. Service-controller - responsible for load balancer on your cloud against services of type load balancer.
4. Volume controller - For creating, attaching & monitoring volumes & interacting with the cloud provider to orchestrate
   volume.

### Worker Nodes

In node, we run 3 important piece of software/process.

#### Kubelet

1. Agent running on the nodes.
2. Listens to k8s master (like pod creation request)
3. It use port 10255
4. Send success/failure report to master.
5. kubelet -> kube-api-server -> kube-Controller

#### container engine

1. works with kubelet
2. pulling images
3. start/stop Containers
4. exposing containers on ports specified in manifest.

#### kube-proxy

1. Assign IP to each pod.
2. It is required to assign IP address to pods(dynamic)
3. Kube proxy runs on each node & this make sure that each pod will get sure that each pod will get unique ip address.

These **3** components collectively called as worker node.

## POD

1. POD is the smallest unit in k8s.
2. POD is a group of one or more containers that are deployed together on the same host.
3. A cluster is a group of nodes. A cluster has at least one worker node & a master node.
4. In k8s, the control unit is the PODs, not containers.
5. POD consist of one or more tightly coupled containers.
6. POD runs on node, which is control by master.
7. K8s only knows about PODs(doesn't know about individual container).
8. We cannot start container without a POD.
9. One POD usually contains one container(recommended).

## Multi-container PODS

1. Share access to memory space.
2. Connect to each other using localhost<container port>.
3. Share access to the same volume.
4. Containers within pod are deployed in an all-or-nothing manner.
5. Entire pod is hosted on the same node(schedular will decide about which node).

## POD Limitations

1. No auto-healing or scaling by default. We can add higher level k8s object & add this functionality.
2. POD crashes.

### Higher level k8s objects

1. Replication Set - Scaling & healing
2. Deployment -> versioning & rollback
3. Service -> static(non-ephemeral) IP & networking
4. Volume -> Non-ephemeral storage

## v.Important

1. single cloud (aws) -> commands starts with kubectl
2. on premise -> kubeadm
3. federated (hybrid cloud) -> kubefed

# Setup Kubernetes Master and Worker Node on AWS cloud

Lunch 3 instances (ubuntu 20.04) <br>
1 - master (min 2 cpu & 4 gb ram -> t2.medium ) <br>
2 - worker node (t2.miro) <br>

Get access to the 3 instances using ssh client.

## Commands common for Master & worker nodes

sudo su //give root user access <br>
apt-get update

[
Installing http package
this package is needed for intra(in one(with in)) cluster communication
particularly from control plane to individual pods.
To securely communicate with master node
] <br>
apt-get install apt-transport-https

### Install docker (containerization tool)

apt install docker.io -y <br>
docker --version <br>
systemctl start docker <br>
systemctl enable docker <br>

### Setup open GPG key.

[This is required for intra cluster Communication.
It will be added to source key on this node i.e. when k8s sends signed info to our host, it is going to accept those information because this open GPG key is present in the source key.]
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add

### k8s download

#### edit source.list

apt get install nano

nano /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
ctrl + x -> Y -> enter (save & quit nano)

apt-get update

apt-get install -y kubelet kubeadm kubectl kubernetes-cni

### BOOTSTRAPPING (establishing communication between master & nodes) THE MASTER NODE (IN MASTER ONlY)

To initialize k8s cluster -> kubeadm init
here 'll get one long command will be displayed "kubeadm join ...." copy & store it for future usages.

create both .kube & it's parent directories (-p)
mkdir -p $HOME/.kube

(copy admin.conf file to config file)
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config

(provide user permission to config file)
chown $(id -u):$(id -g) $HOME/.kube/config

Deploy flannel node network for it's repository path. Flannel is going to place a binary in each node.
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

kubectl apply
-f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

#### CONFIGURE WORKER NODES (IN NODES)

COPY LONG CODE PROVIDED MY MASTER IN NODE NOW LIKE CODE GIVEN BELOW

e.g- kubeadm join 172.31.6.165:6443 --token kl9fhu.co2n90v3rxtqllrs --discovery-token-ca-cert-hash sha256:
b0f8003d23dbf445e0132a53d7aa1922bdef8d553d9eca06e65c928322b3e7c0

#### GO TO MASTER AND RUN THIS COMMAND

kubectl get nodes

kubeadm join 172.31.34.172:6443 --token blqn19.fvfvtu08pmxvyjca --discovery-token-ca-cert-hash sha256:
d1aa597ed1eed3fff1d7ba577e192266e275f06989859feb7de62eeaa46beb04

# Installation of Minikube on aws [working model]

instance type - linux-22.04 - t2.medium

## Step 1

Update the apt package index and install packages to allow apt to use a repository over HTTPS and add GPG keys.

sudo apt-get update

sudo apt-get install \
ca-certificates \
curl \
gnupg \
lsb-release
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
"
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## Step 2

Install Docker Engine

sudo apt-get update <br>
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin <br>
sudo service docker start

make docker as sudo - <br>
sudo groupadd docker

Add your user to the docker group. <br>
sudo usermod -aG docker $USER

## Step 3

Kubectl installation steps/commands

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version --client

## Step 4

Minikube Installation

curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

sudo install minikube-linux-amd64 /usr/local/bin/minikube

**minikube start**

## Step 5

check status - minikube status <br>
To check all namespaces - kubectl get ns <br>  
To check current context of the cluster - kubectl config current-context


# Kubernetes Objects

1. In simple term k8s treat a work/process as an object.
2. Kubernetes uses objects to represent the state of your cluster.What containerized applications are running (add on
   which node) also will be maintained as an object.
3. The policies around how those applications behave, such as restart policies, upgrades & fault tolerance all are
   teated as an object.
4. Once you create the object, the kubernetes system will constantly work to ensure that object exist & maintain's the
   cluster's desired state.
5. Every kubernetes objects includes two nested fields that govern the object configuration the object specification(
   desired status) & object status(actual status).
    1. object specification - The specification, which we provide describes your desired state for the object.(The
       characteristics we want the object to have ).
    2. object status- The status describes the actual state of the object & is supplied & uploaded by the kubernetes
       system.
6. All objects are identified by a unique name & a UID.
7. The basic kubernetes objects includes
    1. POD
    2. Service
    3. Volume
    4. Namespace
    5. ReplicaSets
    6. Secrets
    7. ConfigMaps
    8. Deployments
    9. Jobs
    10. DaemonSet
8. Object is represented as JSON or YAML files.
9. You create these & then push them to the kubernetes API with kubectl.(kubectl cmd)

## Relationship between objects

1. POD manages Containers.
2. ReplicaSet manage pods.
3. Service expose POD processes to the outside world.
4. Configmaps & secrets helps you config PODS.

## What is state of the object?

1. Replicas(2/2)
2. Image (Tomcat/ubuntu)
3. Name
4. Port
5. Volume
6. startup cmd
7. Detached (default)

## Kubernetes object management

The kubectl command line tool support several different ways to create & manage kubernetes object.

1. Imperative Commands -> performs on live objects -> on dev env
   Explicitly tell how to accomplish it.

2. Declarative Object configuration -> individual files (yaml/json) -> production env [recommended approach]
   Declarative approach is all about describing what you are trying to achieve, with out instructing how to do it.

# More about PODS

1. When a POD gets created, it is scheduled to run on a node in your cluster. But which cluster certainly depends on
   control-plane, but if we want our POD to get created in a specific w.node we can mentioned it in our manifest.
2. The POD remains on the node until the process is terminated, or the POD object is deleted or the POD is evicted for
   lack of resources or the node fails.
3. If the POD is scheduled to a node & that node fails or the scheduling operation fails itself the POD is deleted.
4. If a node dies, the POD scheduled to that node are scheduled for deletion after a timeout period.
5. A given pod (UID) is not "rescheduled" to a new POD, instead it will be replaced by an identical POD, with even the same name if desired, but with a new UID.
6. Volume in a POD will exists as long as that POD(with that UID) exists. If that POD is deleted for any reason, volume is also destroyed & created as new on a new POD.
7. A controller can create & manage multiple pods, handling replication rollout & providing self-healing capabilities.

## kubernetes configurations

1. **All-in-one** (Single node installation)
   With all-in-one, all the master & worker components are installed on a single node. This is very useful for
   learning,development & testing . Never recommended for production env.
   Eg - Minikube
2. **Single node etcd, single Master & multi-worker installation** [Realtime env]
   In this setup, we have a single master node, with also a single etcd instance multiple worker nodes are connected to
   the master node.
3. **Single node etcd, multi Master & multi-worker installation** [Realtime env]
   Here we have multiple master node which works in an High Availability (HA) mode.

### manifest file

filename.yaml/yml <br>
pod1.yml

# Working with PODs

## creating pod (POC)

   <b>vi pod1.yml</b>

```yaml
---
kind: Pod
apiVersion: v1
metadata:
    name: podpoc
spec:
    containers:
        - name: c00
          image: ubuntu
          command:
              [
                  '/bin/bash',
                  '-c',
                  'while true; do echo Hello-Sp; sleep 5 ; done',
              ]
    restartPolicy: Never # Defaults to Always
```

**commands to run on above manifest -** <br>
-> :wq <br>
-> kubectl apply -f pod1.yml <br>
o/p -> pod/podpoc created <br>

**where exactly pod is running** <br>
kubectl get pods -o wide

**details info about pod** <br>
kubectl describe pod podname <br>
or <br>
kubectl describe pod/podname <br>

**running container log (1 container in a POD )** <br>
kubectl log -f podname

**running container log (2 or more container in a single POD )** <br>
kubectl log -f podname -c containerName

**delete pod** <br>
kubectl delete pod podname

# Annotations in manifest file

Annotations - extra information

```yaml
---
kind: Pod
apiVersion: v1
metadata:
    name: podpoc2
    annotations:
        description: Message What ever we want
spec:
    containers:
        - name: c00
          image: ubuntu
          command:
              [
                  '/bin/bash',
                  '-c',
                  'while true; do echo Hello-Sp; sleep 5 ; done',
              ]
    restartPolicy: Never # Defaults to Always
```

**commands to run above manifest** - <br>
-> :wq <br>
-> kubectl apply -f manifestfilename.yml <br>
o/p -> pod/podpoc2 created <br>

-> kubectl describe pod podname

# MULTI CONTAINER POD ENVIRONMENT

vi multicontainerpod.yml

```yml
kind: Pod
apiVersion: v1
metadata:
    name: podpoc3
spec:
    containers:
        - name: c00
          image: ubuntu
          command:
              ['/bin/bash', '-c', 'while true; do echo K8s; sleep 5 ; done']
        - name: c01
          image: ubuntu
          command:
              ['/bin/bash', '-c', 'while true; do echo sp-dev; sleep 5 ; done']
```

cmds to run above manifest <br>
-> :wq <br>
-> kubectl apply -f multicontainerpod.yml <br>
-> kubectl get pods <br>

go inside container <br>
kubectl exec podname -it -c containerName cmd <br>
kubectl exec podpoc3 -it -c c01 --/bin/bash

# POD ENVIRONMENT VARIABLES

podenv.yml

```yaml
kind: Pod
apiVersion: v1
metadata:
    name: environments
spec:
    containers:
        - name: c00
          image: ubuntu
          command:
              [
                  '/bin/bash',
                  '-c',
                  'while true; do echo Hello-sp; sleep 5 ; done',
              ]
          env: # List of environment variables to be used inside the pod
               - name: MYNAME
                 value: SPDEV
```

cmds to run above manifest <br>
-> :wq <br>
-> kubectl apply -f podenv.yml <br>
-> kubectl get pods <br>
-> kubectl exec environments -it -- /bin/bash <br>
echo $MYNAME <br>
o/p - SPDEV

# POD WITH PORTS (exposing ports)

**httpd.yaml**

```yaml
kind: Pod
apiVersion: v1
metadata:
    name: httpdpod
spec:
    containers:
        - name: c00
          image: httpd
          ports:
              - containerPort: 80
```

cmds to run above manifest <br>
-> :wq <br>
-> kubectl apply -f httpd.yaml <br>
-> kubectl get pods <br>
-> kubectl get pods -o wide <br>
o/p - get pod ip <br>
-> curl podIp:80 <br>
// can we access the service or not

-> kubectl delete -f podports.yaml <br>

# Labels & Selectors

1. Labels are the mechanism used to organise kubernetes objects.
2. Label is a predefined key=value pair without any predefined meaning that can be attached to the objects.
3. Labels are similar to tags in the AWS or git where we use a name for quick reference.
4. We are free to choose labels as we need it to refer an environment, which is used for dev or testing or production.
   Refer a product group like Department A, Department B.
5. Multiple labels can be attached to a single object.
6. We write labels in side metadata in manifest file.

vi labelinpod.yml

```yaml
kind: Pod
apiVersion: v1
metadata:
    name: labelpod
    labels:
        #     we can have any labels & any number as we want
        env: development
        class: pods
        res: Tg
        ami: mastering k8s
spec:
    containers:
        - name: c00
          image: ubuntu
          command:
              [
                  '/bin/bash',
                  '-c',
                  'while true; do echo Hello-k8s; sleep 5 ; done',
              ]
```

cmds to run above manifest <br>
-> :wq (get out from vi editor) <br>
-> kubectl apply -f labelinpod.yml <br>

-> kubectl get pods

**Searching labels :** <br>
kubectl get object --show-labels <br>
E.g. - <br>
kubectl get pod --show-labels <br>
kubectl get node --show-labels <br>

## adding labels to existing pods/object (imperative method)

kubectl labels ObjectType ObjectName labelKey=labelValue <br>
kubectl labels pod podname labelKey=labelValue <br>
kubectl labels node nodeName labelKey=labelValue <br>

e.g. kubectl labels pod podpoc3 name=httppod

**see added label**
kubectl get pod --show-labels

**selector** <br>
**Query list of pods matching a label** <br>
**syntax :** kubectl get pods -l labelKey=labelValue <br>
**eg :** kubectl get pods -l name=httppod <br>
**o/p :** List of pods with httppod label <br>

**Query list of pods not matching a label** <br>
**syntax :** kubectl get pods -l labelKey!=labelValue <br>
**eg :** kubectl get pods -l name!=httppod <br>
**o/p :** List of pods whose label is not httppod <br>

**deleting pod with label** <br>
deleting pod whose label is not matching <br>
**syntax :** kubelet delete pod -l labelKey!=labelValue <br>
**eg :** kubelet delete pod -l name!=httppod <br>
**o/p :** delete all the pod without httppod label <br>

**deleting pod whose label is matching**  
**syntax :** kubelet delete pod -l labelKey=labelValue <br>
**eg :** kubelet delete pod -l name=httppod <br>
**o/p :** delete all the pod with httppod label <br>

getting pods <br>
kubectl get pods

## Labels-Selectors

### selecting PODs

1. Unlike name/UIDs, labels do not provide uniqueness, as in general. As we can expect many objects to carry the same
   label.
2. One labels are attached to an object, we would need filters to narrow down & these filters area called as
   label-selectors.
3. The api currently support 2 types of selectors
    1. Equality Based
    2. Set based
4. A label selector can be made of mulitple requirement which are comma-seperated.

**selectors**

1. Equality Based (=,!=)
    1. kubectl get pods -l labelKey=labelValue
    2. kubectl get pods -l labelKey!=labelValue
2. Set based (in, notin & exists)
    1. labelKey in (label1,label2) -> get Objects with any of the labels
    2. labelKey not in (label1,label2) -> get Objects who having any of the labels
    3. labelKey exists (label,label2) -> where even these label exists
    4. kubernetes supports set based selectors i.e. match multiple values
    5. E.g. fo set based selectors
        1. kubectl get pods -l 'env in (development,testing)'
        2. kubectl get pods -l 'env not in (development,testing)'
        3. kubelet get pods -l labelKey=labelValue,labelKey=labelValue
           o/p - get the pods with both the label matching .

## Node Selectors

When we apply our manifest, the desired action will be communicated to ControlManager via ApiServer, ControlManager will
take the help of KubeScheduler inorder to meet actual state. KubeScheduler by communicating to Kubelet will try to find
our appropriate worker node for the pod creating fom our cluster. But in some circumstances we want our POD to get
created in a specific worker node in that scenario we should we Node selectors.

### Selecting Nodes

We need to label the node. <br>
We can use node selector to specify the pod run only on specific nodes(pod configuration).

**kubectl get nodes**

**adding label to node** <br>
kubectl label nodes nameofTheNode[ip-ipaddress] labelKey=labelValue <br>
kubectl label nodes nameofTheNode[ip-ipaddress] hardware=t2.medium

**vi specificnode.yaml**

```yaml
kind: Pod
apiVersion: v1
metadata:
    name: nodelabels
    labels:
        env: development
spec:
    containers:
        - name: c00
          image: ubuntu
          command:
              [
                  '/bin/bash',
                  '-c',
                  'while true; do echo Hello-Bhupinder; sleep 5 ; done',
              ]
    nodeSelector:
        hardware: t2-medium
```

:wq (get out of vi editor)<br>
kubectl apply -f specificnode.yaml <br>
kubectl get pods <br>

# Scaling & Replication

1. Kubernetes was designed to orchestrate multiple containers & replication.
2. With multiple containers/replication we get several advantages
    1. **Reliability** - By having multiple versions of an application, we prevent problems in case one or more fails.
    2. **Load balancing** - With multiple versions of containers enables us to distribute network traffic to different
       pods/nodes to prevent overloading.
    3. **Scaling** - When load does become too much for a number of existing instances kubernetes enables us to easily
       scale up our application, ny adding additional required instances.
    4. **Rolling update** - Update to a service by replacing pods one by one.

## ReplicationController

1. A ReplicationController is an object that enables us to easily create multiple pods, then it make sure that number of
   pods always exists.
2. If a pod created using ReplicationController will be automatically replaced if they does crash, failed or terminated.
3. ReplicationController is recommended if we just want to make sure 1 pod is always running, even after system reboots.
4. We can run the ReplicationController with 1 replica & the ReplicationController will make sure the POD is always
   running.

kind: ReplicationController (kind of object) <br>
kind: pod (want a simplepod) <br>
kind: ReplicationController (pod should be created by ReplicationController)

**replica-rc.yaml**

```yaml
kind: ReplicationController #this defines to create the object of Replication type
apiVersion: v1
metadata:
    name: spdev # name of ReplicationController objectNumeronym
    selector: # tells the controller which pods belongs to this ReplicationController (based on selector label)
        myname: spdev # selector label
    template: # this is template to launch a new pod (POD template)
        metadata:
            name: testpod6
            labels:
                myname: Bhupinder # selector values must match the label value specified in the template.
        spec:
            containers:
                - name: c00
                  image: ubuntu
                  command:
                      [
                          '/bin/bash',
                          '-c',
                          'while true; do echo Hello-devops; sleep 5 ; done',
                      ]
```

:wq <br>
kubectl apply -f replica-rc.yaml

now we won't use pod, we will be using rc(ReplicationController) <br>
kubectl get rc (get the ReplicationController) <br>
kubelet describe rc myreplica

kubectl get pods //get all the running pod <br>
kubectl delete pod podname //delete a pod to check <br>
kubectl get pods // we will get same number of pods (created a new one) (desied state will be maintained)

### Scaling ReplicationController

up - <br>
kubectl scale --replicas=NumberOfReplicatSet rc -l labelKey=labelValue <br>
kubectl scale --replicas=8 rc -l myname=spdev <br>

to check- <br>
kubectl get pods

down - <br>
kubectl scale --replicas=NumberOfReplicatSet rc -l labelKey=labelValue <br>
kubectl scale --replicas=1 rc -l myname=spdev

to check- <br>
kubectl get pods

As we delete podd it will create new. So inorder to stop we need to delete file. <br>
kubectl delete -f manifest.yaml <br>
kubectl delete -f replica-rc.yaml <br>

## ReplicaSet

1. ReplicaSet is next-gen of ReplicationController.
2. The ReplicationController only supports equality-based selector where the ReplicaSet supports set-based selector i.e.
   filling according to set of values.
3. ReplicaSet rather than the Replication controller is used by other objects like deployment.

**vi myrs.yml**

```yaml
kind: ReplicaSet
apiVersion: apps/v1
metadata:
    name: myrs
spec:
    replicas: 2
    selector:
        matchExpressions: # these must match the labels
            - {
                  key: myname,
                  operator: In,
                  values: [Bhupinder, Bupinder, Bhopendra],
              }
            - { key: env, operator: NotIn, values: [production] }
    template:
        metadata:
            name: testpod7
            labels:
                myname: Bhupinder
        spec:
            containers:
                - name: c00
                  image: ubuntu
                  command:
                      [
                          '/bin/bash',
                          '-c',
                          'while true; do echo Technical-Guftgu; sleep 5 ; done',
                      ]
```

:wq <br>
kubectl apply -f myrs.yml <br>
kubectl get rs <br>
kubectl get pods <br>

### scaling

kubectl scale --replicas=replicaNumber rs/GivenReplicaSetName <br>
kubectl scale --replicas=1 rs/myrs

# Deployment & Rollback Object in Kubernetes

1. Replication Controllers & ReplicaSet is not able to update & rollback apps in the cluster.
2. A Deployment Object acts as a supervisor for pods, giving us fine-grained control over how & when a new pod is
   rolled out, updated or rolled back to a previous state.
3. When using deployment object, we first define the state of the app, then k8s cluster schedules mentioned application
   instance onto specific individual nodes.
4. A deployment provides declarative updates for pods & ReplicaSet.
5. K8s then monitors, if the node hosting an instance goes down or pod is deleted the deployment controller replaces it.
6. This provides self-healing mechanism to address machine failure or maintenance.

## Use case of deployment Object

1. Create a deployment to roll out a ReplicaSet. ReplicaSet creates PODs in the background. Check the status of rollout
   to see if it succeeds or not.
2. Declare the new state of the PODS
    1. By Updating the PodTemplateSpec of the deployment, a new ReplicaSet is created & the Deployment Object manages
       moving the PODs from the Old ReplicaSet to the new one at a controlled rate.
    2. Each new ReplicaSet updates the revision of the Deployment.
3. Rollback to an earlier Deployment revision -
    1. If the Current state of the Deployment is not stable each rollback updates the revision of the Deployment.
4. Scale up the Deployment to facilitates more load.
5. Pause the Deployment to apply multiple fixes to its PodTemplateSpec & then resume it to start a new rollout.
6. Cleanup older ReplicaSet that you don't need anymore.
7. If there are problems in the deployment, kubernetes will automatically roll back to the previous version, however we
   can also explicitly rollback to a specific revision, as in our case to Revision1(the oiginal pod version).
8. We can roll back to a specific version by specifying it with `--to-revision`. <br>
   kubectl rollout undo deployment/objectName --to-revision=2  
   e.g. previous version <br>
   kubectl rollout undo deployment/objectName --to-revision=2 /previous version
9. `NOTE: The name of the ReplicaSet is alway formatted as [deployment-name]-[random-String]`
10. Kubectl get deploy
    To inspect the deployment in cluster, the following field are display.
    1. NAME - List the names of the deployments in the namespace.
    2. READY - Display how many replicas of the application are available to users. If follows the pattern
       ready/desired.
    3. UP-TO-DATE - Display the number of replicas that have been updated to achieve the desired state.
    4. AVAILABLE - Displays how many replicas of the application are available to your users.
    5. AGE - Display the amount of time that the application has been running.

Deployment -> ReplicaSet -> POD

**deployment-rc.yml**

```yaml
kind: Deployment
apiVersion: apps/v1
metadata:
    name: mydeployments
spec:
    replicas: 2
    selector:
        matchLabels:
            name: deployment
    template:
        metadata:
            name: testpod
            labels:
                name: deployment
        spec:
            containers:
                - name: c00
                  image: ubuntu
                  command:
                      [
                          '/bin/bash',
                          '-c',
                          'while true; do echo spdev; sleep 5; done',
                      ]
```

:wq <br>
kubectl apply -f deployment-rc.yml

#### Deployment useful commands

1. To check deployment was created or not - kubectl get deploy
2. To check how deployment creates ReplicaSet & PODs -
   kubectl describe objectType objectName
   kubectl describe deploy mydeployments
3. ReplicaSet info = kubectl get rs
4. To scale up or scale down
   kubectl scale --replicas=number objecttype objectname
   kubectl scale --replicas=1 deploy mydeployments
   kubectl scale --replicas=5 deploy mydeployments
5. To check, what is running inside container - kubectl logs -f <podname>
6. Rollback commands
    1. kubectl rollout status objectType objectName
       kubectl rollout status deploy mydeployments
    2. kubectl rollout history objectType objectName
       kubectl rollout history deploy mydeployments
    3. kubectl rollout undo objectType objectName (go back 1 revision back)
       kubectl rollout undo deploy mydeployments

#### In case of failed deployment

Deployment may get stuck trying to deploy it's newest replicaset without ever completing.
This can be due to some following factors.

1. Insufficient Quota
2. Readiness probe failure
3. Image pull error
4. Limit Range
5. Application runtime misconfiguration

# Kubernetes Networking

Kubernetes Networking addresses four concerns

1. Containers within a POD use networking to communicate via loopback(localhost (IP 127.0 0.1)).
2. Cluster Networking provides communication between different PODs.
3. The service resources lets you expose an application running in PODs to be reachable from outside the cluster.
4. We can also ue services to publish services only for consumption inside our cluster.

### Containers to Containers communication on same pod

Containers to Containers communication on same pod happens through localhost within the containers.

w.node | pod | container_001[ubuntu] | container_002[httpd:80]

container_001 will try to communicate with container_002's httpd server over port 80.

ctoc_communication.yml

```yaml
kind: Pod
apiVersion: v1
metadata:
    name: c2c #podname
spec:
    containers:
        - name: client
          image: ubuntu
          command:
              [
                  '/bin/bash',
                  '-c',
                  'while true; do echo Hello-Bhupinder; sleep 5 ; done',
              ]
        - name: server
          image: httpd
          ports:
              - containerPort: 80
```

kubectl apply -f ctoc_communication.yml <br>
kubectl get pods <br>

kubectl exec c2c -it -c client -- /bin/bash <br>
get inside the container <br>
apt update && apt install curl <br>
curl localhost:80 <br>
o/p - it works (test pass) <br>
exit [get out of the pod] <br>
kubectl delete -f ctoc_communication.yml

### Containers to Containers communication on different pod

Here we try to establish communication between two different PODs within same w.node. <br>  
w.node | pod1 | container_001[ubuntu] || pod2 | container_002[httpd:80] <br>
POD to POD communication on same worker node happens through POD ip. <br>
By default port Ip will not be accessible outside the node.

nginx_pod.yml

```yaml
kind: Pod
apiVersion: v1
metadata:
    name: nginxserver #podname
spec:
    containers:
        - name: server
          image: nginx
          ports:
              - containerPort: 80
```

httpd_pod.yml

```yaml
kind: Pod
apiVersion: v1
metadata:
    name: httpd #podname
spec:
    containers:
        - name: httpdC
          image: httpd
          ports:
              - containerPort: 80
```

kubectl apply -f nginx_pod.yml
kubectl apply -f httpd_pod.yml

check communication between pods

kubectl get pods
kubectl gets pods -o wide

curl httpdCip:80
curl serverCip:80

### why we need services

Each pod gets its own IP address, however in a deployment, the set of PODs running in one moment in time could be
different from the set of PODs running that application a moment later.

In simple words -
PODs gets IpAddress. And PODs are volatile.
If a container is running & we are accessing with later on that POD being replaced by new we will get a new IP. Which
incur problem.

What is the problem? <br>
If some set of PODs (used by 'backends') provides functionality being replaced by other new PODs, it will be
inconvenient for the accessors to change ip again and again inorder to access.

Here Service object provide the solution.

## Kubernetes Service

1. When using ResourceController, PODs are terminated & created during scaling or replication operation.
2. When using Deployments, while updating the image version the PODs are terminated & new PODs take the place of other
   PODs.
3. PODs are very dynamic i.e. they come & go on the K8s cluster & on any of the available nodes. It would be difficult
   to access the PODs as the PODs IP changes once its newly created.
4. Service Object is an logical bridge between PODs & end users, which provides virtual IP.
5. Service allows client to reliably connect to the containers running in the POD using the virtual IP.
6. The virtual IP is not an actual IP connected to a network interface, but its purpose is purely to forward traffic to
   one to more PODs.
7. Kube proxy is the one which keeps the mappings between the virtual IP & the PODs upto-date. Which queries the
   Api-server to learn about new services in the cluster.
8. Although each pod has a unique IP address, those IPs are not exposed outside the cluster.
9. Service helps to expose the virtual IP mapped to the PODs & allows application to receive traffic from outside the
   cluster.
10. Labels are used to select which are the PODs to be put under a service.
11. Creating a service will create an endpoint to access the pods/application in it.
12. Services can be exposed in different ways by specifying a type in the service spec.
    1. Cluster IP (default)
    2. NodePort
    3. LoadBalancer - Created by cloud providers that will route external traffic to every node on the Nodeport (Eg ELB
       on aws).
    4. Headless - Creates several endpoints that are used to produce DNS Records, each DNS record is bound to a POD.
13. By default, service can run only between ports 30,000 - 32767
14. The set of PODs targeted by a service is usually determined by a selectors.

### Cluster IP

virtual IP works only within the cluster.
Exposes virtual IP only reachable from within the cluster.
Mainly used to communicate between components of microservices.

vi httpd.yml

```yaml
kind: Deployment
apiVersion: apps/v1
metadata:
    name: mydeployments
spec:
    replicas: 1
    selector: # tells the controller which pods to watch/belong to
        matchLabels:
            name: deployment
    template:
        metadata:
            name: testpod1
            labels:
                name: deployment
        spec:
            containers:
                - name: c00
                  image: httpd
                  ports:
                      - containerPort: 80
```

:wq
kubectl apply -f deploy httpd.yml
kubectl get pods
kubectl get pods -o wide

curl ipOfmydeployments-randomString:80
o/p - It works

If for any chance the above pod gets deleted , ip will be change.

vi service.yml

```yaml
kind: Service # Defines to create Service type Object
apiVersion: v1
metadata:
    name: demoservice
spec:
    ports:
        - port: 80 # Containers port exposed
          targetPort: 80 # Pods port
    selector:
        name: deployment # Apply this service to any pods which has the specific label
    type: ClusterIP # Specifies the service type i.e ClusterIP or NodePort
```

:wq
kubectl apply -f service.yml

kubectl get svc [//]: # (get service)
o/p service cluster-ip

curl cluster-ip:port
o/p - it works

### NodePort

1. Make a service accessible from outside the cluster(from anywhere).
2. Exposes the service on the same port of each selected node in the cluster using NAT.

kubectl get pods //make sure it's empty

vi deployhttp.yml

```yaml
kind: Deployment
apiVersion: apps/v1
metadata:
    name: mydeployments
spec:
    replicas: 1
    selector: # tells the controller which pods to watch/belong to
        matchLabels:
            name: deployment
    template:
        metadata:
            name: testpod1
            labels:
                name: deployment
        spec:
            containers:
                - name: c00
                  image: httpd
                  ports:
                      - containerPort: 80
```

:wq
kubectl apply -f deploy deployhttp.yml
//run the httpd (pod is created)

vi svc-yml

```yaml
kind: Service # Defines to create Service type Object
apiVersion: v1
metadata:
    name: demoservice
spec:
    ports:
        - port: 80 # Containers port exposed
          targetPort: 80 # Pods port
    selector:
        name: deployment # Apply this service to any pods which has the specific label
    type: NodePort # Specifies the service type i.e. ClusterIP or NodePort
```

:wq
kubectl apply -f svc.yml
//service created

kubectl get svc

kubectl describe svc demoservice

kubectl delete -f svc.yml

# Kubernetes volumes

1. Containers are short-lived in nature.
2. All data stored inside a container is deleted if the container crashes. However kubelet will restart it with a clean
   state, which mens that it will not have any of the old data.
3. To overcome this problem, kubernetes uses volume. A volume is essentially a directory backed by a storage medium. The
   storage medium & its content are determined by the volume type.
4. In kubernetes, a volume is attached to a pod & shared among the containers of that pod.
5. The volume has the same life span as the pod & it outlives the containers of the POD this allows data to be preserved
   across container restarts.

usecase -
`wnode | pod | container1 | container1
volume -> shared across the containers
`
Volume is attached to pod, so doesn't matter the containers destroyed, always being assigned with the same volume.

## Volume Types

1. A volume types decided the properties of the directory, like size, content etc.
2. Types of volumes types are
    1. node-local types such as empty dir & hostpath
    2. File sharing type such as NFS
    3. Clod provider specifier types aws-EBS,azure-disk
    4. distributed file system as glusterfs or cephfs
    5. special purposes types such as secret, git-repo.

### 1. empty dir

`wnode |[ pod | container1 | container1
--------volume -> shared across the containers]`

vi emptydir.yml

```yaml
apiVersion: v1
kind: Pod
metadata:
    name: myvolemptydir
spec:
    containers:
        - name: c1
          image: centos
          command: ['/bin/bash', '-c', 'sleep 15000']
          volumeMounts: # Mount definition inside the container
              - name: xchange
                mountPath: '/tmp/xchange'
        - name: c2
          image: centos
          command: ['/bin/bash', '-c', 'sleep 10000']
          volumeMounts:
              - name: xchange
                mountPath: '/tmp/data'
    volumes:
        - name: xchange
          emptyDir: {}
```

:wq
kubectl apply -f emptydir.yml
kubectl get pods

kubectl exec myvolemptydir -c c1 -it -- /bin/bash
//inside the contaier c1
cd /tmp
cd xchange/
cat "mounted" >> file.txt

kubectl exec myvolemptydir -c c2 -it -- /bin/bash
//inside the contaier c2
cd /tmp
cd xchange/
ls
o/p - we should see file.txt

TODO:s - pod-2 containers - 2 diff volumes

### hostpath

`wnode |[ pod | container1 | container1
--------volume -> shared across the containers & host]`

1. Use this when we want to access the content of a pod/container from hostmanchine.
2. A hostpath volume mounts a file or directory from the host(worker node's) filesystem into the pod.

vi hostpath.yml

```yaml
apiVersion: v1
kind: Pod
metadata:
    name: myvolhostpath
spec:
    containers:
        - image: centos
          name: testc
          command: ['/bin/bash', '-c', 'sleep 15000']
          volumeMounts:
              - mountPath: /tmp/hostpath
                name: testvolume
    volumes:
        - name: testvolume
          hostPath:
              path: /tmp/data
```

:wq
kubectl apply -f hostpath.yml
kubectl get pods

in host
ls /tmp

kubectl get pods
o/p - myvolhostpath
kubectl exec myvolhostpath -it -- /bin/bash
cd tmp/hostpath
echo "hello" > text1.txt

kubectl exec myvolhostpath -- ls /tmp/hostpath
cat text1.txt

check on host mounted dir

# Persistent Volume

# Namespaces and Resource Quota in Kubernetes

1. We can name our k8s object, but if many are using the cluster then it would be difficult for managing.
2. A namespace is a group of related elements that each have a unique or identifier namespace is used to uniqely
   identify one or more names from other similar names of different objects, groups or the namespace in general
3. Kubernetes namespaces help different projects, teams or customers to share a kubernetes cluster & providers

-   A scope of every names
-   A mechanism to attach authorization & policy to a subsection of the cluster.

kubelet get pods -o wide

wide - default namespace

## Namespace

1. default, a kubernetes cluster will instantiate a default namespace when provisioning the cluster to hold the default
   set of PODs, Services & Deployments used by the cluster.
2. We can use `resoruce quota` on specifying how many resoruces each namespace can use.
3. Most kubernetes resources(e.g. PODs, Services, ReplicationControllers & others) are in same namespaces & low-level
   resources such as `nodes` & `persistence-volume` are not in any namespace.
4. Namespaces are intended for use in environments with many users spread across multiple teams or projects for cluster
   with a few to tens of users, we should not need to create or think about namespace at all.

### Create a new namespaces

Let's assume we have shared k8s cluster for Dev & production use case

1. The dev team would like to maintain a aspace in the cluster where they can get a view on the list of PODs, Services,
   Deployments they use to build and run their applications in this no restriction are put on who can or not modify
   resources to enable aglie development.
2. For production team we can enforce strict procedure on who can or cannor manipulate the set of pods,services &
   deployment.

vi namespace.yaml

```yaml
apiVersion: v1
kind: Namespace
metadata:
    name: dev
    labels:
        name: dev
```

kubectl get pods
kubectl get pods -n namespace

kubectl get namespace

changing default namespace

-   kubectl config set-context $(kubectl config current-context) --namespace=ourNamespaceName

which is the current default namespace
kubectl config view | grep namespace:

kubectl apply -f namespace.yaml
kubectl get namespace we will get own added namespace

vi pod.yml

```yaml
kind: Pod
apiVersion: v1
metadata:
    name: testpod
spec:
    containers:
        - name: c00
          image: ubuntu
          command:
              ['/bin/bash', '-c', 'while true; do echo spdev; sleep 5 ; done']
    restartPolicy: Never
```

:wq
kubectl apply -f pod.yaml -n nameSpace

kubectl get pods

kubectl get pods -n namespace

## Resource Quota in Kubernetes

1. A pod in kubernetes will run with no limit on CPU & memory
2. We can optionally specify how much CPU & memory(RAM) each container needs.
3. Scheduler decides about which nodes to place PODs, only if Node has enough CPU resources available to satisfy the POD
   cpu request.
4. CPU is specified in units of cores & memory is specified in units of Bytes.
5. Two types of constraints can be set of each resource type Request & limits.
    1. A Request is the amount of that resources that the system will guarantee for the container & kubernetes will use
       this value to decide on which node to place the POD.
    2. A limit is the max amount of resources that kubernetes will allow the containers to use in the case that request
       is not set for a containers, it defaults to limits. If limit is not set then if default is 0(unlimited).
    3. CPU values as specified in millicpu & memory in MB.
6. Kubernetes cluster can be divided into namespaces if a container is created in a namespace that has a default CPU
   limit & the container doesn't specify its own CPU limit, then the container is assigned the default CPU limit.
7. Namespaces can be assigned resource quota objects, this will limit the amount of usage allowed to the Objects in that
   namespace.
    1. Compute
    2. Memory
    3. Storage
8. There are 2 restriction that a resource quota imposes on a namespace.
    1. Every container that runs in the namespaces must have its own CPU limit.
    2. The total amount of CPY used by all containers in the namespace must not exceed a specified limit.

**practical 1**

vi podresources.yml

```yaml
apiVersion: v1
kind: Pod
metadata:
    name: resources
spec:
    containers:
        - name: resource
          image: centos
          command:
              ['/bin/bash', '-c', 'while true; do echo spdev; sleep 5 ; done']
          resources:
              requests:
                  memory: '64Mi'
                  cpu: '100m'
              limits:
                  memory: '128Mi'
                  cpu: '200m'
```

:wq
kubectl apply -f podresources.yml
kubectl get pods resources //(podname)

kubectl delete pod -f podresources.yml

**practical 2**
vi resorucequota.yml

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
    name: myquota
spec:
    hard:
        limits.cpu: '400m'
        limits.memory: '400Mi'
        requests.cpu: '200m'
        requests.memory: '200Mi'
```

:wq
kubectl apply -f resorucequota.yml

vi pod.yml

```yaml
kind: Deployment
apiVersion: apps/v1
metadata:
    name: deployments
spec:
    replicas: 3
    selector:
        matchLabels:
            objtype: deployment
    template:
        metadata:
            name: testpod8
            labels:
                objtype: deployment
        spec:
            containers:
                - name: c00
                  image: ubuntu
                  command:
                      [
                          '/bin/bash',
                          '-c',
                          'while true; do echo Technical-Guftgu; sleep 5 ; done',
                      ]
                  resources:
                      requests:
                          cpu: '200m'
```

:wq
kubectl apply -f pod.yml

kubectl get deploy

it should be failed we ran out of quota.

delete the everythings

**practical 3**
vi limitrange.yml

```yaml
apiVersion: v1
kind: LimitRange
metadata:
    name: cpu-limit-range
spec:
    limits:
        - default:
              cpu: 1
          defaultRequest:
              cpu: 0.5
          type: Container
```

:wq
kubectl apply -f limitrange.yml

vi pod.yml

```yaml
kind: Deployment
apiVersion: apps/v1
metadata:
    name: deployments
spec:
    replicas: 3
    selector:
        matchLabels:
            objtype: deployment
    template:
        metadata:
            name: testpod8
            labels:
                objtype: deployment
        spec:
            containers:
                - name: c00
                  image: ubuntu
                  command:
                      [
                          '/bin/bash',
                          '-c',
                          'while true; do echo Technical-Guftgu; sleep 5 ; done',
                      ]
                  resources:
                      requests:
                          cpu: '200m'
```

:wq
kubectl apply -f pod.yml
