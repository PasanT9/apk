#!/bin/bash
pods=$(kubectl get pods --selector=app.kubernetes.io/release=$APK_RELEASE_NAME -n $APK_RELEASE_NAMESPACE --no-headers | awk '{print $1 ":" $2}' | tr '\n' ','| sed 's/,$//')
ready_count=$(echo "$pods" | grep -oE '\b[0-9]+\/[0-9]+\b' | awk -F'/' '{sum += $1} END {print sum}')
pod_status=$(echo "$pods" | sed "s/$APK_RESOURCE_PREFIX-//g" | sed 's/\/[0-9]\+//g')

IFS=',' read -ra pod_status_array <<< "$pod_status"

for pod_status in "${pod_status_array[@]}"; do
    cleaned_status=$(echo "$pod_status" | sed "s/-deployment-[^:]*//")
    cleaned_status+=("$cleaned_status")
done

filtered_pod_status=$(IFS=, ; echo "${cleaned_status[*]}")

data="{\\\"$ready_count\\\", \\\"$filtered_pod_status\\\"}"

timestamp=$(date +%Y%m%d%H%M%S)

kubectl patch configmap pod-status --patch "(\"data\",\"$timestamp\",\"$data\")" -n $APK_RELEASE_NAMESPACE