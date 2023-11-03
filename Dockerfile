FROM composer:latest

RUN mkdir /conf.d
RUN apk add sudo \
    autoconf \
    zlib-dev \
    icu-dev \
    g++ \
    postgresql-dev
RUN adduser -D user sudo
RUN echo "user:123" | chpasswd
RUN echo "user    ALL=(ALL:ALL) ALL" >> /etc/sudoers

# PDO & INTL
RUN docker-php-ext-configure intl
RUN docker-php-ext-install intl pdo_pgsql pdo
RUN docker-php-ext-enable intl
#

# PCNTL
RUN docker-php-ext-install pcntl
#

USER user
WORKDIR /home/user/app

COPY ./source .
RUN composer install

ENTRYPOINT ["sh", "entrypoint.sh"]