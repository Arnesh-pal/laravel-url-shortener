# Start from the official PHP 8.3 FPM image
FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies, adding gettext-base for envsubst
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    libpq-dev \
    gettext-base

# Install PHP extensions required by Laravel
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . .

# Install PHP dependencies with Composer
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# This is the new line to add
COPY docker/php-fpm-pool.conf /usr/local/etc/php-fpm.d/www.conf

# Copy Nginx config template and startup script
COPY docker/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Expose port (Render will override with $PORT)
EXPOSE 80

# Run the startup script
CMD ["/start.sh"]