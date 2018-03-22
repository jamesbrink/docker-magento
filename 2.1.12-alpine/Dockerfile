# Magento
#
# VERSION 2.1.12-alpine

FROM php:7.0-alpine
LABEL maintainer="James Brink, brink.james@gmail.com"
LABEL decription="Magento Server"
LABEL version="2.1.12-alpine"

# Build ARGs
ARG magento_version=2.1.12
ARG magerun_version=2.1.0
ARG sass_enabled=false

RUN addgroup -S magento && adduser -S -h /magento -s /bin/sh -G magento magento

RUN apk --no-cache --update --virtual deps add apache2 icu-libs libmcrypt libxslt libjpeg libpng freetype \
    && apk --no-cache --virtual misc add libcap \
    && apk --no-cache --virtual build-deps add libmcrypt-dev icu-dev libxslt-dev libjpeg-turbo-dev libpng-dev freetype-dev \
    && apk --no-cache --virtual build-deps2 add m4 perl autoconf pkgconf pkgconfig dpkg-dev libbz2 dpkg libmagic file libgcc libstdc++ binutils-libs binutils gmp isl libgomp libatomic mpfr3 mpc1 gcc musl-dev libc-dev g++ make re2c \
    && docker-php-ext-install iconv mcrypt intl xsl zip pdo_mysql soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && cd /var/tmp \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && setcap cap_net_bind_service=+ep /usr/sbin/httpd \
    && composer create-project magento/community-edition:${magento_version} /magento \
    && cd /magento \
    && composer require --no-update n98/magerun2:${magerun_version} \
    && composer update \
    && composer clear-cache \
    && apk del build-deps build-deps2

RUN echo -e "date.timezone=America/Chicago\nmemory_limit=2G\nasp_tags=off\n" > /usr/local/etc/php/php.ini

RUN apk --update add vim bash

# Set all environment variables.
ENV APACHE_HTTPS_PORT_NUMBER="443" \
    APACHE_HTTP_PORT_NUMBER="80" \
    MAGENTO_ADMINURI="admin" \
    MAGENTO_DATABASE_NAME="magento" \
    MAGENTO_DATABASE_PASSWORD="password" \
    MAGENTO_DATABASE_USER="root" \
    MAGENTO_EMAIL="user@example.com" \
    MAGENTO_FIRSTNAME="FirstName" \
    MAGENTO_HOST="127.0.0.1" \
    MAGENTO_LASTNAME="LastName" \
    MAGENTO_MODE="production" \
    MAGENTO_PASSWORD="password1" \
    MAGENTO_USERNAME="admin" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="password" \
    MARIADB_ROOT_USER="root" \
    MOD_PAGESPEED_ENABLED="true" \
    ENABLE_SAMPLE_DATA="false" \
    PATH="/var/www/html/bin:/var/www/html/vendor/bin/:/var/www/html/vendor/n98/magerun2/bin:$PATH"

# Copy assets into the container.
COPY ./docker-assets/ /


# Expose http and https ports.
EXPOSE 80 443

CMD ["/usr/local/bin/entrypoint.sh"]