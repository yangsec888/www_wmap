#!/bin/bash
set -e

# Ensure directories exist and have proper permissions (only if they don't exist)
[ ! -d "/www_wmap/tmp/cache/assets" ] && mkdir -p /www_wmap/tmp/cache/assets 2>/dev/null || true
[ ! -d "/www_wmap/tmp/pids" ] && mkdir -p /www_wmap/tmp/pids 2>/dev/null || true  
[ ! -d "/www_wmap/shared/tmp/pids" ] && mkdir -p /www_wmap/shared/tmp/pids 2>/dev/null || true
[ ! -d "/www_wmap/shared/log" ] && mkdir -p /www_wmap/shared/log 2>/dev/null || true

# Set proper permissions for existing directories (ignore errors)
chmod -R 755 /www_wmap/tmp 2>/dev/null || true
chmod -R 755 /www_wmap/shared/tmp 2>/dev/null || true  
chmod -R 755 /www_wmap/shared/log 2>/dev/null || true

# Fix ownership and permissions for shared data files
chmod 666 /www_wmap/shared/data/* 2>/dev/null || true
# Ensure log files in shared/data/logs have write permissions for wmap operations
chmod -R 666 /www_wmap/shared/data/logs/* 2>/dev/null || true
# Ensure wmap user owns the seed file specifically
[ -f "/www_wmap/shared/data/seed" ] && chown wmap:wmap /www_wmap/shared/data/seed 2>/dev/null || true

# Remove a potentially pre-existing server.pid for Rails.
rm -f /www_wmap/shared/tmp/pids/server.pid
rm -f /www_wmap/tmp/pids/server.pid

# Wait for database to be ready
echo "Waiting for MariaDB to be ready..."
until nc -z mariadb 3306; do
  echo "MariaDB is unavailable - sleeping"
  sleep 1
done
echo "MariaDB is ready!"

# Prepare DB (Migrate - If not? Create db & Migrate)
sh ./config/docker/prepare-db.sh

# Pre-comple app assets
sh ./config/docker/asset-pre-compile.sh

# start rails app
# sh ./config/docker/start.sh

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
