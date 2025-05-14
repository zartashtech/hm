#!/bin/bash

# -----------------------------
# 🔧 USER CONFIGURATION SECTION
# -----------------------------
GITHUB_USER="zartashtech"
REPO_NAME="tms"
DEPLOY_USER="nonroot"
# -----------------------------
SSH_KEY_NAME="${REPO_NAME}_key"
SSH_DIR="/home/$DEPLOY_USER/.ssh"
SSH_KEY_PATH="$SSH_DIR/$SSH_KEY_NAME"
SSH_CONFIG="$SSH_DIR/config"
GITHUB_ALIAS="github-$REPO_NAME"

# -----------------------------
# ✅ Git Installation
# -----------------------------
echo "=== [1] Installing Git if not installed ==="
if ! command -v git &> /dev/null; then
    sudo apt update && sudo apt install git -y
else
    echo "Git is already installed."
fi

# -----------------------------
# 🔐 SSH Key Generation
# -----------------------------
echo "=== [2] Creating SSH key if not present ==="
if [ ! -f "$SSH_KEY_PATH" ]; then
    sudo -u $DEPLOY_USER ssh-keygen -t ed25519 -C "server-deploy-key" -f "$SSH_KEY_PATH" -N ""
    echo ""
    echo "=== [3] ADD THIS SSH KEY TO GITHUB → Settings → Deploy Keys ==="
    echo ""
    sudo cat "${SSH_KEY_PATH}.pub"
    echo ""
    echo "Go to: https://github.com/$GITHUB_USER/$REPO_NAME/settings/keys"
    echo "✅ Allow read access (check the box)"
    read -p "📌 Press [Enter] after adding the key to GitHub..."
else
    echo "SSH key already exists at $SSH_KEY_PATH"
fi

# -----------------------------
# ⚙️ SSH Config Setup
# -----------------------------
echo "=== [4] Setting up SSH config ==="
sudo -u $DEPLOY_USER mkdir -p "$SSH_DIR"
if ! sudo grep -q "$GITHUB_ALIAS" "$SSH_CONFIG" 2>/dev/null; then
    echo -e "\nHost $GITHUB_ALIAS\n  HostName github.com\n  User git\n  IdentityFile $SSH_KEY_PATH" | sudo tee -a "$SSH_CONFIG" > /dev/null
fi

# -----------------------------
# 🔐 SSH Permissions Fix
# -----------------------------
echo "=== [5] Fixing SSH permissions ==="
sudo chown -R $DEPLOY_USER:$DEPLOY_USER "$SSH_DIR"
sudo chmod 700 "$SSH_DIR"
sudo chmod 600 "$SSH_CONFIG"
sudo chmod 600 "$SSH_KEY_PATH"
sudo chmod 644 "${SSH_KEY_PATH}.pub"

# -----------------------------
# 🧪 Test Connection
# -----------------------------
echo "=== [6] Testing GitHub SSH connection ==="
sudo -u $DEPLOY_USER ssh -T "$GITHUB_ALIAS"

echo "✅ GitHub setup completed successfully."
