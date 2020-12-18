## Alpine Edge fork of [linuxserver/docker-swag](https://github.com/linuxserver/docker-swag/)

SWAG - Secure Web Application Gateway (formerly known as letsencrypt, no relation to Let's Encrypt™) sets up an Nginx webserver and reverse proxy with php support and a built-in certbot client that automates free SSL server certificate generation and renewal processes (Let's Encrypt and ZeroSSL). It also contains fail2ban for intrusion prevention.

This image also has most Nextcloud dependencies installed, removing the need to have 2 containers running Nginx and PHP using precious system resources

[![Docker hub](https://img.shields.io/badge/docker%20hub-link-blue?style=for-the-badge&logo=docker)](https://hub.docker.com/repository/docker/vcxpz/swag) ![Docker Image Size](https://img.shields.io/docker/image-size/vcxpz/swag?style=for-the-badge&logo=docker) [![Autobuild](https://img.shields.io/badge/auto%20build-weekly-blue?style=for-the-badge&logo=docker?color=d1aa67)](https://github.com/hydazz/docker-swag/actions?query=workflow%3A%22Docker+Update+CI%22)

## Version Information

![alpine](https://img.shields.io/badge/alpine-edge-0D597F?style=for-the-badge&logo=alpine-linux) ![s6overlay](https://img.shields.io/badge/s6--overlay-v2.1.0.2-blue?style=for-the-badge) ![nginx](https://img.shields.io/badge/nginx--269539?style=for-the-badge&logo=nginx) ![php](https://img.shields.io/badge/php-8.0.0-777BB4?style=for-the-badge&logo=php)

See [package_versions.txt](https://github.com/hydazz/docker-swag/blob/main/package_versions.txt) for more detail

## Custom Commands

### *swag* Command

This image also features the *swag* command, which is a bash script I made so you don't have to restart the whole container to apply configuration changes or to test the configuration.
*swag* usage example:

| Function | Usage |
| :---: | --- |
| Test Nginx Configuration | swag nginx test |
| Restart Nginx | swag nginx restart |
| Restart PHP-FPM | swag php restart |
| Test php.ini | swag php test |

## Folder Changes

This image has the following new folders:

    config/
    ├─ domains/
    │  ├─ example.com/
    │  │  ├─ logs/ <- example.com logs
    │  │  │  ├─ error.log
    │  │  │  ├─ access.log
    │  │  ├─ public_html/ <- webroot folder
    ├─ logrotate.d/ <- contents are copied to /etc/logrotate.d
Rather than the folder *www* this image uses *domains*, in where you can put your domains, such as example.com. There is also the *logrotate.d* folder, contents of this folder will be copied to */etc/logrotate.d*, this will overwrite any folders in the */etc/logrotate.d* folder if the filename matches.
