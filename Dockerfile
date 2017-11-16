FROM debian:jessie

MAINTAINER Steffen Ewald <steffen.blogdns@googlemail.com>

ENV FHEM_VERSION 5.8
ENV DEBIAN_FRONTEND noninteractive
ENV TERM xterm

# Install dependencies
RUN apt-get update
RUN apt-get -y --force-yes install apt-utils
RUN apt-get upgrade -y --force-yes
RUN apt-get -y --force-yes install supervisor telnet wget git nano make gcc g++ apt-transport-https sudo perl build-essential snmpd snmp usbutils

# Install perl packages
RUN apt-get -y --force-yes install \
libavahi-compat-libdnssd-dev \
libalgorithm-merge-perl \
libclass-dbi-mysql-perl \
libclass-isa-perl \
libcommon-sense-perl \
libdatetime-format-strptime-perl \
libdbi-perl \
libdevice-serialport-perl \
libdpkg-perl \
liberror-perl \
libfile-copy-recursive-perl \
libfile-fcntllock-perl \
libio-socket-ip-perl \
libio-socket-ssl-perl \
libjson-perl \
libjson-xs-perl \
libmail-sendmail-perl \
libsocket-perl \
libswitch-perl \
libsys-hostname-long-perl \
libterm-readkey-perl \
libterm-readline-perl-perl \
libwww-perl \
libxml-simple-perl \
libdbd-sqlite3-perl \
libtext-diff-perl

# Install fhem
RUN echo Europe/Berlin > /etc/timezone && dpkg-reconfigure tzdata

RUN wget -qO - https://debian.fhem.de/archive.key | apt-key add -
RUN echo "deb https://debian.fhem.de/nightly ./" > /etc/apt/sources.list.d/fhem.list
RUN apt-get update
RUN apt-get -y --force-yes install fhem
RUN mkdir -p /var/log/supervisor

RUN mkdir /script
RUN mkdir /git_clone
RUN cd /git_clone
RUN wget https://raw.githubusercontent.com/Ewies/docker/master/supervisord.conf
RUN wget https://raw.githubusercontent.com/Ewies/docker_final/master/start.sh
RUN cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN cp start.sh /script
RUN chmod +x /script/start.sh
# Ports
EXPOSE 8083
