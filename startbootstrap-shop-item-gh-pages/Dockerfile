FROM ubuntu 

RUN apt-get update 

RUN apt-get install -y apache2 

RUN apt-get install -y apache2-utils 

RUN apt-get clean 

RUN mkdir /var/www/html/pannello_controllo

COPY pannello_controllo/ /var/www/html/pannello_controllo/

RUN a2enmod ssl

RUN mkdir /etc/apache2/ssl

COPY apache.key /etc/apache2/ssl

COPY apache.pem /etc/apache2/ssl

RUN a2ensite default-ssl

RUN service apache2 reload

CMD ["apache2ctl", "-D", "FOREGROUND"]