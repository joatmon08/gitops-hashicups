#!/bin/bash

flux bootstrap github \
--owner=joatmon08 \
--repository=gitops-hashicups \
--path=clusters/eks \
--branch=main \
--personal

kubectl apply -f clusters/eks/hashicups-source.yaml
kubectl apply -f clusters/eks/hashicups-kustomization.yaml