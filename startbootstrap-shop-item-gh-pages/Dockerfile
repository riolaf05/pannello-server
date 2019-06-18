#FROM arm32v7/ubuntu:16.04
FROM arm32v7/ubuntu:16.04

MAINTAINER Rio<onslaught89@gmail.com>
ENV DEBIAN_FRONTEND noninteractive

# Compatibility with x86 hosts (see: https://ownyourbits.com/2018/06/27/running-and-building-arm-docker-containers-in-x86/)
COPY qemu-arm-static /usr/bin/

# Install basics
RUN apt-get update
RUN apt-get install -y apache2 libapache2-mod-php curl php7.0-mbstring php7.0-zip php7.0-xml

# Update the PHP.ini file, enable <? ?> tags and quieten logging.
RUN sed -i "s/short_open_tag = Off/short_open_tag = On/" /etc/php/7.0/apache2/php.ini
RUN sed -i "s/error_reporting = .*$/error_reporting = E_ERROR | E_WARNING | E_PARSE/" /etc/php/7.0/apache2/php.ini

# Manually set up the apache environment variables
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid 

RUN mkdir /var/www/html/pannello_controllo

COPY pannello_controllo/ /var/www/html/pannello_controllo/

RUN a2enmod ssl

RUN mkdir /etc/apache2/ssl

#RUN openssl req -new -newkey rsa:4096 -days 3650 -nodes -x509 -subj "/C=../ST=...../L=..../O=..../CN=..." -keyout ./ssl.key -out ./ssl.crt

#COPY $HOME/ssl.crt /etc/apache2/ssl/ssl.crt

#COPY ./ssl.key /etc/apache2/ssl/ssl.key

RUN mkdir -p /var/run/apache2/

#RUN sed -i 's|80|443|g' /etc/apache2/sites-enabled/000-default.conf

#RUN a2ensite default-ssl

#RUN service apache2 reload

CMD ["apache2ctl", "-D", "FOREGROUND"]
