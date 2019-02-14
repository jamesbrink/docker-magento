# Magento
#
# VERSION 2.2

FROM jamesbrink/php:7.1

# Build ARGs.
ARG VCS_REF
ARG BUILD_DATE
ARG MAGENTO_VERSION=2.2.3
ARG MAGERUN_VERSION=2.1.0
ARG SASS_ENABLED=false
ARG ENABLE_SAMPLE_DATA="false"

#Labels
LABEL maintainer="James Brink, brink.james@gmail.com" \
    decription="Magento 2" \
    version="2.2.3" \
    org.label-schema.name="magento" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.vcs-url="https://github.com/jamesbrink/docker-magento" \
    org.label-schema.schema-version="1.0.0-rc1"

# Create our non-priviledged user that will run magento.
RUN addgroup -S magento && adduser -S -h /magento -s /bin/sh -G magento magento

# Install all build-deps and then install magento.
RUN apk --no-cache --update --virtual runtime-deps add \
        bash \
        freetype \
        icu-libs \
        libcap \
        libjpeg \
        libmcrypt \
        libpng \
        libxslt \
    && apk --no-cache --virtual build-deps add \
        autoconf \
        binutils \
        binutils-libs \
        dpkg \
        dpkg-dev \
        file \
        freetype-dev \
        g++ \
        gcc \
        gmp \
        icu-dev \
        isl \
        libatomic \
        libbz2 \
        libc-dev \
        libgcc \
        libgomp \
        libjpeg-turbo-dev \
        libmagic \
        libmcrypt-dev \
        libpng-dev \
        libstdc++ \
        libxslt-dev \
        m4 \
        make \
        mpc1 \
        mpfr3 \
        musl-dev \
        pcre-dev \
        perl \
        pkgconf \
        pkgconfig \
        re2c \
    && pecl install xdebug \
    && docker-php-ext-install iconv mcrypt intl xsl zip pdo_mysql soap \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && cd /var/tmp \
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer \
    && setcap cap_net_bind_service=+ep /usr/sbin/httpd \
    && mkdir -p /magento/htdocs \
    && mkdir -p /magento/logs \
    && mkdir -p /magento/cgi-bin \
    && mkdir -p /magento/bin \
    && chown -R magento:magento /magento \
    && su magento -c "composer create-project magento/community-edition:${MAGENTO_VERSION} /magento/htdocs/" \
    && su magento -c "cd /magento/htdocs && composer install" \
    && su magento -c "cd /magento/htdocs && composer require --no-update n98/magerun2:${MAGERUN_VERSION}" \
    && su magento -c "cd /magento/htdocs && composer update" \
    && su magento -c "cd /magento/htdocs && composer clear-cache" \
    && apk del build-deps \
    && chown -R magento:magento /run/apache2 \
    && chown -R magento:magento /etc/apache2 \
    && echo -e "date.timezone=America/Chicago\nmemory_limit=2G\nasp_tags=off\n" > /usr/local/etc/php/php.ini \
    && if [ "$SASS_ENABLED" = "true" ]; then \
        apk --no-cache add nodejs libnotify \
        && cd /magento/htdocs \
        && su magento -c "composer require snowdog/theme-blank-sass" \
        && su magento -c "composer require snowdog/frontools" \
        && su magento -c "composer clear-cache" \
        && cd vendor/snowdog/frontools \
        && su magento -c "npm install" \
        && su magento -c "npm cache clean --force" \
        && su magento -c "npx gulp setup"; \
    fi

# Switch to non-priviledged user.
USER magento

# Set our working directory.
WORKDIR /magento/

# Install sample data if needed.
RUN if [ "${ENABLE_SAMPLE_DATA}" = "true" ]; then \
    cd /magento/ \
    && curl -L -O https://github.com/magento/magento2-sample-data/archive/${MAGENTO_VERSION}.tar.gz \
    && tar xfvz ${MAGENTO_VERSION}.tar.gz \
    && rm ${MAGENTO_VERSION}.tar.gz \
    && mv magento2-sample-data-${MAGENTO_VERSION} sample-data \
    && php -f /magento/sample-data/dev/tools/build-sample-data.php -- --ce-source=/magento/htdocs/; \
    fi

# Copy assets into the container.
COPY ./docker-assets/ /

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
    MAGENTO_MODE="developer" \
    MAGENTO_PASSWORD="password1" \
    MAGENTO_USERNAME="admin" \
    MAGENTO_HOME="/magento/htdocs" \
    MARIADB_HOST="mariadb" \
    MARIADB_PORT_NUMBER="3306" \
    MARIADB_ROOT_PASSWORD="password" \
    MARIADB_ROOT_USER="root" \
    REDIS_HOST="" \
    REDIS_PORT="6379" \
    VARNISH_HOST="" \
    MOD_PAGESPEED_ENABLED="true" \
    ENABLE_SAMPLE_DATA="false" \
    PATH="/magento/htdocs/bin:/magento/htdocs/vendor/bin/:/magento/htdocs/vendor/n98/magerun2/bin:$PATH"

USER root
RUN chown -R magento:magento /etc/apache2
USER magento

# Expose http and https ports.
EXPOSE 80 443

# Set out default command.
CMD ["/usr/local/bin/entrypoint.sh"]