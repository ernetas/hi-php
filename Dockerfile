FROM php:5.6.29-fpm
ENV APT_LISTCHANGES_FRONTEND mail
ENV DEBIAN_FRONTEND noninteractive
COPY objdetect_c.h /usr/include/opencv2/objdetect/objdetect_c.h
RUN apt-get update && apt-get install -y -o DPkg::options::='--force-confdef' -o Dpkg::Options::='--force-confold' \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
	imagemagick \
	libgraphicsmagick1-dev \
	libmagickwand-dev \
	libcurl3 \
	curl \
	libcurl4-gnutls-dev \
	libicu-dev \
	libc-client2007e-dev \
	libc-client2007e \
	libkrb5-dev \
	libmysqlclient-dev \
	libzip-dev \
	libexif-dev \
	git \
        optipng \
        jpegoptim \
        mysql-client \
        pkg-config \
        python \
        libjpeg62-turbo-dev \
        libpng12-dev \
        libtiff5-dev \
        libopencv-dev \
        libopencv-objdetect-dev \
    && apt-get clean \
    && apt-get autoremove -y \
    && git clone https://github.com/infusion/PHP-Facedetect.git \
    && cd PHP-Facedetect \
    && phpize && ./configure && make -j$(nproc) && make install \
    && cd .. && rm -rf PHP-Facedetect \
    && ln -s /dev/null /dev/raw1394
RUN apt-get update
RUN apt-get install -y libreadline-dev libreadline6
RUN docker-php-ext-install -j$(nproc) readline
RUN docker-php-ext-install -j$(nproc) mbstring json pdo_mysql mysqli zip iconv mcrypt intl curl exif opcache gmp xmlrpc xsl \
    && pecl install imagick APCu mongo redis \
    && docker-php-ext-enable imagick apcu mbstring json readline mongo redis facedetect \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install -j$(nproc) gd imap \
    && rm -rf /var/lib/apt/lists/* \
    && curl --output composer -Ss https://getcomposer.org/download/1.2.4/composer.phar \
    && mv composer /usr/bin/composer \
    && chmod 755 /usr/bin/composer \
    && chown root:root /usr/bin/composer
