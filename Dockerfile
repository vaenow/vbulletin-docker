FROM php:7.4-apache

RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli 

# Install dependencies
#RUN add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get -y update
RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd
RUN apt-get -y install unzip vim 
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli && apachectl restart
#RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli 

# Add vhost for nginx container
ADD docker/default.vhost.conf /etc/nginx/conf.d/default.conf

# test vbulletin env
#ADD vb_test.php /var/www/html/

# Copy vBulletin files and UnzipIt
COPY vb/upload /var/www/html/
RUN chmod -R 777 /var/www/html/
RUN chown -R www-data:www-data /var/www
#ADD vb5-6-5.zip vb.zip
#RUN unzip vb.zip \
#    && mkdir -p /var/www/html \
#    && mv upload/* /var/www/html/

RUN cd /var/www/html/ && mv htaccess.txt .htaccess
#RUN mv /var/www/html/forum/htaccess.txt /var/www/html/.htaccess

RUN a2enmod rewrite &&  service apache2 restart

WORKDIR /var/www/html
#WORKDIR /var/www/html/forum

EXPOSE 80 443

#CMD [ "php", "./vb_test.php" ]
