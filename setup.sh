#!/bin/bash
# This script is intended to be run on a fresh Ubuntu 22.04 server to set up a basic environment with Git, Docker, UFW, and OpenSSL.

# HOW TO RUN: To run this script, save it as setup.sh, give it execute permissions with chmod +x setup.sh, and then run it with sudo ./setup.sh.

set -e

echo ">>> Updating system..."
apt update && apt upgrade -y

echo ">>> Installing Git..."
apt install -y git

echo ">>> Installing Docker..."
apt install -y ca-certificates curl gnupg lsb-release
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable docker
systemctl start docker

echo ">>> Installing UFW..."
apt install -y ufw
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 80/tcp
ufw allow 443/tcp
ufw --force enable

echo ">>> Installing OpenSSL..."
apt install -y openssl

echo ""
echo "✅ All done! Versions installed:"
git --version
docker --version
docker compose version
ufw version
openssl version