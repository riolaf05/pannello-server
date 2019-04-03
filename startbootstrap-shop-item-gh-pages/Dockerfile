FROM centos:latest

RUN yum -y install httpd

RUN mkdir /var/www/html/pannello_controllo

COPY -R pannello_controllo/* /var/www/html/pannello_controllo/

CMD [“/usr/sbin/httpd”, “-D”, “FOREGROUND”]

EXPOSE 80