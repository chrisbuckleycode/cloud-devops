## FILE: pod-cpu-average.py
##
## DESCRIPTION: Displays pod CPU statistics for a specified namespace: current CPU, running average CPU, CPU requests (if any).
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: python3 pod-cpu-average.py <namespace>
##
# TODO(chrisbuckleycode): Add color inverter for recently updated values

import argparse
import time
from collections import defaultdict
from kubernetes import client, config
from tabulate import tabulate
import os

def parse_cpu_value(cpu_value):
    if isinstance(cpu_value, str):
        if cpu_value.endswith('m'):
            return int(cpu_value[:-1])
        elif cpu_value.endswith('n'):
            return int(cpu_value[:-1]) // 1_000_000  # Convert nanocores to millicores
    return int(cpu_value)

def format_cpu_value(cpu_value):
    return f"{cpu_value}m"

def get_pod_cpu_stats(namespace):
    v1 = client.CoreV1Api()
    custom = client.CustomObjectsApi()
    
    try:
        pods = v1.list_namespaced_pod(namespace).items
    except Exception as e:
        print(f"Error fetching pods: {e}")
        return []

    pod_stats = []
    for pod in pods:
        pod_name = pod.metadata.name
        cpu_request = sum(parse_cpu_value(container.resources.requests.get('cpu', '0')) 
                          for container in pod.spec.containers 
                          if container.resources and container.resources.requests)
        
        try:
            metrics = custom.list_namespaced_custom_object(
                group="metrics.k8s.io",
                version="v1beta1",
                namespace=namespace,
                plural="pods"
            )
        except Exception as e:
            print(f"Error fetching metrics: {e}")
            continue

        pod_metrics = next((item for item in metrics['items'] if item['metadata']['name'] == pod_name), None)
        if pod_metrics:
            cpu_current = sum(parse_cpu_value(container['usage']['cpu']) for container in pod_metrics['containers'])
        else:
            cpu_current = 0

        pod_stats.append({
            'namespace': namespace,
            'pod_name': pod_name,
            'cpu_requests': cpu_request,
            'cpu_current': cpu_current,
        })

    return pod_stats

def update_table(pod_stats, cpu_averages, table):
    for i, stat in enumerate(pod_stats):
        pod_name = stat['pod_name']
        cpu_average = cpu_averages[pod_name]['total'] / cpu_averages[pod_name]['count'] if cpu_averages[pod_name]['count'] > 0 else 0
        table[i] = [
            stat['namespace'],
            pod_name,
            format_cpu_value(stat['cpu_requests']),
            format_cpu_value(stat['cpu_current']),
            format_cpu_value(int(cpu_average))
        ]

def print_table(table, headers):
    os.system('cls' if os.name == 'nt' else 'clear')
    print(tabulate(table, headers=headers, tablefmt='grid'))

def main():
    parser = argparse.ArgumentParser(description='Display pod CPU statistics')
    parser.add_argument('namespace', help='Kubernetes namespace')
    args = parser.parse_args()

    config.load_kube_config()

    cpu_averages = defaultdict(lambda: {'total': 0, 'count': 0})
    headers = ['Namespace', 'Pod Name', 'CPU Requests', 'CPU Current', 'CPU Average']
    table = []

    try:
        while True:
            pod_stats = get_pod_cpu_stats(args.namespace)
            
            for stat in pod_stats:
                pod_name = stat['pod_name']
                cpu_averages[pod_name]['total'] += stat['cpu_current']
                cpu_averages[pod_name]['count'] += 1

            if not table:
                table = [[''] * len(headers) for _ in range(len(pod_stats))]

            update_table(pod_stats, cpu_averages, table)
            print_table(table, headers)
            
            time.sleep(10)
    except KeyboardInterrupt:
        print("\nExiting...")

if __name__ == "__main__":
    main()
