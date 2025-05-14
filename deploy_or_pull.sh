#!/bin/bash

# -----------------------------
# 🔧 USER CONFIGURATION SECTION
# -----------------------------
GITHUB_USER="zartashtech"
REPO_NAME="zt-library"
DEPLOY_USER="nonroot"
WEB_ROOT="/"
BRANCH_NAME="main"
# -----------------------------
REPO_DIR="$WEB_ROOT"
GITHUB_ALIAS="github-$REPO_NAME"
sudo chown -R $DEPLOY_USER:$DEPLOY_USER "$REPO_DIR"
# -----------------------------
# 🔄 Clone or Pull Logic
# -----------------------------
if [ -d "$REPO_DIR/.git" ]; then
    echo "=== Repo exists — pulling updates from $BRANCH_NAME ==="
    sudo chown -R $DEPLOY_USER:$DEPLOY_USER "$REPO_DIR"
    sudo -u $DEPLOY_USER git -C "$REPO_DIR" pull origin "$BRANCH_NAME"
else
    echo "=== Repo not found — cloning ==="
    sudo -u $DEPLOY_USER git clone "$GITHUB_ALIAS:$GITHUB_USER/$REPO_NAME.git" "$REPO_DIR"
fi

# -----------------------------
# 🔐 Set Web Ownership
# -----------------------------
echo "=== Setting www-data ownership ==="
sudo chown -R www-data:www-data "$REPO_DIR"

echo "✅ Deployment or update completed at $REPO_DIR"
