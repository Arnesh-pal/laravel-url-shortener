#!/bin/bash
set -e

# Set permissions for Laravel
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Run database migrations
php /var/www/html/artisan migrate --force

# Start PHP-FPM in the background
php-fpm &

# Start Nginx in the foreground
nginx -g "daemon off;"