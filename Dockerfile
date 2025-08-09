# Use a stable, well-maintained PHP 8.3 + Apache image
FROM thecodingmachine/php:8.3-v4-apache

# Set the working directory
WORKDIR /var/www/html

# Copy the application code into the web root
COPY . .

# Run all setup and startup tasks
CMD ["/bin/bash", "-c", "php artisan migrate --force && php artisan config:cache && php artisan route:cache && php artisan view:cache && echo 'Starting server...' && apache2-foreground"]