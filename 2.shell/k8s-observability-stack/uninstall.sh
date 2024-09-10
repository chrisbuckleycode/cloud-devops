#!/bin/bash
##
## FILE: uninstall.sh
##
## DESCRIPTION: Uninstalls Prometheus, Grafana, Loki, Promtail from a Kubernetes cluster and deletes namespace.
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: uninstall.sh
##        

helm uninstall prometheus --namespace monitoring
helm uninstall promtail --namespace monitoring
helm uninstall loki --namespace monitoring

helm repo remove prometheus-community
helm repo remove grafana

kubectl delete ns monitoring
