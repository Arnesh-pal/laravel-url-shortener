#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- START OF FIX ---
# Create and set permissions for storage and cache directories.
# This runs every time the container starts.
cd /var/www/html
mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache
chown -R www-data:www-data storage bootstrap/cache
# --- END OF FIX ---

# Run Laravel database migrations
php artisan migrate --force

# Run Laravel optimization commands
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start the main server process (this runs Apache and PHP-FPM)
echo "Starting server..."
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf