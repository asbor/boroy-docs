# Self-Hosted Personal Notes Documentation

This is a self-hosted personal knowledge base built with **MkDocs Material** and **Kroki** for diagram rendering. Designed to run on Unraid or any Docker-capable server.

## 🏠 Self-Hosting Setup

### Quick Start on Unraid

1. **Copy this repository** to your Unraid server
2. **Navigate to the directory** containing `docker-compose.prod.yml`
3. **Start the services**:
   ```bash
   docker compose -f docker-compose.prod.yml up -d
   ```
4. **Access your notes** at: `http://YOUR-UNRAID-IP:8080`

### Production Features

- 🔒 **Private hosting** - Your notes stay on your server
- 🔄 **Auto-restart** - Services restart automatically
- 📊 **Kroki diagrams** - Mermaid, PlantUML, and more
- 🌐 **Nginx proxy** - Optional reverse proxy for custom domains
- 💾 **Persistent storage** - Notes and cache are preserved
- 🔴 **Live reload** - See changes instantly when editing

## 📁 Directory Structure for Self-Hosting

```
/path/to/your/notes/
├── docker-compose.prod.yml    # Production Docker setup
├── nginx.conf                 # Reverse proxy config
├── docs/                      # Your markdown notes
│   ├── index.md              # Homepage
│   ├── daily-notes/          # Daily notes
│   ├── projects/             # Project documentation
│   ├── learning/             # Learning notes
│   └── personal/             # Personal knowledge
├── mkdocs.yml                # Site configuration
└── ssl/                      # SSL certificates (optional)
    ├── cert.pem
    └── key.pem
```

## 🔄 Automated Sync Workflows

### Option 1: Git-based Sync

Create a script to automatically pull updates:

```bash
#!/bin/bash
# sync-notes.sh
cd /path/to/your/notes
git pull origin main
docker compose -f docker-compose.prod.yml restart docs
```

Set up a cron job:
```bash
# Run every 15 minutes
*/15 * * * * /path/to/sync-notes.sh
```

### Option 2: File Watcher Sync

Use `inotify` to watch for file changes and auto-sync:

```bash
# Install inotify-tools
sudo apt install inotify-tools

# Watch for changes and auto-commit
inotifywait -m -r -e modify,create,delete docs/ |
while read path action file; do
    git add .
    git commit -m "Auto-sync: $action $file"
    git push origin main
done
```

### Option 3: Mobile/External Device Sync

- **Obsidian** with Git plugin
- **Notion** export automation
- **Joplin** with sync target
- **Dropbox/Google Drive** with file watcher

## 🌐 Network Configuration

### Internal Network (Unraid)
- **Documentation**: `http://unraid-ip:8080`
- **Kroki service**: `http://unraid-ip:8000`

### Custom Domain (Optional)
1. **Configure nginx** with your domain in `nginx.conf`
2. **Set up SSL** certificates in `ssl/` directory
3. **Update DNS** to point to your server
4. **Access via**: `https://notes.yourdomain.com`

### VPN Access
Access your notes securely from anywhere:
- **Tailscale** - Easy mesh VPN
- **WireGuard** - Self-hosted VPN
- **OpenVPN** - Traditional VPN setup

## 📝 Content Organization

### Suggested Structure

```
docs/
├── index.md                   # Dashboard/Homepage
├── daily/                     # Daily notes
│   ├── 2025/
│   │   ├── 01-january/
│   │   └── 02-february/
├── projects/                  # Active projects
│   ├── homelab/
│   ├── work/
│   └── personal/
├── learning/                  # Knowledge base
│   ├── programming/
│   ├── homelab/
│   └── skills/
├── references/                # Quick references
│   ├── commands/
│   ├── configs/
│   └── troubleshooting/
└── archived/                  # Completed/old content
```

## 🔧 Maintenance

### Update the Stack
```bash
# Pull latest images
docker compose -f docker-compose.prod.yml pull

# Restart with new images
docker compose -f docker-compose.prod.yml up -d
```

### Backup Your Notes
```bash
# Backup markdown files
tar -czf notes-backup-$(date +%Y%m%d).tar.gz docs/

# Backup entire repository
git bundle create backup.bundle --all
```

### Monitor Logs
```bash
# Follow all logs
docker compose -f docker-compose.prod.yml logs -f

# Specific service logs
docker compose -f docker-compose.prod.yml logs -f docs
```

## 🔐 Security Considerations

- **Network isolation** - Run behind firewall/VPN
- **Regular backups** - Automate git pushes and file backups
- **SSL encryption** - Use HTTPS for external access
- **Access control** - Consider adding authentication proxy
- **Container security** - Keep images updated

## 🎯 Next Steps

1. **Set up on Unraid** using the production compose file
2. **Organize your notes** in the `docs/` directory
3. **Configure automated sync** for your workflow
4. **Customize the theme** and navigation in `mkdocs.yml`
5. **Set up backups** and monitoring

Your personal knowledge base is now ready for self-hosting! 🚀