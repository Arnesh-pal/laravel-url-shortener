#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Run database migrations
php /var/www/html/artisan migrate --force

# Start PHP-FPM in the background
php-fpm &

# Start Nginx in the foreground
nginx -g "daemon off;"