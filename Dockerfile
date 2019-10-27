FROM ubuntu:18.04
MAINTAINER shandy <shandy@semuada.com>
LABEL Description="Cutting-edge LAMP stack, based on Ubuntu 18.04 LTS. Includes .htaccess support and popular PHP7.2 features, including composer and mail() function." \
	License="Apache License 2.0" \
	Usage="docker run -d -p [HOST WWW PORT NUMBER]:80 -p [HOST DB PORT NUMBER]:3306 -v [HOST WWW DOCUMENT ROOT]:/var/www/html -v [HOST DB DOCUMENT ROOT]:/var/lib/mysql shandy/lamp" \
	Version="18.04"


RUN apt-get update --fix-missing
RUN apt-get upgrade -y

# set noninteractive installation
RUN export DEBIAN_FRONTEND=noninteractive
#install tzdata package
RUN apt-get install -y tzdata
# set your timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata


COPY debconf.selections /tmp/
RUN debconf-set-selections /tmp/debconf.selections

RUN apt-get install -y zip unzip
RUN apt-get install -y \
	php7.2 \
	php7.2-bz2 \
	php7.2-cgi \
	php7.2-cli \
	php7.2-common \
	php7.2-curl \
	php7.2-dev \
	php7.2-enchant \
	php7.2-fpm \
	php7.2-gd \
	php7.2-gmp \
	php7.2-imap \
	php7.2-interbase \
	php7.2-intl \
	php7.2-json \
	php7.2-ldap \
	php7.2-mbstring \
	php7.2-mysql \
	php7.2-odbc \
	php7.2-opcache \
	php7.2-pgsql \
	php7.2-phpdbg \
	php7.2-pspell \
	php7.2-readline \
	php7.2-recode \
	php7.2-snmp \
	php7.2-sqlite3 \
	php7.2-sybase \
	php7.2-tidy \
	php7.2-xmlrpc \
	php7.2-xsl \
	php7.2-zip
RUN apt-get install apache2 libapache2-mod-php7.2 -y
RUN apt-get install mariadb-common mariadb-server mariadb-client -y
RUN apt-get install postfix -y
RUN apt-get install git composer tree vim curl ftp -y

ENV LOG_STDOUT **Boolean**
ENV LOG_STDERR **Boolean**
ENV LOG_LEVEL warn
ENV ALLOW_OVERRIDE All
ENV DATE_TIMEZONE UTC
ENV TERM dumb

COPY index.php /var/www/html/
COPY run-lamp.sh /usr/sbin/
COPY phpinfo/* /var/www/html/phpinfo/

RUN a2enmod rewrite
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN chmod +x /usr/sbin/run-lamp.sh
RUN chown -R www-data:www-data /var/www/html

VOLUME /var/www/html
VOLUME /var/log/httpd
VOLUME /var/lib/mysql
VOLUME /var/log/mysql
VOLUME /etc/apache2

EXPOSE 80
EXPOSE 3306

CMD ["/usr/sbin/run-lamp.sh"]
