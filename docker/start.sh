#!/bin/bash
set -e

# ONLY run database migrations. No more caching commands.
php /var/www/html/artisan migrate --force

# Start PHP-FPM in the background
php-fpm &

# Start Nginx in the foreground
nginx -g "daemon off;"