## docker-swag
[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/vcxpz/swag) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/swag?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/docker_builds-automated-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-swag/actions?query=workflow%3A"Auto+Builder+CI")

Fork of [linuxserver/docker-swag](https://github.com/linuxserver/docker-swag/)

SWAG - Secure Web Application Gateway (formerly known as letsencrypt, no relation to Let's Encrypt™) sets up an Nginx webserver and reverse proxy with php support and a built-in certbot client that automates free SSL server certificate generation and renewal processes (Let's Encrypt and ZeroSSL). It also contains fail2ban for intrusion prevention.

## Version Information
![alpine](https://img.shields.io/badge/alpine-edge-0D597F?style=for-the-badge&logo=alpine-linux) ![s6 overlay](https://img.shields.io/badge/s6_overlay-2.1.0.2-blue?style=for-the-badge) ![nginx](https://img.shields.io/badge/nginx-1.18.0-269539?style=for-the-badge&logo=nginx) ![php](https://img.shields.io/badge/php-7.4.14-777BB4?style=for-the-badge&logo=php)

**[See here for a list of packages](https://github.com/hydazz/docker-swag/blob/main/package_versions.txt)**

## Usage
```
docker run -d \
  --name=swag \
  --cap-add=NET_ADMIN \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -e URL=yourdomain.url \
  -e SUBDOMAINS=www, \
  -e VALIDATION=http \
  -e CERTPROVIDER= `#optional` \
  -e DNSPLUGIN=cloudflare `#optional` \
  -e PROPAGATION= `#optional` \
  -e DUCKDNSTOKEN= `#optional` \
  -e EMAIL= `#optional` \
  -e ONLY_SUBDOMAINS=false `#optional` \
  -e EXTRA_DOMAINS= `#optional` \
  -e STAGING=false `#optional` \
  -e MAXMINDDB_LICENSE_KEY= `#optional` \
  -p 443:443 \
  -p 80:80 `#optional` \
  -v <path to appdata>:/config \
  --restart unless-stopped \
  vcxpz/swag
```

**Read the official [README](https://github.com/linuxserver/docker-swag/) for more information**

## Custom Commands
### *swag* Command
This image also features the *swag* command, which is a script I made so you don't have to restart the whole container to apply configuration changes or to test the configuration.

*swag* usage example:

| Function | Usage |
| - | - |
| Test Nginx Configuration | swag nginx test |
| Restart Nginx | swag nginx restart |
| Restart PHP-FPM | swag php restart |
| Test php.ini | swag php test |
