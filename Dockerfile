FROM docker.inradar.net/ubuntu-18.04-boost:0.1.2

RUN apt-get -y update && apt-get -y install \
    libidn11 \
    xvfb
