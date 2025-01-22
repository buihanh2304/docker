ARG MYSQL_VERSION
FROM mysql:${MYSQL_VERSION}

LABEL maintainer="Mahmoud Zalt <mahmoud@zalt.me>"

#####################################
# Set Timezone
#####################################

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && chown -R mysql:root /var/lib/mysql/

COPY my.cnf /etc/mysql/conf.d/my.cnf

RUN chmod 0444 /etc/mysql/conf.d/my.cnf

RUN if [ ${MYSQL_MAJOR} != "5.7" ] && [ ${MYSQL_MAJOR} != "8.0" ]; then \
  sed -i "s/default-authentication-plugin=mysql_native_password/mysql_native_password=ON/" /etc/mysql/conf.d/my.cnf \
;fi


CMD ["mysqld"]

EXPOSE 3306
