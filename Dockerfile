# Start from the official PHP 8.3 FPM image
FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies needed for Laravel and PostgreSQL
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    libpq-dev

# Install PHP extensions required by Laravel for PostgreSQL
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . .

# --- START OF FIX ---
# Allocate a swap file to provide extra memory for Composer
RUN fallocate -l 1G /swapfile && mkswap /swapfile && swapon /swapfile
# --- END OF FIX ---

# Install PHP dependencies with Composer
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/w...
I am Gemini, a helpful AI assistant built by Google. The user has provided an error message and is looking for a solution.

**User's Error:**
The deployment on Render is failing during the `composer install` process, specifically at the "Extracting archive" step for the `symfony/error-handler` package.

**Analysis of the Error:**
1.  **Context:** The error occurs during the Docker build process while running `composer install`.
2.  **Symptom:** The build process stops abruptly after the "Extracting archive" log message.
3.  **Root Cause:** This is a classic symptom of the build process running out of memory (RAM). Render's free tier provides a limited amount of RAM for builds. The `composer install` command, especially when extracting packages, can be memory-intensive. When the process exceeds the available memory, the system's OOM (Out-of-Memory) killer terminates it without a specific error message, making it look like it just "failed".

**Solution:**
The most effective way to solve this on a memory-constrained build environment is to create and activate a "swap file". A swap file uses disk space as a temporary, slower form of RAM, giving memory-hungry processes like Composer enough breathing room to complete.

**Plan for the Response:**
1.  Clearly state the cause of the problem: The build is running out of memory on Render's free tier.
2.  Explain the solution: We will add a command to the `Dockerfile` to create a swap file, which acts as extra memory.
3.  Provide the complete, updated `Dockerfile` with the new command inserted in the correct place (before `composer install`).
4.  Provide the necessary Git commands for the user to commit and push the fix.
5.  Reassure the user that this is a standard and effective solution for this specific issue.This error, where the build fails during "Extracting archive," almost always means the process has **run out of memory (RAM)**.

---
## The Cause: Limited Memory on the Free Tier

Render's free build servers have a small amount of RAM. The `composer install` command can be very memory-intensive, and it's likely exceeding the limit and crashing.

---
## The Solution: Create a Swap File 💾

We can solve this by adding a command to our `Dockerfile` that creates a "swap file." A swap file acts like extra, temporary RAM by using a small amount of disk space. This gives Composer the extra memory it needs to finish the installation.

You only need to update your `Dockerfile`. Please replace its content with this new version:
```dockerfile
# Start from the official PHP 8.3 FPM image
FROM php:8.3-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies needed for Laravel and PostgreSQL
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    libpq-dev

# Install PHP extensions required by Laravel for PostgreSQL
RUN docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy existing application directory contents
COPY . .

# --- START OF FIX ---
# Allocate a swap file to provide extra memory for Composer
RUN fallocate -l 1G /swapfile && mkswap /swapfile && swapon /swapfile
# --- END OF FIX ---

# Install PHP dependencies with Composer
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