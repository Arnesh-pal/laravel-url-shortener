# Use a stable, well-maintained PHP 8.3 + Apache image
FROM thecodingmachine/php:8.3-v4-apache

# Copy the application code (including entrypoint.sh) into the web root
COPY . /var/www/html

# Make the startup script executable from its new location
RUN chmod +x /var/www/html/entrypoint.sh

# Tell the container to run our script from its new location
CMD ["/var/www/html/entrypoint.sh"]