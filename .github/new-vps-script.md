# New VPS Setup Script

A step-by-step script to bootstrap a fresh VPS with the essential tools: Git, Docker, UFW, and OpenSSL.

> **Tested on:** Ubuntu 22.04 / 24.04 LTS  
> **Run as:** `root` or a user with `sudo` privileges

---

## 1. Update the System

Always start with a full system update before installing anything.

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. Install Git

```bash
sudo apt install -y git

# Verify
git --version
```

---

## 3. Install Docker

```bash
# Install dependencies
sudo apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Enable and start Docker
sudo systemctl enable docker
sudo systemctl start docker

# (Optional) Run Docker without sudo
sudo usermod -aG docker $USER

# Verify
docker --version
docker compose version
```

> **Note:** Log out and back in (or run `newgrp docker`) for the group change to take effect.

---

## 4. Install UFW (Firewall)

```bash
sudo apt install -y ufw

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH (do this BEFORE enabling UFW or you'll lock yourself out)
sudo ufw allow ssh        # port 22
sudo ufw allow 80/tcp     # HTTP
sudo ufw allow 443/tcp    # HTTPS

# Enable UFW
sudo ufw enable

# Verify
sudo ufw status verbose
```

> ⚠️ **Always allow SSH before enabling UFW**, otherwise you will lose access to your VPS.

---

## 5. Install OpenSSL

OpenSSL is usually pre-installed, but this ensures you have the latest version.

```bash
sudo apt install -y openssl

# Verify
openssl version
```

### Generate a Self-Signed Certificate (Optional)

If you need a quick SSL certificate for testing (e.g., for Nginx):

```bash
sudo mkdir -p /etc/nginx/ssl

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/nginx/ssl/key.pem \
  -out /etc/nginx/ssl/cert.pem \
  -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
```

---

## 6. Verify Everything

```bash
echo "=== Git ===" && git --version
echo "=== Docker ===" && docker --version
echo "=== Docker Compose ===" && docker compose version
echo "=== UFW ===" && sudo ufw status
echo "=== OpenSSL ===" && openssl version
```

---

## Full One-Liner Script

Save this as `setup.sh` and run it on a fresh VPS:

```bash
#!/bin/bash
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
```

```bash
# Make it executable and run
chmod +x setup.sh
sudo ./setup.sh
```