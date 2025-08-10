# Start from the official PHP 8.3 FPM image
FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies needed for Laravel, common extensions, and PostgreSQL
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
    libzip-dev

# Install all common PHP extensions required by Laravel
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy only composer files to leverage Docker cache
COPY composer.json composer.lock ./

# Clear cache and install dependencies without running scripts
RUN composer clear-cache && \
    composer install --no-interaction --no-autoloader --no-scripts --prefer-dist

# Copy the rest of the application code
COPY . .

# Generate the autoloader and run scripts now that the full app is present
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy Nginx config and startup script
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Expose port 80
EXPOSE 80

# Run the startup script
CMD ["/start.sh"]