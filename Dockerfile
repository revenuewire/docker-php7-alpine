FROM alpine:3.9
MAINTAINER Scott Wang <swang@revenuewire.com>

# trust this project public key to trust the packages.
ADD https://dl.bintray.com/php-alpine/key/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
# make sure you can use HTTPS
RUN apk --update add ca-certificates
# add the repository, make sure you replace the correct versions if you want.
RUN echo "https://dl.bintray.com/php-alpine/v3.9/php-7.3" >> /etc/apk/repositories

RUN set -x \
	&& addgroup -g 82 -S www-data \
	&& adduser -u 82 -D -S -G www-data www-data

RUN apk --update add apache2 php php-cli php-apache2 php-ctype php-openssl \
        php-curl php-apcu php-json php-opcache php-bcmath php-xml \
        php-intl php-iconv php-mbstring php-session php-common \
        bash

ENV HTTPD_PREFIX /var/src/html
RUN mkdir -p "$HTTPD_PREFIX" \
	&& chown www-data:www-data "$HTTPD_PREFIX"

COPY conf/php.ini /etc/php7/php.ini
COPY conf/httpd.conf /etc/apache2/httpd.conf
COPY index.php /var/src/html
ADD run-http.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-http.sh

EXPOSE 80
CMD ["run-http.sh"]