# Use a stable, well-maintained PHP 8.3 + Apache image
FROM thecodingmachine/php:8.3-v4-apache

# Copy the application code into the web root
COPY . /var/www/html

# --- START OF FIX ---
# Create the storage and cache directories required by Laravel
RUN mkdir -p /var/www/html/storage/framework/{sessions,views,cache} \
    /var/www/html/storage/logs \
    /var/www/html/bootstrap/cache
# --- END OF FIX ---

# Set the correct permissions for the web server to write to these directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy the startup script into the container
COPY entrypoint.sh /entrypoint.sh
# Make the script executable
RUN chmod +x /entrypoint.sh

# Tell the container to run our script on start
CMD ["/entrypoint.sh"]