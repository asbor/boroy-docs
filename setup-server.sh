#!/bin/bash

# Personal Notes Server Setup Script
# Run this on your Unraid/server to set up the notes system

set -e

echo "🚀 Setting up Personal Notes Server..."

# Configuration
NOTES_DIR="${NOTES_DIR:-/home/notes/boroy-docs}"
BACKUP_DIR="${BACKUP_DIR:-/home/backups/notes}"
REPO_URL="https://github.com/asbor/boroy-docs.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_warning "This script should not be run as root for security reasons"
   read -p "Continue anyway? (y/N): " -n 1 -r
   echo
   if [[ ! $REPLY =~ ^[Yy]$ ]]; then
       exit 1
   fi
fi

# Check prerequisites
print_status "Checking prerequisites..."

if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed!"
    exit 1
fi

if ! command -v git &> /dev/null; then
    print_error "Git is not installed!"
    exit 1
fi

print_success "Prerequisites satisfied"

# Create directories
print_status "Creating directories..."
mkdir -p "$NOTES_DIR"
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$NOTES_DIR")/ssl"

# Clone or update repository
if [[ -d "$NOTES_DIR/.git" ]]; then
    print_status "Updating existing repository..."
    cd "$NOTES_DIR"
    git fetch origin
    git reset --hard origin/main
else
    print_status "Cloning repository..."
    git clone "$REPO_URL" "$NOTES_DIR"
    cd "$NOTES_DIR"
fi

# Set up git configuration for auto-commits
print_status "Configuring git for auto-commits..."
git config user.name "Notes Server"
git config user.email "notes@$(hostname)"

# Create environment file
print_status "Creating environment configuration..."
cat > .env << EOF
# Notes Server Configuration
NOTES_DIR=$NOTES_DIR
BACKUP_DIR=$BACKUP_DIR
SERVER_NAME=$(hostname)
TIMEZONE=$(timedatectl show --property=Timezone --value 2>/dev/null || echo "UTC")
EOF

# Set up Docker Compose override for local customizations
if [[ ! -f docker-compose.override.yml ]]; then
    print_status "Creating Docker Compose override..."
    cat > docker-compose.override.yml << EOF
# Local overrides for docker-compose.prod.yml
# Customize ports, volumes, or environment variables here
version: '3.8'

services:
  docs:
    environment:
      - TZ=${TIMEZONE:-UTC}
  
  kroki:
    environment:
      - TZ=${TIMEZONE:-UTC}
  
  # Uncomment to customize ports
  # docs:
  #   ports:
  #     - "8080:8000"  # Change first number to customize external port
  
  # kroki:
  #   ports:
  #     - "8000:8000"  # Change first number to customize external port
EOF
fi

# Pull Docker images
print_status "Pulling Docker images..."
docker compose -f docker-compose.prod.yml pull

# Start services
print_status "Starting services..."
docker compose -f docker-compose.prod.yml up -d

# Wait for services to start
print_status "Waiting for services to start..."
sleep 15

# Health check
print_status "Performing health check..."
DOCS_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 || echo "000")
KROKI_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health || echo "000")

if [[ "$DOCS_HEALTH" == "200" ]]; then
    print_success "Documentation service is running"
else
    print_warning "Documentation service may not be ready yet (HTTP $DOCS_HEALTH)"
fi

if [[ "$KROKI_HEALTH" == "200" ]]; then
    print_success "Kroki service is running"
else
    print_warning "Kroki service may not be ready yet (HTTP $KROKI_HEALTH)"
fi

# Create systemd service for auto-start (optional)
if command -v systemctl &> /dev/null; then
    print_status "Creating systemd service..."
    sudo tee /etc/systemd/system/personal-notes.service > /dev/null << EOF
[Unit]
Description=Personal Notes Documentation
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$NOTES_DIR
ExecStart=/usr/bin/docker compose -f docker-compose.prod.yml up -d
ExecStop=/usr/bin/docker compose -f docker-compose.prod.yml down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable personal-notes.service
    print_success "Systemd service created and enabled"
fi

# Display access information
echo
print_success "🎉 Personal Notes Server setup completed!"
echo
echo "📋 Access Information:"
echo "  📝 Documentation: http://$(hostname -I | awk '{print $1}'):8080"
echo "  🎨 Kroki Service: http://$(hostname -I | awk '{print $1}'):8000"
echo
echo "📁 Paths:"
echo "  📖 Notes Directory: $NOTES_DIR"
echo "  💾 Backup Directory: $BACKUP_DIR"
echo
echo "🔧 Management Commands:"
echo "  Start:   docker compose -f $NOTES_DIR/docker-compose.prod.yml up -d"
echo "  Stop:    docker compose -f $NOTES_DIR/docker-compose.prod.yml down"
echo "  Logs:    docker compose -f $NOTES_DIR/docker-compose.prod.yml logs -f"
echo "  Update:  cd $NOTES_DIR && git pull && docker compose -f docker-compose.prod.yml up -d --force-recreate"
echo
echo "💡 Next Steps:"
echo "  1. Add your markdown files to: $NOTES_DIR/docs/"
echo "  2. Customize mkdocs.yml for your preferences"
echo "  3. Set up automated backups with the included GitHub workflows"
echo "  4. Configure SSL certificates in: $(dirname "$NOTES_DIR")/ssl/"
echo

# Show running containers
print_status "Currently running containers:"
docker compose -f docker-compose.prod.yml ps