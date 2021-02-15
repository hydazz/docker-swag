FROM vcxpz/baseimage-alpine:latest

# set version label
ARG BUILD_DATE
LABEL maintainer="hydaz"

# environment settings
ENV DHLEVEL=2048 \
	ONLY_SUBDOMAINS=false \
	AWS_CONFIG_FILE=/config/dns-conf/route53.ini \
	S6_BEHAVIOUR_IF_STAGE2_FAILS=2

RUN \
	echo "**** install build packages ****" && \
	apk add --no-cache --virtual=build-dependencies \
		cargo \
		g++ \
		gcc \
		libffi-dev \
		openssl-dev \
		python3-dev && \
	echo "**** install runtime packages ****" && \
	apk add --no-cache --upgrade \
		fail2ban \
		ffmpeg \
		gnu-libiconv \
		gnupg \
		libxml2 \
		nginx-mod-http-brotli \
		nginx-mod-http-dav-ext \
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
		nginx-mod-mail \
		nginx-mod-rtmp \
		nginx-mod-stream \
		nginx-vim \
		php7-bcmath \
		php7-bz2 \
		php7-ctype \
		php7-curl \
		php7-dom \
		php7-exif \
		php7-ftp \
		php7-gd \
		php7-gmp \
		php7-iconv \
		php7-imap \
		php7-intl \
		php7-ldap \
		php7-mysqli \
		php7-mysqlnd \
		php7-opcache \
		php7-pcntl \
		php7-pdo_mysql \
		php7-pdo_odbc \
		php7-pecl-apcu \
		php7-pecl-imagick \
		php7-pecl-mcrypt \
		php7-pecl-memcached \
		php7-pecl-redis \
		php7-phar \
		php7-posix \
		php7-soap \
		php7-sockets \
		php7-sodium \
		php7-tokenizer \
		php7-xml \
		php7-xmlreader \
		php7-xmlrpc \
		php7-xsl \
		php7-zip \
		py3-cryptography \
		py3-future \
		py3-pip \
		whois && \
	echo "**** install certbot plugins ****" && \
	pip3 install -U \
		pip && \
	pip3 install -U \
		certbot \
		certbot-dns-cloudflare \
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
	curl --silent -o \
		/tmp/proxy.tar.gz -L \
		"https://github.com/linuxserver/reverse-proxy-confs/tarball/master" && \
	tar xf \
		/tmp/proxy.tar.gz -C \
		/defaults/proxy-confs --strip-components=1 --exclude=linux*/README.md --exclude=linux*/.gitattributes --exclude=linux*/.github --exclude=linux*/.gitignore --exclude=linux*/LICENSE && \
	echo "**** configure nginx ****" && \
	rm -f /etc/nginx/conf.d/default.conf && \
	curl --silent -o \
		/defaults/dhparams.pem -L \
		"https://lsio.ams3.digitaloceanspaces.com/dhparams.pem" && \
	echo "**** cleanup ****" && \
	apk del --purge \
		build-dependencies && \
	for cleanfiles in *.pyc *.pyo; do \
		find /usr/lib/python3.* -iname "${cleanfiles}" -delete; \
	done && \
	rm -rf \
		/tmp/* \
		/root/.cache \
		/root/.cargo

# http healthcheck
HEALTHCHECK --start-period=10s --timeout=5s \
	CMD curl --fail 'http://localhost/' || exit 1

# add local files
COPY root/ /
