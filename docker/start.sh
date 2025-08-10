#!/bin/bash
set -ex

export PORT=${PORT:-8000}
sed -i "s/listen .*/listen $PORT;/g" /etc/nginx/sites-available/default

# Debug output
echo "APP_KEY: ${APP_KEY:0:15}..."  # First 15 chars only
echo "DATABASE_URL: ${DATABASE_URL:0:30}..."  # First 30 chars

# Permissions
chown -R www-data:www-data storage bootstrap/cache

# Database test
php artisan tinker --execute="try { 
    DB::connection()->getPdo(); 
    echo '✅ Database connected'; 
} catch (\Exception \$e) { 
    echo '❌ Database connection failed: ' . \$e->getMessage();
    exit 1;
}"

# Migrations
php artisan migrate --force

# Clear caches
php artisan config:clear
php artisan view:clear
php artisan route:clear

# Start services
php-fpm -D
nginx -g "daemon off;"

# Health check
sleep 5
curl -I "http://localhost:$PORT" || echo "Health check failed"