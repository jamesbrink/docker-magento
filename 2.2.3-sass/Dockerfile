# Magento
#
# VERSION 2.2.3-sass

FROM php:7.1-apache
LABEL maintainer="James Brink, brink.james@gmail.com"
LABEL decription="Magento Server"
LABEL version="2.2.3-sass"

# Build ARGs
ARG magento_version=2.2.3
ARG sass_enabled=false

# Install deps for Magento, and setup user and permisions.
RUN apt-get update \
    &&  apt-get install -y \
        libfreetype6-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxslt-dev \
        unzip \
        wget \
        zip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) iconv mcrypt intl xsl zip pdo_mysql soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && cd /var/tmp \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && groupadd magento \
    && useradd -g magento -d /var/www/ -s /bin/bash magento \
    && chown -R magento:magento /var/www/ \
    && setcap cap_net_bind_service=+ep /usr/sbin/apache2 \
    && chown -R magento:magento /var/log/apache2 \
    && chown -R magento:magento /var/run/apache2 \
    && chown -R magento:magento /var/lock/apache2 \
    && chown -R magento:magento /etc/apache2 \
    && a2enmod rewrite

# Install mod_pagespeed
RUN cd /var/tmp \
    && wget "https://dl-ssl.google.com/dl/linux/direct/mod-pagespeed-stable_current_amd64.deb" \
    && dpkg -i mod-pagespeed-*.deb \
    && apt-get -f install \
    && rm mod-pagespeed-*.deb \
    && mkdir -p /var/cache/mod_pagespeed \
    && mkdir -p /var/log/pagespeed \
    && chown -R magento:magento /var/cache/mod_pagespeed \
    && chown -R magento:magento /var/log/pagespeed

# If Enabled on build - Install nodejs
RUN if [ "${sass_enabled}" != "true" ] ; then exit 0 ;fi \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Setup php.ini
RUN echo -e "date.timezone=America/Chicago\nmemory_limit=2G\nasp_tags=off\n" > /usr/local/etc/php/php.ini

USER magento

# Install Magento & Clear composer cache
RUN composer create-project magento/community-edition:${magento_version} /var/www/html \
    && composer clear-cache

# If Enabled on build - Install blank-sass theme and frontools
RUN if [ "${sass_enabled}" != "true" ] ; then exit 0 ;fi \
    && cd /var/www/html \
    && composer require snowdog/theme-blank-sass \
    && composer require snowdog/frontools \
    && cd vendor/snowdog/frontools \
    && npm install \
    && cp config/themes.json.sample config/themes.json \
    && npx gulp styles --prod

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
    PATH="/var/www/html/bin:$PATH"

# Set ServerName in apache config.
RUN echo "ServerName $MAGENTO_HOST" >> /etc/apache2/apache2.conf

# Copy our files into the container.
COPY ./docker-assets/ /

# Expose http and https ports.
EXPOSE 80 443

CMD ["/usr/local/bin/entrypoint.sh"]