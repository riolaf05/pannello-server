FROM ubuntu:latest

MAINTAINER Rio<onslaught89@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
# Install basics
RUN apt-get update
RUN apt-get install -y software-properties-common && \
add-apt-repository ppa:ondrej/php && apt-get update
RUN apt-get install -y --force-yes curl
# Install PHP 5.6
RUN apt-get install -y --allow-unauthenticated php5.6 php5.6-mysql php5.6-mcrypt php5.6-cli php5.6-gd php5.6-curl
# Enable apache mods.
RUN a2enmod php5.6
RUN a2enmod rewrite
# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/5.6/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/5.6/apache2/php.ini
# Manually set up the apache environment variables
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid 

RUN mkdir /var/www/html/pannello_controllo

COPY pannello_controllo/ /var/www/html/pannello_controllo/

RUN a2enmod ssl

RUN mkdir /etc/apache2/ssl

COPY apache.key /etc/apache2/ssl

COPY apache.pem /etc/apache2/ssl

RUN a2ensite default-ssl

RUN service apache2 reload

CMD ["apache2ctl", "-D", "FOREGROUND"]