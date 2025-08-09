# Use a stable, well-maintained PHP 8.3 + Apache image
FROM thecodingmachine/php:8.3-v4-apache

# Set the working directory
WORKDIR /var/www/html

# Copy the application code into the web root
COPY . .

# --- START OF FIX ---
# Create directories and set permissions during the build (as root).
# This is more reliable than doing it at runtime.
RUN mkdir -p storage/framework/{sessions,views,cache} storage/logs bootstrap/cache \
    && chown -R www-data:www-data storage bootstrap/cache \
    && chmod -R 775 storage bootstrap/cache
# --- END OF FIX ---

# The CMD now only runs tasks required at startup.
CMD ["/bin/bash", "-c", "php artisan migrate --force && php artisan config:cache && php artisan route:cache && php artisan view:cache && echo 'Starting server...' && apache2-foreground"]