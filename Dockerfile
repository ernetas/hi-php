FROM php:7.4-fpm-alpine
ENV PHALCON_VERSION=4.0
ENV BUILD_DEPS="autoconf build-base bzip2-dev cyrus-sasl-dev yaml-dev linux-headers"
ENV RUNTIME_DEPS="curl zip unzip git libsasl yaml openssl-dev freetype-dev icu-dev jpeg-dev libmcrypt-dev"
WORKDIR /
RUN apk update && apk add --no-cache ${BUILD_DEPS} && apk add --no-cache ${RUNTIME_DEPS} && \
    docker-php-ext-install bz2 intl opcache pcntl exif && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd && \
    pecl install mongodb redis yaml grpc apcu && \
    docker-php-ext-enable mongodb redis yaml grpc apcu && \
    pecl install psr && docker-php-ext-enable psr && \
    pecl install phalcon && docker-php-ext-enable phalcon && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    apk del --purge ${BUILD_DEPS}
