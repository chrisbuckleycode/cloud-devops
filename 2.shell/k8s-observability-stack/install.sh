#!/bin/bash
##
## FILE: install.sh
##
## DESCRIPTION: Installs Prometheus, Grafana, Loki, Promtail to an existing Kubernetes cluster. Tested on a standard kind cluster
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: install.sh
##        
##        When finished, do a port-forward on the prometheus-grafana service (or use ingress).
##

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

kubectl create ns monitoring
helm install loki grafana/loki --values val-loki.yaml --namespace monitoring
helm install promtail grafana/promtail --values val-promtail.yaml --namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --values val-grafana.yaml --namespace monitoring

kubectl get po -n monitoring
