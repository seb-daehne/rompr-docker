FROM nginx:1.17-alpine

ENV rompr_version=1.32

RUN apk --no-cache upgrade
RUN apk --no-cache add \
 php7-curl \
 php7-sqlite3 \
 php7-gd \
 php7-json \
 php7-xml \
 php7-mbstring \
 php7-fpm \
 imagemagick \
 unzip

ADD ./nginx.conf /etc/nginx/conf.d/default.conf
RUN mkdir /rompr &&\
    cd /rompr && \
    wget -O - https://github.com/fatg3erman/RompR/releases/download/${rompr_version}}/rompr-${rompr_version}.zip && \
    unzip rompr-${rompr_version}}.zip && \
    rm rompr-${rompr_version}}.zip
