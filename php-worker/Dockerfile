#
#--------------------------------------------------------------------------
# Image Setup
#--------------------------------------------------------------------------
#

ARG LARADOCK_PHP_VERSION
FROM php:${LARADOCK_PHP_VERSION}-alpine3.15

LABEL maintainer="Mahmoud Zalt <mahmoud@zalt.me>"

ARG LARADOCK_PHP_VERSION

RUN apk --update add wget \
  curl \
  git \
  build-base \
  libmcrypt-dev \
  libxml2-dev \
  pcre-dev \
  zlib-dev \
  autoconf \
  cyrus-sasl-dev \
  libgsasl-dev \
  oniguruma-dev \
  libressl \
  libressl-dev \
  supervisor


RUN pecl channel-update pecl.php.net; \
  docker-php-ext-install mysqli mbstring pdo pdo_mysql xml pcntl; \
  if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ] && [ $(php -r "echo PHP_MINOR_VERSION;") = "1" ]; then \
    php -m | grep -q 'tokenizer'; \
  else \
    docker-php-ext-install tokenizer; \
  fi

# Add a non-root user:
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

RUN addgroup -g ${PGID} laradock && \
  adduser -D -G laradock -u ${PUID} laradock

#Install BZ2:
ARG INSTALL_BZ2=false
RUN if [ ${INSTALL_BZ2} = true ]; then \
  apk --update add bzip2-dev; \
  docker-php-ext-install bz2; \
  fi

###########################################################################
# PHP GnuPG:
###########################################################################

ARG INSTALL_GNUPG=false

RUN set -eux; if [ ${INSTALL_GNUPG} = true ]; then \
  apk add --no-cache --no-progress --virtual BUILD_DEPS_PHP_GNUPG gpgme-dev; \
  apk add --no-cache --no-progress gpgme; \
  pecl install gnupg; \
  docker-php-ext-enable gnupg; \
  fi

#Install LDAP
ARG INSTALL_LDAP=false;
RUN set -eux; if [ ${INSTALL_LDAP} = true ]; then \
  apk add --no-cache --no-progress openldap-dev; \
  docker-php-ext-install ldap; \
  php -m | grep -oiE '^ldap$'; \
  fi

#Install GD package:
ARG INSTALL_GD=false
RUN if [ ${INSTALL_GD} = true ]; then \
  apk add --update --no-cache freetype-dev libjpeg-turbo-dev jpeg-dev libpng-dev; \
  if [ $(php -r "echo PHP_MAJOR_VERSION;") = "7" ] && [ $(php -r "echo PHP_MINOR_VERSION;") = "4" ]; then \
  docker-php-ext-configure gd --with-freetype --with-jpeg; \
  else \
  docker-php-ext-configure gd --with-freetype-dir=/usr/lib/ --with-jpeg-dir=/usr/lib/ --with-png-dir=/usr/lib/; \
  fi; \
  docker-php-ext-install gd \
  ;fi

#Install ImageMagick:
ARG INSTALL_IMAGEMAGICK=false
ARG IMAGEMAGICK_VERSION=latest
ENV IMAGEMAGICK_VERSION ${IMAGEMAGICK_VERSION}
RUN set -eux; \
  if [ ${INSTALL_IMAGEMAGICK} = true ]; then \
  apk add --update --no-cache imagemagick-dev imagemagick; \
  if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
  cd /tmp && \
  if [ ${IMAGEMAGICK_VERSION} = "latest" ]; then \
  git clone https://github.com/Imagick/imagick; \
  else \
  git clone --branch ${IMAGEMAGICK_VERSION} https://github.com/Imagick/imagick; \
  fi && \
  cd imagick && \
  phpize && \
  ./configure && \
  make && \
  make install && \
  rm -r /tmp/imagick; \
  else \
  pecl install imagick; \
  fi && \
  docker-php-ext-enable imagick; \
  php -m | grep -q 'imagick'; \
  fi

#Install GMP package:
ARG INSTALL_GMP=false
RUN if [ ${INSTALL_GMP} = true ]; then \
  apk add --update --no-cache gmp gmp-dev \
  && docker-php-ext-install gmp \
  ;fi

#Install BCMath package:
ARG INSTALL_BCMATH=false
RUN if [ ${INSTALL_BCMATH} = true ]; then \
  docker-php-ext-install bcmath \
  ;fi

#Install SOAP package:
ARG INSTALL_SOAP=false
RUN if [ ${INSTALL_SOAP} = true ]; then \
  docker-php-ext-install soap \
  ;fi

# Install ZipArchive:
ARG INSTALL_ZIP_ARCHIVE=false
RUN set -eux; \
  if [ ${INSTALL_ZIP_ARCHIVE} = true ]; then \
  apk --update add libzip-dev && \
  if [ ${LARADOCK_PHP_VERSION} = "7.3" ] || [ ${LARADOCK_PHP_VERSION} = "7.4" ] || [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
  docker-php-ext-configure zip; \
  else \
  docker-php-ext-configure zip --with-libzip; \
  fi && \
  # Install the zip extension
  docker-php-ext-install zip \
  ;fi

# Install MySQL Client:
ARG INSTALL_MYSQL_CLIENT=false
RUN if [ ${INSTALL_MYSQL_CLIENT} = true ]; then \
  apk --update add mysql-client \
  ;fi

# Install FFMPEG:
ARG INSTALL_FFMPEG=false
RUN if [ ${INSTALL_FFMPEG} = true ]; then \
  apk --update add ffmpeg \
  ;fi

# Install Redis package:
ARG INSTALL_REDIS=false
RUN if [ ${INSTALL_REDIS} = true ]; then \
  # Install Redis Extension
  if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
  printf "\n" | pecl install -o -f redis-4.3.0; \
  else \
  printf "\n" | pecl install -o -f redis; \
  fi; \
  rm -rf /tmp/pear; \
  docker-php-ext-enable redis \
  ;fi

###########################################################################
# Swoole EXTENSION
###########################################################################

ARG INSTALL_SWOOLE=false

RUN if [ ${INSTALL_SWOOLE} = true ]; then \
  # Install Php Swoole Extension
  if [ $(php -r "echo PHP_VERSION_ID - PHP_RELEASE_VERSION;") = "50600" ]; then \
    echo '' | pecl -q install swoole-2.0.10; \
  elif [ $(php -r "echo PHP_VERSION_ID - PHP_RELEASE_VERSION;") = "70000" ]; then \
    echo '' | pecl -q install swoole-4.3.5; \
  elif [ $(php -r "echo PHP_VERSION_ID - PHP_RELEASE_VERSION;") = "70100" ]; then \
    echo '' | pecl -q install swoole-4.5.11; \
  else \
    echo '' | pecl -q install swoole; \
  fi; \
  docker-php-ext-enable swoole \
  && php -m | grep -q 'swoole' \
;fi

###########################################################################
# Imap EXTENSION
###########################################################################

ARG INSTALL_IMAP=false

RUN if [ ${INSTALL_IMAP} = true ]; then \
  apk add --update imap-dev && \
  docker-php-ext-configure imap --with-imap --with-imap-ssl && \
  docker-php-ext-install imap \
  ;fi

###########################################################################
# XMLRPC:
###########################################################################

ARG INSTALL_XMLRPC=false

RUN if [ ${INSTALL_XMLRPC} = true ]; then \
  if [ $(php -r "echo PHP_MAJOR_VERSION;") = "8" ]; then \
  pecl install xmlrpc-1.0.0RC3; \
  docker-php-ext-enable xmlrpc; \
  else \
  docker-php-ext-install xmlrpc; \
  fi; \
  php -m | grep -r 'xmlrpc'; \
  fi

#
#--------------------------------------------------------------------------
# Optional Supervisord Configuration
#--------------------------------------------------------------------------
#
# Modify the ./supervisor.conf file to match your App's requirements.
# Make sure you rebuild your container with every change.
#

COPY supervisord.conf /etc/supervisord.conf

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisord.conf"]

#
#--------------------------------------------------------------------------
# Optional Software's Installation
#--------------------------------------------------------------------------
#
# If you need to modify this image, feel free to do it right here.
#

###########################################################################
# Install Mailhog:
###########################################################################

RUN apk --update add ssmtp && \
    sed -e s/mailhub=mail/mailhub=mailhog:1025/g /etc/ssmtp/ssmtp.conf > ssmtp.conf.tmp && \
    mv ssmtp.conf.tmp /etc/ssmtp/ssmtp.conf

#
#--------------------------------------------------------------------------
# Check PHP version
#--------------------------------------------------------------------------
#

RUN php -v | head -n 1 | grep -q "PHP ${PHP_VERSION}."

#
#--------------------------------------------------------------------------
# Final Touch
#--------------------------------------------------------------------------
#

# Clean up
RUN rm /var/cache/apk/* \
  && mkdir -p /var/www

WORKDIR /etc/supervisor/conf.d/
