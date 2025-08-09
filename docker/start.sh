#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Run database migrations
php /var/www/html/artisan migrate --force

# Replace the PORT variable in the Nginx config
# Replace ${PORT} with actual port from Render
envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

mv /etc/nginx/conf.d/default.conf.temp /etc/nginx/conf.d/default.conf

# Start PHP-FPM in the background
php-fpm &

# Start Nginx in the foreground
nginx -g "daemon off;"