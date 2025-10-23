# SSH Deployment Guide

Quick guide for setting up your personal notes server via SSH through Tailscale.

## 🔧 Prerequisites

1. **Tailscale** configured on both machines
2. **SSH access** to your Unraid server
3. **Docker** installed on the server
4. **Git** installed on the server

## 🚀 Quick Setup

### 1. SSH into Your Server

```bash
# Connect via Tailscale IP
ssh user@100.x.x.x  # Your Tailscale IP

# Or if you have it in your SSH config
ssh unraid-server
```

### 2. Run the Setup Script

```bash
# Download and run the setup script
curl -sSL https://raw.githubusercontent.com/asbor/boroy-docs/main/setup-server.sh | bash

# Or clone and run manually
git clone https://github.com/asbor/boroy-docs.git
cd boroy-docs
./setup-server.sh
```

### 3. Access Your Notes

- **Local access**: `http://SERVER-IP:8080`
- **Tailscale access**: `http://TAILSCALE-IP:8080`

## 🔄 CI/CD Setup (Optional)

To enable automated deployments when you push to GitHub:

### 1. Generate SSH Key on Server

```bash
# On your server
ssh-keygen -t ed25519 -C "github-actions" -f ~/.ssh/github-actions
cat ~/.ssh/github-actions.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/github-actions  # Copy this private key
```

### 2. Add GitHub Secrets

Go to your repository settings → Secrets and variables → Actions:

- `SERVER_HOST`: Your Tailscale IP (e.g., `100.x.x.x`)
- `SERVER_USER`: Your SSH username
- `SERVER_SSH_KEY`: The private key from step 1
- `SERVER_PORT`: SSH port (usually `22`)
- `NOTES_PATH`: Path to notes (e.g., `/home/notes/boroy-docs`)

### 3. Test Deployment

Push a change to your `docs/` folder and watch the GitHub Actions deploy automatically!

## 📁 Directory Structure on Server

```
/home/notes/boroy-docs/           # Main notes directory
├── docs/                         # Your markdown files
├── docker-compose.prod.yml       # Production Docker setup
├── mkdocs.yml                    # Site configuration
├── .env                          # Local environment config
└── docker-compose.override.yml   # Local customizations

/home/backups/notes/              # Automated backups
├── notes-backup-20251023.tar.gz
└── ...
```

## 🔧 Management Commands

```bash
# Navigate to notes directory
cd /home/notes/boroy-docs

# Check status
docker compose -f docker-compose.prod.yml ps

# View logs
docker compose -f docker-compose.prod.yml logs -f

# Restart services
docker compose -f docker-compose.prod.yml restart

# Update and redeploy
git pull origin main
docker compose -f docker-compose.prod.yml up -d --force-recreate

# Stop services
docker compose -f docker-compose.prod.yml down
```

## 🔒 Security Considerations

- **Firewall**: Only expose ports 8080/8000 to your Tailscale network
- **Updates**: Keep Docker images updated regularly
- **Backups**: The system auto-backs up to GitHub and creates local tar files
- **SSL**: Add certificates to `/home/notes/ssl/` and uncomment nginx SSL config

## 🎯 Sync Workflows

### From Mobile (Obsidian)
1. Use Obsidian Git plugin
2. Configure to sync to a `mobile-sync` branch
3. Set up GitHub Action to merge mobile-sync → main

### From Other Devices
1. Clone the repository
2. Edit files locally
3. Push changes - auto-deploys via GitHub Actions

### Bulk Import
```bash
# Copy existing notes
scp -r /path/to/existing/notes/* user@tailscale-ip:/home/notes/boroy-docs/docs/

# Or sync from cloud storage
rsync -av /mnt/cloud-storage/notes/ /home/notes/boroy-docs/docs/
```

## 🎉 You're Ready!

Your personal knowledge base is now running and accessible via Tailscale. Any changes you push to GitHub will automatically deploy to your server!