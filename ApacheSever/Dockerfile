FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin

RUN ln -snf /usr/share/zoneinfo/$TZ && echo $TZ -> /etc/timezone

RUN \
apt-get update && \
apt-get -y install apache2

COPY index.html /var/www/html/index.html

EXPOSE 80

CMD ["apachectl", "-D", "FOREGROUND"]

