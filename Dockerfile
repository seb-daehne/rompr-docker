FROM php:apache

ENV rompr_version=2.16

RUN apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install \
    imagemagick \
    unzip \
    wget && \
    apt-get clean

RUN cd /var/www/html && \
    wget https://github.com/fatg3erman/RompR/releases/download/${rompr_version}/rompr-${rompr_version}.zip && \
    unzip rompr-${rompr_version}.zip && \
    mv rompr/* . && \
    mkdir prefs && \
    chown -R www-data.www-data prefs && \
    mkdir albumart && \
    chown -R www-data.www-data albumart && \
    rm rompr-${rompr_version}.zip 

#ADD ./nginx.conf /etc/nginx/conf.d/site.conf
