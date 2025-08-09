# Use a stable, well-maintained PHP 8.3 + Apache image
FROM thecodingmachine/php:8.3-v4-apache

# Copy the application code into the web root
COPY . /var/www/html

# Set the correct permissions for the web server to write to storage and cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy the startup script into the container
COPY entrypoint.sh /entrypoint.sh
# Make the script executable
RUN chmod +x /entrypoint.sh

# Tell the container to run our script on start
CMD ["/entrypoint.sh"]