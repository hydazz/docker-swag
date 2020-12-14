## Alpine Edge fork of [linuxserver/docker-swag](https://github.com/linuxserver/docker-swag/)

SWAG - Secure Web Application Gateway (formerly known as letsencrypt, no relation to Let's Encrypt™) sets up an Nginx webserver and reverse proxy with php support and a built-in certbot client that automates free SSL server certificate generation and renewal processes. It also contains fail2ban for intrusion prevention.

## Version Information
| Name | Version |
| :---: | --- |
| Alpine | Edge |
| Nginx | 1.18.0 |
| PHP | 7.4* |
| s6-overlay | 2.1.0.2 |

*PHP 8 image is in the works

## Custom Commands
### *swag* Command
This image also features the *swag* command, which is a bash script I made so you don't have to restart the whole container to apply configuration changes or to test the configuration.
*swag* usage example:

|Function|Usage|
|--|--|
|Test Nginx Configuration|swag nginx test|
|Restart Nginx|swag nginx restart|
|Restart PHP-FPM|swag php restart|
|Test php.ini|swag php test|

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
