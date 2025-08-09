# Start from the official PHP 8.3 FPM image
FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    gettext-base \
    libpq-dev

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# PHP-FPM config
COPY docker/php-fpm-pool.conf /etc/php/8.3/fpm/pool.d/www.conf

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy app files
COPY . .

# Install PHP dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Set permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy Nginx template and startup script
COPY docker/default.conf.template /etc/nginx/conf.d/default.conf.template
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Expose port (Render will override with $PORT)
EXPOSE 80

# Start
CMD ["/start.sh"]
