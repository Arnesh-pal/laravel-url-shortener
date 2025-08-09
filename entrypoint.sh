#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Run Laravel database migrations
php /var/www/html/artisan migrate --force

# Run Laravel optimization commands
php /var/www/html/artisan config:cache
php /var/www/html/artisan route:cache
php /var/www/html/artisan view:cache

# Start the main server process (this runs Nginx and PHP-FPM)
/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf