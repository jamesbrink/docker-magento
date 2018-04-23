#!/bin/bash

# Used for simple logging purposes.
# timestamp="date +\"%Y-%m-%d %H:%M:%S\""
# alias echo="echo \"$(eval $timestamp) -$@\""

cd "$MAGENTO_HOME" || exit

install_magento() {
	magento setup:install --base-url="http://$MAGENTO_HOST/" \
		--db-host="$MARIADB_HOST" --db-name="$MAGENTO_DATABASE_NAME" \
		--db-user="$MAGENTO_DATABASE_USER" --db-password="$MAGENTO_DATABASE_PASSWORD" \
		--admin-firstname="$MAGENTO_FIRSTNAME" --admin-lastname="$MAGENTO_LASTNAME" \
		--admin-email="$MAGENTO_EMAIL" --admin-user="$MAGENTO_USERNAME" \
		--admin-password="$MAGENTO_PASSWORD" --language=en_US \
		--currency=USD --timezone=America/Chicago --use-rewrites=1 \
		--backend-frontname="$MAGENTO_ADMINURI"
}

toggle_pagespeed() {
	if [[ "$MOD_PAGESPEED_ENABLED" == "true" ]]; then
		echo "Enabling mod_pagespeed"
		a2enmod pagespeed
	else
		echo "Disabling mod_pagespeed"
		a2dismod pagespeed
	fi
}

set_magento_mode() {
	if ! magento deploy:mode:show | grep -iq "$MAGENTO_MODE"; then
		# This makes a massive difference in response times.
		if [ "$VARNISH_HOST" != "" ]; then
			magento config:set --scope=default --scope-code=0 system/full_page_cache/caching_application 2
		fi
		echo "Setting Magento mode: $MAGENTO_MODE"
		magento deploy:mode:set $MAGENTO_MODE
		# magento setup:di:compile
	else
		echo "Magento mode already $MAGENTO_MODE."
	fi
	# For some reason, enabling varnish is not enough
	# without clearing the cache it simply wont work.
	magento cache:flush
}

enabled_xdebug() {
	echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >/usr/local/etc/php/conf.d/xdebug.ini
	echo "xdebug.remote_enable=on" >>/usr/local/etc/php/conf.d/xdebug.ini
	echo "xdebug.remote_autostart=off" >>/usr/local/etc/php/conf.d/xdebug.ini
}

compile_sass() {
	if [[ "$MAGENTO_MODE" == "developer" && -e /var/www/html/vendor/snowdog/frontools/package.json ]]; then
		echo "Starting SASS backround task."
		cd "$MAGENTO_HOME/vendor/snowdog/frontools" || return
		npx gulp watch &
		gulp_pid="$!"
		trap "echo 'Stopping SASS background task - pid: $gulp_pid'; kill -SIGTERM $gulp_pid" SIGINT SIGTERM
		cd - || return
	elif [[ -e /var/www/html/vendor/snowdog/frontools/package.json ]]; then
		echo "Compiling SASS"
		cd "$MAGENTO_HOME/vendor/snowdog/frontools" || return
		npx gulp styles --prod &
		cd - || return
	fi
}

enable_redis() {
	mv "$MAGENTO_HOME/app/etc/env.php" "$MAGENTO_HOME/app/etc/env.php.orig"
	echo "Enabling Redis Cache"
	head -n -1 "$MAGENTO_HOME/app/etc/env.php.orig" > "$MAGENTO_HOME/app/etc/env.php"
	cat <<-EOF >>"$MAGENTO_HOME/app/etc/env.php"
		'cache' =>
		array(
		'frontend' =>
		array(
			'default' =>
			array(
				'backend' => 'Cm_Cache_Backend_Redis',
				'backend_options' =>
				array(
					'server' => '$REDIS_HOST',
					'database' => '0',
					'port' => '$REDIS_PORT'
					),
			),
			'page_cache' =>
			array(
			'backend' => 'Cm_Cache_Backend_Redis',
			'backend_options' =>
			array(
				'server' => '$REDIS_HOST',
				'port' => '$REDIS_PORT',
				'database' => '1',
				'compress_data' => '0'
			)
			)
		)
		),);
	EOF
}

change_apache_port () {
	new_port="$1"
	echo "Changing Apache port to: $new_port"
	sed -ir "s/Listen 0.0.0.0:80.*/Listen 0.0.0.0:8080/g" /etc/apache2/httpd.conf
	sed -ir "s/<VirtualHost \\*:80>/<VirtualHost \\*:8080>/g" /etc/apache2/conf.d/magento.conf
}

echo "========Magento Settings========"
echo "Magento Mode: $MAGENTO_MODE"
echo "Magento Host: $MAGENTO_HOST"
echo "Magento User: $MAGENTO_USERNAME"
echo "Magento Password: $MAGENTO_PASSWORD"
echo "Magento Email: $MAGENTO_EMAIL"
echo "Magento Admin URI: $MAGENTO_ADMINURI"
echo "Database Host: $MARIADB_HOST"
echo "Database User: $MAGENTO_DATABASE_USER"
echo "Database Password: $MAGENTO_DATABASE_PASSWORD"

if [ "$VARNISH_HOST" != "" ];then
	change_apache_port 8080
fi

# Start apache
echo "Starting Apache"
httpd -D FOREGROUND &
pid="$!"
trap "echo 'Stopping Magento - pid: $pid'; kill -SIGTERM $pid" SIGINT SIGTERM

# Install Magento on first run.
if [ ! -e $MAGENTO_HOME/app/etc/env.php ]; then
	echo "========Installing Magento========"
	until install_magento; do
		# TODO replace this, this is a very naive approach.
		echo "Waiting for MariaDB"
		sleep 10
	done
	
	# Enable Redis for cache if redis hostname is supplied.
	if [ "$REDIS_HOST" != "" ]; then
		enable_redis
	fi

	# Secure permisions
	echo "running chmod 500 on /magento/app/etc"
	chmod 500 $MAGENTO_HOME/app/etc
else
	echo "Magento is already installed."
fi

compile_sass
set_magento_mode

# Run the cron job every 1 minute
while :; do
	magento cron:run | grep -v "Ran jobs by schedule"
	sleep 60
done &

# Wait for process to end.
while kill -0 $pid >/dev/null 2>&1; do
	wait
done
echo "Exiting"
