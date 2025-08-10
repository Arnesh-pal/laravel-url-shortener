#!/bin/bash
set -e

# Run database migrations
php /var/www/html/artisan migrate --force

# Substitute the PORT variable into the Nginx config template
envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start PHP-FPM in the background
php-fpm &

# Start Nginx in the foreground
nginx -g "daemon off;"