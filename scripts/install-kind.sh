#!/usr/bin/env bash

curl -Lo kind https://kind.sigs.k8s.io/dl/v0.8.1/kind-linux-amd64
chmod 755 kind

echo "[+] Kind Installed successfully: /usr/local/kind"

curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod 755 kubectl

echo "[+] Kubectl Installed successfully: /usr/local/kubectl"

