# Laravel API: PHP 8.4 + Apache
FROM php:8.4-apache

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        unzip \
        libzip-dev \
        libonig-dev \
    && docker-php-ext-install -j"$(nproc)" pdo_mysql mbstring zip opcache \
    && a2enmod rewrite headers \
    && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Dependencias PHP (capa cacheable)
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --no-scripts --no-autoloader

COPY . .

# Autoload optimizado + permisos de escritura para Laravel
RUN composer dump-autoload --optimize --no-dev --no-interaction \
    && chown -R www-data:www-data storage bootstrap/cache

# Apache sirve directamente /public (punto de entrada de Laravel)
RUN sed -ri 's!/var/www/html!/var/www/html/public!g' \
        /etc/apache2/sites-available/*.conf /etc/apache2/apache2.conf

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
CMD ["apache2-foreground"]
