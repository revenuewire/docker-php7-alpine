FROM alpine:3.7
MAINTAINER Scott Wang <swang@revenuewire.com>

RUN set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data

RUN apk --update add apache2 php7 php7-cli php7-apache2 \
        php7-curl php7-apcu php7-json php7-opcache php7-bcmath php7-xml \
        php7-mcrypt php7-simplexml php7-mbstring \
        bash

ENV HTTPD_PREFIX /var/www/html
RUN mkdir -p "$HTTPD_PREFIX" \
	&& chown www-data:www-data "$HTTPD_PREFIX" \
	&& mkdir /run/apache2

COPY conf/php.ini /etc/php7/php.ini
COPY conf/httpd.conf /etc/apache2/httpd.conf
COPY index.php /var/www/html/
ADD run-http.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-http.sh

EXPOSE 80
CMD ["run-http.sh"]