FROM composer:1.7 as build

COPY app/ /app/
RUN composer install --no-interaction --no-scripts --no-progress --optimize-autoloader 
WORKDIR /app/

FROM php:7.2-alpine3.8
ENV PATH "$PATH:/app/vendor/bin/"
COPY --from=build /app/ /app/
