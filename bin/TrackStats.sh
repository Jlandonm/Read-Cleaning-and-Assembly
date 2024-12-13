#!/bin/bash

# Function to get total CPU time
get_total_cpu_time() {
    local cpu_info
    cpu_info=($(grep '^cpu ' /proc/stat))
    user=${cpu_info[1]}
    nice=${cpu_info[2]}
    system=${cpu_info[3]}
    idle=${cpu_info[4]}
    iowait=${cpu_info[5]}
    irq=${cpu_info[6]}
    softirq=${cpu_info[7]}
    steal=${cpu_info[8]}
    guest=${cpu_info[9]}
    total=$((user + nice + system + idle + iowait + irq + softirq + steal + guest))
    echo "$total"
}

# Function to calculate CPU usage
calculate_cpu_usage() {
    local total_start total_end total_diff idle_start idle_end idle_diff
    total_start=$1
    idle_start=$2
    total_end=$3
    idle_end=$4
    total_diff=$((total_end - total_start))
    idle_diff=$((idle_end - idle_start))
    cpu_percentage=$(echo "scale=2; 100 * (1 - ($idle_diff / $total_diff))" | bc)
    echo "$cpu_percentage"
}

# Function to calculate memory usage
calculate_memory_usage() {
    local total_mem free_mem buffers cached_mem used_mem
    read -r total_mem free_mem buffers cached_mem <<<$(awk '/MemTotal/ {total=$2} /MemFree/ {free=$2} /Buffers/ {buffers=$2} /Cached/ {cached=$2} END {print total, free, buffers, cached}' /proc/meminfo)
    used_mem=$((total_mem - free_mem - buffers - cached_mem))
    memory_percentage=$(echo "scale=2; 100 * ($used_mem / $total_mem)" | bc)
    echo "$memory_percentage"
}

# Get the absolute path of the script
script_path=$(realpath "$1")
assembler=$2
fileHeader=$3

# Get initial total and idle CPU time
total_start=$(get_total_cpu_time)
idle_start=$(grep '^cpu ' /proc/stat | awk '{print $5}')

# Get initial memory usage
memory_start=$(calculate_memory_usage)

# Get the start time
start_time=$(date +%s.%N)

# Execute the script
bash "$script_path" "$@"

# Get the end time
end_time=$(date +%s.%N)

# Get final total and idle CPU time
total_end=$(get_total_cpu_time)
idle_end=$(grep '^cpu ' /proc/stat | awk '{print $5}')

# Get final memory usage
memory_end=$(calculate_memory_usage)

# Calculate elapsed time
elapsed_time=$(echo "$end_time - $start_time" | bc)

# Calculate CPU usage
cpu_usage=$(calculate_cpu_usage "$total_start" "$idle_start" "$total_end" "$idle_end")

# Print the results
echo -e "$1\t$fileHeader\t$2\t$elapsed_time\t$cpu_usage%\t$memory_end%" >> usage.txt