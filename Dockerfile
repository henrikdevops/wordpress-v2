FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    php-mysql \
    wget \
    unzip \
    && apt-get clean

#USER 1000 Make sure to set UID when deploy!

#I dont know why i cant set USER 1000 before creating containerfile

RUN mkdir -p /var/www/html/wordpress
RUN wget https://wordpress.org/latest.zip -O /tmp/wordpress.zip && unzip /tmp/wordpress.zip -d /var/www/html && rm /tmp/wordpress.zip
#1
RUN chown -R www-data:www-data /var/www/html/wordpress && chmod -R 755 /var/www/html/wordpress

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    echo "<Directory /var/www/html/wordpress>" >> /etc/apache2/apache2.conf && \
    echo "AllowOverride All" >> /etc/apache2/apache2.conf && \
    echo "</Directory>" >> /etc/apache2/apache2.conf

RUN a2enmod rewrite
EXPOSE 8080
WORKDIR /var/www/html/wordpress
CMD ["apachectl", "-D", "FOREGROUND"]
