#!/bin/bash
# Unraid User Script: Auto-update personal notes documentation
# Schedule: Every 15 minutes (or as needed)
# Install via: Settings -> User Scripts plugin

REPO_PATH="/home/notes/boroy-docs"
COMPOSE_FILE="docker-compose.prod.yml"

echo "=== Updating Personal Notes Documentation ==="
echo "Time: $(date)"
echo ""

# Navigate to repository
cd "$REPO_PATH" || exit 1

# Check for remote updates
echo "Checking for updates from GitHub..."
git fetch origin main

# Compare local and remote
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "✓ Already up to date!"
    exit 0
fi

echo "Updates found! Pulling changes..."

# Stash any local changes (shouldn't happen but safety first)
git stash

# Pull latest changes
if git pull origin main; then
    echo "✓ Git pull successful"
    
    # Restart documentation service to pick up changes
    echo "Restarting documentation service..."
    docker compose -f "$COMPOSE_FILE" restart docs
    
    # Wait for service to be healthy
    sleep 5
    
    # Check status
    echo ""
    echo "=== Service Status ==="
    docker compose -f "$COMPOSE_FILE" ps
    
    echo ""
    echo "✅ Documentation updated successfully!"
    echo "Access your notes at: http://tower.tailcc46cd.ts.net:8090/your-repo/"
else
    echo "❌ Git pull failed!"
    exit 1
fi
