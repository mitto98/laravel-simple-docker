# laravel-simple-docker

Now you can create your own image creating a Dockerfile like this in your project direcory

```Dockerfile
FROM mitto98/simple-laravel:latest 

#copy source files and run composer
COPY . $APP_HOME

#install all PHP dependencies
RUN composer install --no-interaction

RUN php artisan storage:link

#change ownership of our applications
RUN chown -R www-data:www-data $APP_HOME
``` 