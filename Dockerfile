FROM php:7.3-apache

#RUN apt-get update && apt-get install -y libonig-dev libicu-dev libpq-dev openssl git zip unzip \
#    && rm -r /var/lib/apt/lists/* 
#RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd 
#RUN docker-php-ext-install pdo intl mbstring openssl pcntl pdo_mysql pdo_pgsql pgsql zip opcache

RUN apt-get update -y && apt-get install -y libonig-dev openssl zip unzip git
RUN docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd
RUN docker-php-ext-install pdo pdo_mysql mbstring

#install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

ENV APP_ROOT /var/www/html

WORKDIR ${APP_ROOT}

#change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

#change the web_root to laravel public folder
RUN sed -i -e "s/html/html\/public/g" /etc/apache2/sites-enabled/000-default.conf

# enable apache module rewrite
RUN a2enmod rewrite

ONBUILD COPY . $APP_ROOT
ONBUILD RUN composer install --no-interaction --optimize-autoloader --no-dev
ONBUILD RUN chown -R www-data:www-data $APP_ROOT