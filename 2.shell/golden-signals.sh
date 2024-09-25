#!/bin/bash
##
## FILE: golden-signals.sh
##
## DESCRIPTION: Multiple Linux metrics collection tests, nominally related to Google SRE Book's "4 Golden Signals" of monitoring.
##
## AUTHOR: Chris Buckley (github.com/chrisbuckleycode)
##
## USAGE: sudo golden-signals.sh
##

# Function to calculate average
calculate_average() {
    local sum=0
    local count=0
    for value in "$@"; do
        sum=$(echo "$sum + $value" | bc)
        ((count++))
    done
    if [ $count -eq 0 ]; then
        echo "N/A"
    else
        echo "scale=2; $sum / $count" | bc
    fi
}

echo "Collecting Four Golden Signals metrics..."

# 1. Latency
echo "1. Latency:"
ping_result=$(ping -c 5 8.8.8.8 | grep 'time=' | cut -d '=' -f 4 | cut -d ' ' -f 1)
avg_latency=$(calculate_average $ping_result)
echo "   Average ping latency to 8.8.8.8: ${avg_latency}ms"

# 2. Traffic
echo "2. Traffic:"
interfaces=$(ls /sys/class/net/)
for interface in $interfaces; do
    if [ "$interface" != "lo" ]; then
        echo "   Network traffic on $interface:"
        rx_bytes_start=$(cat /sys/class/net/$interface/statistics/rx_bytes)
        tx_bytes_start=$(cat /sys/class/net/$interface/statistics/tx_bytes)
        sleep 5
        rx_bytes_end=$(cat /sys/class/net/$interface/statistics/rx_bytes)
        tx_bytes_end=$(cat /sys/class/net/$interface/statistics/tx_bytes)

        rx_rate=$(echo "scale=2; ($rx_bytes_end - $rx_bytes_start) / 5 / 1024" | bc)
        tx_rate=$(echo "scale=2; ($tx_bytes_end - $tx_bytes_start) / 5 / 1024" | bc)

        echo "     Receive rate: ${rx_rate} KB/s"
        echo "     Transmit rate: ${tx_rate} KB/s"
    fi
done

# 3. Errors
echo "3. Errors:"
kernel_errors=$(dmesg | grep -i error | wc -l)
echo "   Kernel errors in dmesg: $kernel_errors"

if command -v journalctl &> /dev/null; then
    systemd_errors=$(journalctl -p err..alert --since "15 seconds ago" | wc -l)
    echo "   Systemd errors in the last 15 seconds: $systemd_errors"
else
    echo "   Systemd errors: N/A (journalctl not available)"
fi

# 4. Saturation
echo "4. Saturation:"
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
mem_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
disk_usage=$(df -h / | awk '/\// {print $5}' | sed 's/%//')

echo "   CPU usage: ${cpu_usage}%"
echo "   Memory usage: ${mem_usage}%"
echo "   Disk usage: ${disk_usage}%"

echo "Data collection complete."
