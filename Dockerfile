# Docker image with redhat ubi 9, PHP install and wordpress 6.7.1
FROM docker.io/redhat/ubi9:latest

# installation php
ENV WORDPRESS_VERSION=6.7.1
# PHP installation
RUN yum install -y \
        httpd \
        php \
        php-mysqlnd \
        php-json \
        php-curl \
        php-gd \
        php-mbstring \
        php-xml \
        php-opcache \
        wget \
        tar \
        unzip \
    && yum clean all


# dwnl, unpack & inst WordPress
RUN wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && unzip /tmp/wordpress.zip -d /var/www/html && rm /tmp/wordpress.zip

# Rights for WordPress
RUN chown -R apache:apache /var/www/html \
    && chmod -R 755 /var/www/html

# Cat for wordpress
WORKDIR /var/www/html/wordpress/

####

#Change config for APACHE to port8080 with sed 
RUN sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf


# port exp 8080  pod
EXPOSE 8080

# Start php w port 8080 from /wordpress
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html/wordpress/"]
#CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]

