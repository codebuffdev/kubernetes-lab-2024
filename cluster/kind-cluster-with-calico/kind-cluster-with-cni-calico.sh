#!/bin/bash

# Define the cluster name
CLUSTER_NAME=my-cluster

# Create the kind cluster
kind create cluster --name $CLUSTER_NAME  --config kind-config.yaml

# Apply Calico CNI plugin
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

