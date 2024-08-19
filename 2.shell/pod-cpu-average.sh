#!/bin/bash
##
## FILE: pod-cpu-average.sh
##
## DESCRIPTION: Displays pod CPU statistics for a specified namespace: current CPU, running average CPU, CPU requests (if any).
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: pod-cpu-average.sh <namespace>
##

if [ -z "$1" ]
  then
    echo "Argument required: namespace"
    exit 1
fi

# Function to cleanup and exit
cleanup() {
    tput cnorm   # Show cursor
    tput rmcup   # Restore screen
    exit
}

# Trap various signals
trap cleanup EXIT SIGINT SIGTERM

NAMESPACE="$1"

declare -A cpu_sums
declare -A cpu_counts

# Function to update a single line
update_line() {
    local line=$1
    shift
    tput cup $line 0
    printf "%-15s %-15s %-15s %-15s %-25s" "$@"
}

# Save current screen and clear it
tput smcup
clear

# Hide cursor
tput civis

# Print header
echo "CPU (requests)  CPU (current)   CPU (average)   NAMESPACE       NAME"

line=1
while true; do
    pods=($(kubectl get pods --namespace=$NAMESPACE -o custom-columns=NAME:.metadata.name --no-headers))

    for pod in "${pods[@]}"; do
        cpu_requests=$(kubectl get pod $pod --namespace=$NAMESPACE -o=jsonpath='{.spec.containers[*].resources.requests.cpu}')
        cpu_current_raw=$(kubectl top pod $pod --namespace=$NAMESPACE --containers | tail -n +2 | awk '{print $3}')
        
        # Strip "m" and keep the value in millicores
        cpu_current=${cpu_current_raw::-1}
        
        # Update running sum and count for this pod
        cpu_sums[$pod]=$((${cpu_sums[$pod]:-0} + cpu_current))
        cpu_counts[$pod]=$((${cpu_counts[$pod]:-0} + 1))
        
        # Calculate running average in millicores
        cpu_average=$(echo "scale=0; ${cpu_sums[$pod]} / ${cpu_counts[$pod]}" | bc)
        
        # Format the average with "m" suffix
        cpu_average_with_unit="${cpu_average}m"

        update_line $line "$cpu_requests" "$cpu_current_raw" "$cpu_average_with_unit" "$NAMESPACE" "$pod"
        ((line++))
    done

    # Reset line counter
    line=1
    
    # Move cursor to the top-left corner
    tput cup 0 0
    
    sleep 5
done
