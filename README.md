# Minimal Magento 2 Docker image built on top of Alpine Linux.

[![Build Status](https://travis-ci.org/jamesbrink/docker-magento.svg?branch=master)](https://travis-ci.org/jamesbrink/docker-magento) [![Docker Automated build](https://img.shields.io/docker/automated/jamesbrink/magento.svg)](https://hub.docker.com/r/jamesbrink/magento/) [![Docker Pulls](https://img.shields.io/docker/pulls/jamesbrink/magento.svg)](https://hub.docker.com/r/jamesbrink/magento/) [![Docker Stars](https://img.shields.io/docker/stars/jamesbrink/magento.svg)](https://hub.docker.com/r/jamesbrink/magento/) [![](https://images.microbadger.com/badges/image/jamesbrink/magento.svg)](https://microbadger.com/images/jamesbrink/magento "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jamesbrink/magento.svg)](https://microbadger.com/images/jamesbrink/magento "Get your own version badge on microbadger.com")


Available versions:
  * `jamesbrink/mageto:latest` (346MB) - Magento 2.2.3 [Dockerfile][2.2/Dockerfile]
  * `jamesbrink/mageto:2.2-sass` (346MB) - Magento 2.2.3 (SASS Enabled) [Dockerfile][2.2-sass/Dockerfile]
  * `jamesbrink/magento:2.1`(344MB) - Magento 2.1.12 [Dockerfile][2.1/Dockerfile]
  * `jamesbrink/magento:2.0` (344MB) - Magento 2.0.18 [Dockerfile][2.0/Dockerfile]  


All images are built on top of the official [Alpine Linux 3.7][Alpine Linux Image] image, using a base image of [`jamesbrink/php`][jamesbrink/php].  


## About

This is a minimal working [Magento 2][Magento 2] Docker image built to be slim and easy to use.  
Checkout the `[docker-compose.yml]`[example-compose] .

Pull requests or suggestions are always welcome.


## Usage Examples

Run docker-compose example.  
This will serve up the latest container and download sample data. Please not it will take a moment  
to download the sample data once the container has booted.  

Access the site at http://localhost/ and the admin section at http://localhost/admin/ login: *admin/password1*   
```shell
git clone https://github.com/jamesbrink/docker-magento.git
cd docker-magento/2.2
docker-compose up
```  


## Environment Variables

Environment Variables:
- **APACHE_LOG_LEVEL** - Default: "warn"  
    - adjusts the verbosity of the apache server which by default prints to STDOUT.  
    Refer to the [apache2 manual][apache2 manaual] for all available LogLevels.
- **ENABLE_SAMPLE_DATA** - Default: "false"  
  - if set to "true" the container will download and install the Magento 2 sample data on startup.


[Alpine Linux Image]: https://github.com/gliderlabs/docker-alpine
[2.2/Dockerfile]: https://github.com/jamesbrink/docker-magento/blob/master/2.2/Dockerfile
[2.2-sass/Dockerfile]: https://github.com/jamesbrink/docker-magento/blob/master/2.2-sass/Dockerfile
[2.1/Dockerfile]: https://github.com/jamesbrink/docker-magento/blob/master/2.1/Dockerfile
[2.0/Dockerfile]: https://github.com/jamesbrink/docker-magento/blob/master/2.0/Dockerfile
[jamesbrink/php]: https://github.com/jamesbrink/docker-php
[example-compose]: https://github.com/jamesbrink/docker-magento/blob/master/2.2/docker-compose.yml
[Magento 2]: https://github.com/magento/magento2
[jamesbrink/php]: https://github.com/jamesbrink/docker-magento
[apache2 manaual]: https://httpd.apache.org/docs/2.4/mod/core.html#loglevel
