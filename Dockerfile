FROM php:8.3-fpm-alpine3.21

# Install dependencies: Supervisor and other required packages
RUN apk add --update --no-cache git zip wget curl bash sudo dcron shadow supervisor nodejs npm && rm -rf /var/cache/apk/*

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions gd zip intl pcntl bcmath sockets opcache pdo_mysql pdo_pgsql

COPY --from=composer:2.8.4 /usr/bin/composer /usr/bin/composer

RUN mkdir -p /var/run && chmod 777 /var/run

RUN mkdir -p /var/log/supervisor /etc/supervisor/conf.d

RUN curl -fsSL https://code-server.dev/install.sh | sh

# COPY .docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html

RUN git config --global --add safe.directory /var/www/html

# CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

CMD crond && php-fpm
