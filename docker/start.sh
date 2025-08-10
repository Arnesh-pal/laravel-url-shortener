#!/bin/bash
set -e

# Set PORT from Render environment or default to 8000
export PORT=${PORT:-8000}

# Update Nginx config with actual PORT
sed -i "s/listen .*/listen $PORT;/g" /etc/nginx/sites-available/default

# Permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Database migrations
php artisan migrate --force

# Cache optimization
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start services
php-fpm -D
nginx -g "daemon off;"

# Add after service starts
echo "Checking service health..."
curl -Ifs http://localhost:$PORT > /dev/null && echo "App is running!" || echo "App failed to start"