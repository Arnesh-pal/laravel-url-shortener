# Replace existing Dockerfile with this
FROM php:8.3-fpm

# Install system dependencies including PostgreSQL client
RUN apt-get update && apt-get install -y \
    git curl zip unzip nginx \
    libpng-dev libonig-dev libxml2-dev libpq-dev \
    postgresql-client

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install dependencies (without dev packages)
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Copy configurations
COPY docker/nginx.conf /etc/nginx/sites-available/default
COPY docker/start.sh /start.sh
RUN chmod +x /start.sh

# Set permissions
RUN chown -R www-data:www-data storage bootstrap/cache

RUN echo "Europe/London/Singapore" > /etc/timezone

CMD ["/start.sh"]