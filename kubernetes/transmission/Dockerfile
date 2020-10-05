FROM armv7/ubuntu:16.04
RUN add-apt-repository ppa:transmissionbt/ppa
RUN apt-get install software-properties-common
RUN apt-get update
RUN apt-get install -y transmission-cli transmission-common

COPY settings.json /var/lib/transmission-daemon/info/settings.json

CMD ["service", "transmission-daemon", "start"]