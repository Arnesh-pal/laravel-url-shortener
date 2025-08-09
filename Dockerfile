# Use a standard PHP and Nginx image
FROM richarvey/nginx-php-fpm:2.2.3

# Copy our Nginx configuration
COPY docker/nginx/default.conf /etc/nginx/sites-available/default.conf

# Copy the application code
COPY . /var/www/html

# Set ownership of the files to the web user
RUN chown -R www-data:www-data /var/www/html

# Expose port 80 to the world
EXPOSE 80

# Specify the command to run on startup
CMD ["/start.sh"]