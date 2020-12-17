FROM vcxpz/baseimage-alpine

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Split of Linuxserver.io version: ${VERSION} Build-date: ${BUILD_DATE}"
LABEL maintainer="hydaz"

# environment settings
ENV DHLEVEL=2048 ONLY_SUBDOMAINS=false
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	libffi-dev \
	openssl-dev \
	python3-dev && \
 echo "**** install packages ****" && \
 apk add --no-cache --upgrade \
	curl \
	apache2-utils \
	git \
	libressl3.1-libssl \
	logrotate \
	nano \
	openssl \
	fail2ban \
	gnupg \
	nginx \
	nginx-mod-http-echo \
	nginx-mod-http-fancyindex \
	nginx-mod-http-headers-more \
	nginx-mod-http-image-filter \
	nginx-mod-http-nchan \
	nginx-mod-http-perl \
	nginx-mod-http-redis2 \
	nginx-mod-http-set-misc \
	nginx-mod-http-upload-progress \
	nginx-mod-http-xslt-filter \
	nginx-mod-http-geoip2 \
	nginx-mod-mail \
	nginx-mod-rtmp \
	nginx-mod-stream \
	nginx-mod-stream-geoip2 \
	nginx-vim \
	php7 \
 	php7-fpm \
	php7-fileinfo \
	php7-json \
	php7-mbstring \
	php7-openssl \
	php7-session \
	php7-simplexml \
	php7-xmlwriter \
	php7-zlib \
	php7-bcmath \
	php7-bz2 \
	php7-ctype \
	php7-curl \
	php7-dom \
	php7-exif \
	php7-ftp \
	php7-gd \
	php7-iconv \
	php7-imap \
	php7-intl \
	php7-ldap \
	php7-mysqli \
	php7-mysqlnd \
	php7-opcache \
	php7-pdo_mysql \
	php7-pear \
	php7-pecl-apcu \
	php7-pecl-redis \
	php7-phar \
	php7-posix \
	php7-soap \
	php7-sockets \
	php7-sodium \
	php7-tokenizer \
	php7-xml \
	php7-apcu \
	php7-xmlreader \
	php7-gmp \
	php7-imagick \
	php7-mcrypt \
	php7-opcache \
	php7-pcntl \
	php7-redis \
	php7-xmlrpc \
	php7-xsl \
	php7-zip \
	py3-cryptography \
	py3-future \
	py3-pip \
	samba-client \
	sudo \
	tar \
	unzip \
	imagemagick \
	whois && \
  echo "**** configure nginx ****" && \
  echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
 	/etc/nginx/fastcgi_params && \
  rm -f /etc/nginx/conf.d/default.conf && \
  echo "**** fix logrotate ****" && \
  sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' \
 	/etc/periodic/daily/logrotate && \
 echo "**** install certbot plugins ****" && \
 pip3 install -U \
	pip && \
 pip3 install -U \
	certbot \
	certbot-dns-aliyun \
	certbot-dns-cloudflare \
	certbot-dns-cloudxns \
	certbot-dns-cpanel \
	certbot-dns-digitalocean \
	certbot-dns-dnsimple \
	certbot-dns-dnsmadeeasy \
	certbot-dns-domeneshop \
	certbot-dns-google \
	certbot-dns-inwx \
	certbot-dns-linode \
	certbot-dns-luadns \
	certbot-dns-netcup \
	certbot-dns-njalla \
	certbot-dns-nsone \
	certbot-dns-ovh \
	certbot-dns-rfc2136 \
	certbot-dns-route53 \
	certbot-dns-transip \
	certbot-plugin-gandi \
	cryptography \
	requests && \
 echo "**** remove unnecessary fail2ban filters ****" && \
 rm \
	/etc/fail2ban/jail.d/alpine-ssh.conf && \
 echo "**** copy fail2ban default action and filter to /default ****" && \
 mkdir -p /defaults/fail2ban && \
 mv /etc/fail2ban/action.d /defaults/fail2ban/ && \
 mv /etc/fail2ban/filter.d /defaults/fail2ban/ && \
 echo "**** copy proxy confs to /default ****" && \
 mkdir -p /defaults/proxy-confs && \
 curl -o \
	/tmp/proxy.tar.gz -L \
	"https://github.com/linuxserver/reverse-proxy-confs/tarball/master" && \
 tar xf \
	/tmp/proxy.tar.gz -C \
	/defaults/proxy-confs --strip-components=1 --exclude=linux*/.gitattributes --exclude=linux*/.github --exclude=linux*/.gitignore --exclude=linux*/LICENSE && \
 echo "**** configure nginx ****" && \
 rm -f /etc/nginx/conf.d/default.conf && \
 curl -o \
	/defaults/dhparams.pem -L \
	"https://lsio.ams3.digitaloceanspaces.com/dhparams.pem" && \
 echo "**** cleanup ****" && \
 for cleanfiles in *.pyc *.pyo; \
	do \
	find /usr/lib/python3.*  -iname "${cleanfiles}" -exec rm -f '{}' + \
	; done && \
 echo "**** install build packages for nextcloud ****" && \
 apk add --no-cache --virtual=build-dependencies-nextcloud --upgrade \
  	autoconf \
  	automake \
  	file \
  	g++ \
  	gcc \
  	make \
  	php7-dev \
  	re2c \
  	samba-dev \
  	zlib-dev && \
 echo "**** compile smbclient ****" && \
 git clone git://github.com/eduardok/libsmbclient-php.git /tmp/smbclient && \
 cd /tmp/smbclient && \
 phpize7 && \
 ./configure \
	--with-php-config=/usr/bin/php-config7 && \
 make && \
 make install && \
 echo "**** configure php and nginx for Nextcloud ****" && \
 echo "extension="smbclient.so"" > /etc/php7/conf.d/00_smbclient.ini && \
 echo 'apc.enable_cli=1' >> /etc/php7/conf.d/apcu.ini && \
 sed -i \
	'/opcache.enable=1/a opcache.enable_cli=1' \
		/etc/php7/php.ini && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies \
	build-dependencies-nextcloud && \
 rm -rf \
	/tmp/* \
	/root/.cache

# check nginx configs
HEALTHCHECK CMD nginx -t -c /config/nginx/nginx.conf || exit 1

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config
