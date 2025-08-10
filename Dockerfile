# Start from the official PHP 8.3 FPM image
FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y git curl zip unzip nginx libpng-dev libonig-dev libxml2-dev libpq-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application files
COPY . .

# Install dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev

# --- START OF FIX ---
# Copy the Nginx configuration file into the container
COPY docker/nginx.conf /etc/nginx/sites-enabled/default
# --- END OF FIX ---

# Copy startup script and make it executable
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Expose port 80
EXPOSE 80

# Run the startup script
CMD ["/start.sh"]