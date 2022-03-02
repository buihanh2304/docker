#!/bin/bash

mkdir /etc/apache2/ssl 2> /dev/null

# Change laradock.test to the URL to be used
if [ ${APACHE_HTTP2} = true ]; then
  if [[ ! -f /etc/apache2/ssl/default.crt && -f /etc/apache2/ssl/domains.ext ]]; then
    openssl req -new -nodes -newkey rsa:2048 -keyout "/etc/apache2/ssl/default.key" -out "/etc/apache2/ssl/default.csr" -subj "/CN=default/O=default/C=UK"
    openssl x509 -req -sha256 -days 1024 -in "/etc/apache2/ssl/default.csr" -CA "/etc/apache2/ssl/RootCA.pem" -CAkey "/etc/apache2/ssl/RootCA.key" -CAcreateserial -extfile "/etc/apache2/ssl/domains.ext" -out "/etc/apache2/ssl/default.crt"
    chmod 644 /etc/apache2/ssl/default.key
  fi

  a2enmod rewrite
  a2enmod headers
  a2enmod proxy proxy_html proxy_http xml2enc ssl http2
  service apache2 restart
fi

# Start apache in foreground
/usr/sbin/apache2ctl -D FOREGROUND
