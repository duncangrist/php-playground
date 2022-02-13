FROM php:fpm-alpine

ARG UID

# Create a user account manually rather than using:
# adduser -D -u $UID -h /home/dev dev
# This is necessary to support $UIDs > 256000 on alpine/busybox.
RUN echo "dev:x:$UID:$UID::/home/dev:" >> /etc/passwd \
    && echo "dev:!:$(($(date +%s) / 60 / 60 / 24)):0:99999:7:::" >> /etc/shadow \
    && echo "dev:x:$UID:" >> /etc/group \
    && mkdir /home/dev && chown dev: /home/dev

WORKDIR /var/www

RUN echo "UTC" > /etc/timezone

RUN apk add --no-cache libmcrypt libmcrypt-dev libxml2-dev libzip-dev git openssh-client openssh g++ make autoconf \
    fcgi pcre-dev postgresql-dev icu-dev

# Install php extensions.
RUN pecl install xdebug \
    # ACPu comes from PECL.
    && pecl install apcu \
    && docker-php-ext-enable apcu \
    # Others are installed via the docker install script.
    && docker-php-ext-install -j$(getconf _NPROCESSORS_ONLN) pdo_pgsql intl zip \
    && { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=0'; \
        echo 'opcache.fast_shutdown=1'; \
    } > /usr/local/etc/php/conf.d/10-docker-php-ext-opcache.ini \
    && { \
        echo 'xdebug.mode=debug'; \
        echo 'xdebug.start_with_request=yes'; \
        echo 'xdebug.discover_client_host=1'; \
        echo 'xdebug.max_nesting_level=1200'; \
        echo 'xdebug.idekey = PHPSTORM'; \
        } > /usr/local/etc/php/conf.d/99-docker-php-ext-xdebug.ini \
    && docker-php-ext-enable opcache --ini-name 10-docker-php-ext-opcache.ini \
    && docker-php-ext-enable xdebug --ini-name 99-docker-php-ext-xdebug.ini

# Remove packages only needed for building PHP exts.
RUN apk del --rdepends g++ make autoconf pcre-dev

# Install composer.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clean up /tmp.
RUN rm -rf /tmp/* /var/tmp/*

# Run FPM as the dev user for easy permission management.
USER dev

# Update PATH to include project binaries
ENV PATH="/var/www/vendor/bin:/var/www/bin:/home/dev/.yarn/bin:/home/dev/.config/yarn/global/node_modules/.bin:${PATH}"

CMD ["php-fpm"]