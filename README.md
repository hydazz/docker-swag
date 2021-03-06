## docker-swag

[![docker hub](https://img.shields.io/badge/docker_hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/r/vcxpz/swag) ![docker image size](https://img.shields.io/docker/image-size/vcxpz/swag?style=for-the-badge&logo=docker) [![auto build](https://img.shields.io/badge/docker_builds-automated-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-swag/actions?query=workflow%3A"Auto+Builder+CI") [![codacy branch grade](https://img.shields.io/codacy/grade/df6f0af2764c4b55ae183c3088b9d3d8/main?style=for-the-badge&logo=codacy)](https://app.codacy.com/gh/hydazz/docker-swag)

**This is an unofficial image that has been modified for my own needs. If my needs match your needs, feel free to use this image at your own risk.**

Fork of [linuxserver/docker-swag](https://github.com/linuxserver/docker-swag/) (Equivalent to 1.16.0-ls63)

SWAG - Secure Web Application Gateway (formerly known as letsencrypt, no relation to Let's Encrypt™) sets up an Nginx webserver and reverse proxy with php support and a built-in certbot client that automates free SSL server certificate generation and renewal processes (Let's Encrypt and ZeroSSL). It also contains fail2ban for intrusion prevention.

## Usage

```bash
docker run -d \
  --name=swag \
  --cap-add=NET_ADMIN \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Australia/Melbourne \
  -e URL=yourdomain.url \
  -e SUBDOMAINS=www, \
  -e VALIDATION=http \
  -e CERTPROVIDER= #optional \
  -e DNSPLUGIN=cloudflare #optional \
  -e PROPAGATION= #optional \
  -e DUCKDNSTOKEN= #optional \
  -e EMAIL= #optional \
  -e ONLY_SUBDOMAINS=false #optional \
  -e EXTRA_DOMAINS= #optional \
  -e STAGING=false #optional \
  -e MAXMINDDB_LICENSE_KEY= #optional \
  -p 443:443 \
  -p 80:80 #optional \
  -v <path to appdata>:/config \
  --restart unless-stopped \
  vcxpz/swag
```

**Read the official [README.md](https://github.com/linuxserver/docker-swag/) for more information**

## Custom Commands

### _swag_ Command

This image also features the _swag_ command, which is a script I made to test the configuration.

_swag_ usage example:

| Function                 | Usage           |
| ------------------------ | --------------- |
| Test Nginx Configuration | swag nginx test |
| Test php.ini             | swag php test   |

## Fixing Appdata Permissions

If you ever accidentally screw up the permissions on the appdata folder, run `fix-perms` within the container. This will restore most of the files/folders with the correct permissions.
