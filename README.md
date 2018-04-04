# Minimal Magento 2 Docker image built on top of Alpine Linux.

[![Build Status](https://travis-ci.org/jamesbrink/docker-magento.svg?branch=master)](https://travis-ci.org/jamesbrink/docker-magento) [![Docker Automated build](https://img.shields.io/docker/automated/jamesbrink/magento.svg)](https://hub.docker.com/r/jamesbrink/magento/) [![Docker Pulls](https://img.shields.io/docker/pulls/jamesbrink/magento.svg)](https://hub.docker.com/r/jamesbrink/magento/) [![Docker Stars](https://img.shields.io/docker/stars/jamesbrink/magento.svg)](https://hub.docker.com/r/jamesbrink/magento/) [![](https://images.microbadger.com/badges/image/jamesbrink/magento.svg)](https://microbadger.com/images/jamesbrink/magento "Get your own image badge on microbadger.com") [![](https://images.microbadger.com/badges/version/jamesbrink/magento.svg)](https://microbadger.com/images/jamesbrink/magento "Get your own version badge on microbadger.com")

## About

This is a minimal working [Magento 2][magento 2] Docker image built to be slim and easy to use.  
Checkout the `[docker-compose.yml]`[example-compose] .

Pull requests or suggestions are always welcome.


## Available versions

| Docker Image                 | Size (Uncompressed)            | Version            | Dockerfile                        |
| ---------------------------- | ------------------------------ | ------------------ | --------------------------------- |
| `jamesbrink/mageto:latest`   | 346 MB                         | **Magento 2.2.3**  | [Dockerfile][2.2/dockerfile]      |
| `jamesbrink/mageto:2.2-sass` | **Magento 2.2.3** SASS Enabled | 636 MB             | [Dockerfile][2.2-sass/dockerfile] |
| `jamesbrink/magento:2.1`     | 344 MB                         | **Magento 2.1.12** | [Dockerfile][2.1/dockerfile]      |
| `jamesbrink/magento:2.0`     | 3444 MB                        | **Magento 2.0.18** | [Dockerfile][2.0/dockerfile]      |

All images are built on top of the official [Alpine Linux 3.7][alpine linux image] image, using a base image of [`jamesbrink/php`][jamesbrink/php].  

There is a SASS enabled version of this package which is packaged with NodeJS as well as [magento2-theme-blank-sass][snowdog-theme], and [magento2-frontools][snowdog-frontools]. The SASS image is fairly large, but useful for development purposes.


## Usage Examples

Run docker-compose example.  
This will serve up the latest container and download sample data. Please not it will take a moment  
to download the sample data once the container has booted.  

Access the site at <http://localhost/> and the admin section at <http://localhost/admin/> login: _admin/password1_   

```shell
git clone https://github.com/jamesbrink/docker-magento.git
cd docker-magento/2.2
docker-compose up
```

## Environment Variables


| Variable             | Default Value | Description                                                                                                                                               |
| -------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `APACHE_LOG_LEVEL`   | warn          | adjusts the verbosity of the apache server which by default prints to STDOUT. Refer to the [apache2 manual][apache2 manaual] for all available LogLevels. |
| `ENABLE_SAMPLE_DATA` | false         | If set to "true" the container will download and install the Magento 2 sample data on startup.                                                            |

[alpine linux image]: https://github.com/gliderlabs/docker-alpine

[2.2/dockerfile]: https://github.com/jamesbrink/docker-magento/blob/master/2.2/Dockerfile

[2.2-sass/dockerfile]: https://github.com/jamesbrink/docker-magento/blob/master/2.2-sass/Dockerfile

[2.1/dockerfile]: https://github.com/jamesbrink/docker-magento/blob/master/2.1/Dockerfile

[2.0/dockerfile]: https://github.com/jamesbrink/docker-magento/blob/master/2.0/Dockerfile

[jamesbrink/php]: https://github.com/jamesbrink/docker-php

[example-compose]: https://github.com/jamesbrink/docker-magento/blob/master/2.2/docker-compose.yml

[snowdog-theme]: https://github.com/SnowdogApps/magento2-theme-blank-sass

[snowdog-frontools]: https://github.com/SnowdogApps/magento2-frontools

[magento 2]: https://github.com/magento/magento2

[jamesbrink/php]: https://github.com/jamesbrink/docker-magento

[apache2 manaual]: https://httpd.apache.org/docs/2.4/mod/core.html#loglevel
