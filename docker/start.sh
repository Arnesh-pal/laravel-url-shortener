#!/bin/bash
set -e

# Run migrations
php /var/www/html/artisan migrate --force

# Replace ${PORT} in template → actual Nginx config
envsubst '$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

# Start PHP-FPM in background
php-fpm &

# Start Nginx in foreground
nginx -g "daemon off;"
