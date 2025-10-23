# Unraid Setup Guide

This guide covers Unraid-specific configuration for your personal notes documentation system.

## Container Configuration

### Auto-Start Settings

In the Unraid WebGUI:

1. Go to **Docker** tab
2. Enable **Auto-Start** for both containers:
   - `notes-kroki` - Priority: 1 (starts first)
   - `notes-docs` - Priority: 2, Wait: 10 seconds (starts after Kroki is ready)

### Health Monitoring

Both containers now include health checks:
- 🟢 **Green** = Healthy and running
- 🟡 **Yellow** = Unhealthy (check logs)
- ⚪ **White** = No health check (shouldn't happen with updated config)

You can view container health on the Docker tab in Unraid WebGUI.

## Automated Updates with User Scripts

### Installing User Scripts Plugin

1. Go to **Apps** tab
2. Search for "User Scripts"
3. Install the plugin by **Andrew Zawadzki**

### Setting Up Auto-Update Script

1. Navigate to **Settings** → **User Scripts**
2. Click **Add New Script**
3. Name it: `Update Notes Documentation`
4. Click the gear icon → **Edit Script**
5. Copy the content from `unraid/update-notes-docs.sh` into the script editor
6. Save the script
7. Set schedule:
   - **Hourly**: For frequent updates
   - **Every 15 minutes**: For very active documentation
   - **Daily**: For less frequent updates
   - **Custom cron**: `*/15 * * * *` (every 15 minutes)

### Testing the Update Script

1. Go to **Settings** → **User Scripts**
2. Find your script
3. Click **Run Script**
4. Check the output to verify it works

## Port Configuration

Current setup:
- **Port 8001**: Kroki diagram rendering service
- **Port 8090**: Documentation website

### If You Want Custom Ports

Edit `/home/notes/boroy-docs/docker-compose.prod.yml`:

```yaml
services:
  kroki:
    ports:
      - "YOUR_PORT:8000"  # Change YOUR_PORT
  
  docs:
    ports:
      - "YOUR_PORT:8000"  # Change YOUR_PORT
```

Then:
```bash
cd /home/notes/boroy-docs
docker compose -f docker-compose.prod.yml up -d --force-recreate
```

## Network Configuration

### Using Nginx Proxy Manager

If you're already using Nginx Proxy Manager (NPM):

1. Add **Proxy Host** in NPM:
   - **Domain Name**: `notes.yourdomain.com` (or local hostname)
   - **Forward Hostname/IP**: `tower.tailcc46cd.ts.net` (or Tower's IP)
   - **Forward Port**: `8090`
   - **SSL**: Enable if desired (Let's Encrypt)

2. Access via friendly URL instead of `http://tower.tailcc46cd.ts.net:8090/`

### Bridge vs Host Networking

Current setup uses **Bridge** networking (recommended):
- ✅ Isolated from host network
- ✅ Explicit port mappings
- ✅ Secure and predictable

Only use **Host** networking if you have specific requirements.

## Volume Mappings

Current mappings in docker-compose.prod.yml:

| Host Path | Container Path | Access | Purpose |
|-----------|---------------|--------|---------|
| `./docs` | `/docs/docs` | Read-Only | Documentation content |
| `./mkdocs.yml` | `/docs/mkdocs.yml` | Read-Only | Site configuration |
| `./overrides` | `/docs/overrides` | Read-Only | Theme customization |
| `notes_site` (volume) | `/docs/site` | Read-Write | Built site files |
| `kroki_cache` (volume) | `/tmp` | Read-Write | Kroki cache |

### Backup Locations

Important directories to backup:
- `/home/notes/boroy-docs/docs/` - Your personal notes
- `/home/notes/boroy-docs/mkdocs.yml` - Site configuration

Docker volumes are managed automatically by Docker.

## Troubleshooting

### Container Won't Start

1. Check logs:
   ```bash
   docker compose -f /home/notes/boroy-docs/docker-compose.prod.yml logs docs
   docker compose -f /home/notes/boroy-docs/docker-compose.prod.yml logs kroki
   ```

2. Check for port conflicts:
   ```bash
   netstat -tlnp | grep -E '8001|8090'
   ```

3. Restart Docker service in Unraid:
   - Go to **Settings** → **Docker**
   - Click **Disable Docker**
   - Wait a moment
   - Click **Enable Docker**

### Diagrams Not Rendering

1. Verify Kroki is running:
   ```bash
   curl http://localhost:8001/health
   ```

2. Check browser console (F12) for CORS or connection errors

3. Verify the Kroki URL in `docs/javascripts/kroki.js` matches your setup

### Updates Not Pulling

1. Check git status:
   ```bash
   cd /home/notes/boroy-docs
   git status
   git fetch origin
   git log --oneline origin/main ^main
   ```

2. Manually pull:
   ```bash
   cd /home/notes/boroy-docs
   git stash
   git pull
   docker compose -f docker-compose.prod.yml restart docs
   ```

## Performance Optimization

### Fast Rebuilds

The `FAST_MODE=true` environment variable is enabled, which speeds up rebuilds during development.

### Live Reload

Live reload is enabled - changes to markdown files appear automatically without restarting.

### Caching

Kroki uses a cache volume to speed up diagram rendering for frequently used diagrams.

## Security Considerations

### Tailscale Integration

Since you're using Tailscale:
- ✅ Your documentation is only accessible via your Tailscale network
- ✅ No need to expose ports to the public internet
- ✅ Built-in encryption and authentication

### Read-Only Mounts

Most volumes are mounted as read-only (`:ro`) to prevent accidental modifications.

### Regular Updates

Keep your containers updated:
```bash
cd /home/notes/boroy-docs
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

Or use Unraid's **Auto Update** feature in Docker settings.

## Advanced: Custom Domain with SSL

If you want `https://notes.yourdomain.com`:

1. Use **Nginx Proxy Manager** (you already have this)
2. Add proxy host pointing to `tower.tailcc46cd.ts.net:8090`
3. Enable SSL with Let's Encrypt
4. Update `site_url` in `mkdocs.yml`:
   ```yaml
   site_url: https://notes.yourdomain.com
   ```

## Monitoring & Maintenance

### Scheduled Tasks

Consider creating User Scripts for:
1. **Daily backup**: Backup `/home/notes/boroy-docs/docs/` to secure location
2. **Weekly cleanup**: Remove old Docker images and unused volumes
3. **Health check**: Verify services are responding

### Log Rotation

Docker handles log rotation automatically, but you can customize:
```yaml
services:
  docs:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

## Resources

- [Unraid Docker Documentation](https://docs.unraid.net/unraid-os/using-unraid-to/run-docker-containers/)
- [MkDocs Material Documentation](https://squidfunk.github.io/mkdocs-material/)
- [Kroki Documentation](https://kroki.io/)
- [Tailscale Documentation](https://tailscale.com/kb/)
