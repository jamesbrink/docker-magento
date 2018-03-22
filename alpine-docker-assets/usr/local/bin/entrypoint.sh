#!/bin/bash

install_magento ()
{
  magento setup:install --base-url=http://$MAGENTO_HOST/ \
    --db-host=$MARIADB_HOST --db-name=$MAGENTO_DATABASE_NAME \
    --db-user=$MAGENTO_DATABASE_USER --db-password=$MAGENTO_DATABASE_PASSWORD \
    --admin-firstname=$MAGENTO_FIRSTNAME --admin-lastname=$MAGENTO_LASTNAME \
    --admin-email=$MAGENTO_EMAIL --admin-user=$MAGENTO_USERNAME \
    --admin-password=$MAGENTO_PASSWORD --language=en_US \
    --currency=USD --timezone=America/Chicago --use-rewrites=1 \
    --backend-frontname=$MAGENTO_ADMINURI
}

toggle_pagespeed ()
{
  if [[ "$MOD_PAGESPEED_ENABLED" == "true" ]]; then
    echo "Enabling mod_pagespeed"
    a2enmod pagespeed
  else
    echo "Disabling mod_pagespeed"
    a2dismod pagespeed
  fi
}

set_magento_mode ()
{
  if ! $(magento deploy:mode:show | grep -iq $MAGENTO_MODE); then
    echo "Setting Magento mode: $MAGENTO_MODE"
    magento deploy:mode:set $MAGENTO_MODE
  else
    echo "Magento mode already $MAGENTO_MODE."
  fi
}

compile_sass () {
  if [[ "$MAGENTO_MODE" == "developer" && -e /var/www/html/vendor/snowdog/frontools/package.json ]]; then
    echo "Starting SASS backround task."
    cd /var/www/html/vendor/snowdog/frontools
    npx gulp watch &
    gulp_pid="$!"
    trap "echo 'Stopping SASS background task - pid: $gulp_pid'; kill -SIGTERM $gulp_pid" SIGINT SIGTERM
    cd /var/www/html
  elif [[ -e /var/www/html/vendor/snowdog/frontools/package.json ]]; then
    echo "Compiling SASS"
    cd /var/www/html/vendor/snowdog/frontools
    npx gulp styles &
    cd /var/www/html/
  fi
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

# Install Magento sample data.
if [[ "$ENABLE_SAMPLE_DATA" == "true" ]]; then
  echo "Enabling Magento sample data."
  php -f /var/www/magento2-sample-data/dev/tools/build-sample-data.php -- --ce-source=/var/www/html/
else
  echo "Disabling Magento sample data."
  php -f /var/www/magento2-sample-data/dev/tools/build-sample-data.php – --command=unlink --ce-source=/var/www/html/
fi

# Install Magento on first run.
if [[ ! -e /var/www/html/app/etc/env.php ]]; then
  echo "========Installing Magento========"
  until install_magento
  do
    # TODO replace this, this is a very naive approach.
    echo "Waiting for MariaDB"
    sleep 10
  done
  # Secure permisions
  chmod 500 /var/www/html/app/etc
else
  echo "Magento is already installed."
fi

compile_sass
set_magento_mode

# Start apache
toggle_pagespeed
apache2-foreground &
pid="$!"
trap "echo 'Stopping Magento - pid: $pid'; kill -SIGTERM $pid" SIGINT SIGTERM

# Run the cron job every 1 minute
while :;do magento cron:run | grep -v "Ran jobs by schedule";sleep 60; done &

# Wait for process to end.
while kill -0 $pid > /dev/null 2>&1; do
    wait
done
echo "Exiting"
