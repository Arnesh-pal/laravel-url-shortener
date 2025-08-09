# Use a stable, well-maintained PHP 8.3 + Apache image
FROM thecodingmachine/php:8.3-v4-apache

# Set the working directory
WORKDIR /var/www/html

# Copy the application code into the web root
COPY . .

# This single command runs all setup and startup tasks.
# It's more reliable than using an external script.
CMD ["/bin/bash", "-c", "mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache && chown -R www-data:www-data storage bootstrap/cache && php artisan migrate --force && php artisan config:cache && php artisan route:cache && php artisan view:cache && echo 'Starting server...' && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]