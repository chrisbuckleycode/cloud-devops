# Shell

## aws-s3-buckets-delete.sh
Retrieves bucket names and deletes each bucket one by one, all using AWS CLI.

## aws-eks-cluster-list.sh
For an AWS account, returns EKS clusters, their instances, types and lifecycle.

## crds-list.sh
Lists CRDs in a Kubernetes manifest.

## extract-crds.sh
Checks a Helm chart for crds to delete after de-installation

## gke-cluster-create.sh
In development...

## golden-signals.sh
Multiple Linux metrics collection tests, nominally related to Google SRE Book's "4 Golden Signals" of monitoring.

## k8s-observability-stack/
Installs Prometheus, Grafana, Loki, Promtail to an existing Kubernetes cluster. Tested on a standard kind cluster.

## load-average.sh
Monitors cpu and memory usage over a period, gets running averages without external monitoring.

## node-top.sh
Displays a node's pods, sorted by CPU usage. Similar to kubectl get nodes.

## outlier-find.sh
Find outlier processes and display their statistics.

## pod-cpu-average.sh
Displays pod CPU statistics for a specified namespace: current CPU, running average CPU, CPU requests (if any).

## proc-loop-sample.sh
Loops over "status" file in each process directory in /proc, returns table sorted by requested stat e.g., "VmPeak", "VmSize", "VmRSS", etc.

## rdevops.sh
Searches r/devops on Reddit, from the command line.

## rkube.sh
Searches r/kubernetes on Reddit, from the command line.

## sum-kubectl-top-pod.sh
Runs "kubectl top pod -A" and sums the CPU and Memory columns.

## terraform-import-block-s3-buckets.sh
Retrieves bucket names using AWS CLI, then generates Terraform files required for resource import.

## ubuntu22-bootstrapper.sh
One-by-one installer tool for new Ubuntu 22 server.

## zabbix-agent-install.sh
Installs Zabbix agent2 on Ubuntu 22.04.

## zabbix-server-install.sh
Installs Zabbix Server on Ubuntu 22.04, choices: Apache web server, MySQL database.

