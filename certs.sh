#!/bin/bash

# Delete downloaded file on exit
trap 'rm -f /tmp/kubeconfig > /dev/null 2>&1' EXIT

# Download generated kubeconfig
/bin/scp -o StrictHostKeyChecking=no -i $1 root@$2:/etc/rancher/k3s/k3s.yaml /tmp/kubeconfig >/dev/null 2>&1
# Parse generated certificates
SERVER_CERT=$(grep certificate-authority-data /tmp/kubeconfig | cut -d ":" -f 2 | tr -d " ")
CLIENT_CERT=$(grep client-certificate-data /tmp/kubeconfig | cut -d ":" -f 2 | tr -d " ")
CLIENT_KEY=$(grep client-key-data /tmp/kubeconfig | cut -d ":" -f 2 | tr -d " ")
# Return JSON
OUTPUT="{\"server_cert\": \"$SERVER_CERT\", \"client_cert\": \"$CLIENT_CERT\", \"client_key\": \"$CLIENT_KEY\"}"
echo $OUTPUT