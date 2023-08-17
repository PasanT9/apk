#!/bin/bash
# kubectl get pods --selector=app.kubernetes.io/release=apk-test > /var/log/pods.txt
pod_info=$(kubectl get pods --selector=app.kubernetes.io/release=apk-test)
ready_count=$(echo "$pod_info" | grep -oE '\b[0-9]+\/[0-9]+\b' | awk -F'/' '{sum += $1} END {print sum}')
echo "$ready_count" > /var/log/pods.txt