FROM php:8.0-fpm-alpine

LABEL maintainer='HongXunPan <me@kangxuanpeng.com>'

RUN apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS zlib-dev libzip-dev libpng-dev openssl-dev \
    # for gettext intl  soap
    gettext-dev icu-dev libxml2-dev libwebp-dev jpeg-dev freetype-dev linux-headers \ 
    supervisor bash vim \
    && docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype \
    && pecl install redis xdebug \
    && docker-php-ext-install bcmath \
        gd gettext intl mysqli pcntl pdo_mysql shmop soap sockets sysvsem zip \
    && docker-php-ext-enable redis \
    # composer
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && mv ${PHP_INI_DIR}/php.ini-production ${PHP_INI_DIR}/php.ini

COPY php.ini /usr/local/etc/php/conf.d/php.ini
COPY php-fpm.conf /usr/local/etc/php-fpm.d/php-fpm.conf
COPY conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d
COPY supervisor/supervisord.conf /etc/supervisord.conf
COPY supervisor/supervisor.d /etc/supervisor.d

WORKDIR /data/www

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]

EXPOSE 9000

# bcmath
# gd
# gettext
# intl
# mysqli
# pcntl
# pdo_mysql
# shmop
# soap
# sockets
# sysvsem
# zip
