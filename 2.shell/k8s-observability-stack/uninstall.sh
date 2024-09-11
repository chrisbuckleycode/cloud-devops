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

kubectl delete crd scrapeconfigs.monitoring.coreos.com
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusagents.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
