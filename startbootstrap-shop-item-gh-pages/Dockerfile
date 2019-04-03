FROM ubuntu 

RUN apt-get update 

RUN apt-get install -y apache2 

RUN apt-get install -y apache2-utils 

RUN apt-get clean 

RUN mkdir /var/www/html/pannello_controllo

COPY pannello_controllo/ /var/www/html/pannello_controllo/

CMD ["apache2ctl", "-D", "FOREGROUND"]