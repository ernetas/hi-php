FROM php:5.6-fpm
ENV APT_LISTCHANGES_FRONTEND mail
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y -o DPkg::options::='--force-confdef' -o Dpkg::Options::='--force-confold' \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
	imagemagick \
	libgraphicsmagick1-dev \
	libmagickwand-dev \
	libcurl3 \
        libxslt1-dev \
        libxslt1.1 \
	curl \
	libcurl4-gnutls-dev \
	libicu-dev \
	libc-client2007e-dev \
	libc-client2007e \
	libkrb5-dev \
        libmariadbclient-dev-compat \
	libzip-dev \
	libexif-dev \
	git \
        mysql-client \
        pkg-config \
        python \
        libtiff5-dev \
        libreadline-dev \
        libreadline7 \
        libedit-dev \
        libgmp-dev \
    && apt-get clean \
    && apt-get autoremove -y \
    && curl --output composer -Ss https://getcomposer.org/download/1.5.2/composer.phar \
    && mv composer /usr/bin/composer \
    && chmod 755 /usr/bin/composer \
    && chown root:root /usr/bin/composer \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) mbstring json pdo_mysql mysqli zip iconv mcrypt intl curl exif opcache xmlrpc xsl readline \
    && pecl install imagick APCu mongo redis gRPC \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && ln -sf /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h \
    && docker-php-ext-configure gmp \
    && docker-php-ext-install -j$(nproc) gd imap gmp \
    && docker-php-ext-enable imagick mbstring json readline mongo redis gd imap grpc gmp xmlrpc xsl readline opcache curl exif intl \
    && groupadd -g 1001 app \
    && useradd -m -g 1001 -u 1001 app \
    && php -v \
    && php -i
