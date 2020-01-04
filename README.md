# laravel-simple-docker

Now you can create your own image creating a Dockerfile like this in your project direcory.  
The Dockerfile must be placed in the root directory of your project

```Dockerfile
FROM mitto98/simple-laravel:latest

RUN php artisan storage:link \
        && php artisan config:cache \
        && php artisan route:cache
``` 