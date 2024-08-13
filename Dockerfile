FROM php:8.1-fpm

ARG user
ARG uid

ENV PHP_MEMORY_LIMIT=512M

ENV DEBIAN_FRONTEND noninteractive
ENV DEBIAN_FRONTEND teletype

RUN apt-get update && apt-get install -y \
    nano \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    unzip \
    unixodbc-dev \
    gnupg \
    libzip-dev \
    libz-dev \
    zip 

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd
    
RUN docker-php-ext-configure zip  \
    && docker-php-ext-install zip 

RUN pecl install sqlsrv pdo_sqlsrv zlib zip

RUN docker-php-ext-enable pdo_sqlsrv sqlsrv zip

RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

WORKDIR /var/www

USER $user
