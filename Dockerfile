FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    wget \
    unzip \
    && apt-get clean

# Switch to root user (already default)
USER root

# Update Apache to use port 8080
RUN sed -i 's/80/8080/' /etc/apache2/ports.conf && \
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-available/000-default.conf && \
    mkdir -p /var/www/html/wordpress

# Download and extract WordPress
RUN wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && \
    unzip /tmp/wordpress.zip -d /var/www/html && \
    rm /tmp/wordpress.zip

# Set proper permissions for WordPress
RUN chown -R www-data:www-data /var/www/html/wordpress && \
    chmod -R 755 /var/www/html/wordpress

# Configure Apache for WordPress
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "<Directory /var/www/html/wordpress>" >> /etc/apache2/apache2.conf && \
    echo "    AllowOverride All" >> /etc/apache2/apache2.conf && \
    echo "</Directory>" >> /etc/apache2/apache2.conf

# Enable Apache rewrite module
RUN a2enmod rewrite

# Expose port 8080
EXPOSE 8080

# Set working directory
WORKDIR /var/www/html/wordpress

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND", "-f", "/etc/apache2/apache2.conf"]

