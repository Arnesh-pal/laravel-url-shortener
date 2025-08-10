#!/bin/bash
set -e

# Generate APP_KEY if not set
if [ -z "$APP_KEY" ]; then
  echo "WARNING: APP_KEY is not set. Generating temporary key."
  export APP_KEY=$(php artisan key:generate --show)
fi

# Add to start.sh before migrations
php artisan tinker --execute="echo DB::connection()->getPdo() ? 'DB Connected' : 'DB Failed';"

# Run database migrations
php artisan migrate --force

# Cache configuration
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Start services
php-fpm &
nginx -g "daemon off;" 

# Add to start.sh
echo "Using PORT: $PORT"