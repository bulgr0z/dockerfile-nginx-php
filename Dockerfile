# nginx/php
# VERSION 0.1

FROM ubuntu:14.04
MAINTAINER Paul Sore <paul.sore@gmail.com>

# Get some security updates
RUN apt-get update
RUN apt-get -y upgrade

# install nginx, php5 and supervisor
RUN apt-get -y install nginx
RUN apt-get -y install php5-fpm
RUN apt-get -y install supervisor

# Add our config files
ADD conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf
ADD conf/php-fpm.conf /etc/php5/fpm/php-fpm.conf
ADD conf/php.ini /etc/php5/fpm/php.ini

# disable the daemons for nginx & php
# RUN echo "daemon off;" >> /etc/nginx/nginx.conf
# RUN sed -i "s/;daemonize = yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# sites volume
RUN mkdir /home/www
RUN echo "<?php phpinfo() ?>" > /home/www/index.php

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/sites-available", "/home/www"]
# Path to your conf file & sites-* .
# Mount with `-v <data-dir>:/etc/nginx/sites-enabled`

# expose service port
EXPOSE 80

CMD ["/usr/bin/supervisord"]

# docker run -d -p 95.85.30.201:80:80 -v /home/dockerfiles/nginx/sites-enabled:/etc/nginx/sites-enabled -v /home/dockerfiles/nginx/web:/home/www bulgroz/nginx
# docker build --no-cache=true  -t bulgroz/nginx .
