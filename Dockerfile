FROM php:7.3-apache

ENV APP_ROOT /var/www/html

WORKDIR ${APP_ROOT}

# {1-4} Install laravel php dependencies
# Install composer
# change uid and gid of apache to docker user uid/gid
# change the web_root to laravel public folder
# enable apache module rewrite
RUN apt-get update -y && apt-get install -y libonig-dev openssl zip unzip git\
    && rm -r /var/lib/apt/lists/* \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql=mysqlnd \
    && docker-php-ext-install pdo pdo_mysql mbstring \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer \
    && usermod -u 1000 www-data && groupmod -g 1000 www-data \
    && sed -i -e "s/html/html\/public/g" /etc/apache2/sites-enabled/000-default.conf \
    && a2enmod rewrite

ONBUILD COPY . $APP_ROOT
ONBUILD RUN composer install --no-interaction --optimize-autoloader --no-dev \
    && chown -R www-data:www-data $APP_ROOT