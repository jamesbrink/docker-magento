#!/usr/bin/make -f
NAME=jamesbrink/magento
TEMPLATE=Dockerfile.template
ALPINE_TEMPLATE=Dockerfile.alpine.template
DOCKER_COMPOSE_TEMPLATE=docker-compose.template
SED:=$(shell [[ `command -v gsed` ]] && echo gsed || echo sed)
.PHONY: all clean alpine debian 2.2.3-alpine 2.2.3-alpine-sass 2.1.12-alpine 2.0.18-alpine 2.2.3 2.2.3-sass 2.1.12 2.0.18
.DEFAULT_GOAL := 2.2.3

all: alpine debian
alpine: 2.2.3-alpine 2.2.3-alpine-sass 2.1.12-alpine 2.0.18-alpine
debian: 2.2.3 2.2.3-sass 2.1.12 2.0.18

2.2.3:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) 7.1 $(@) $(@) false > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp -r docker-assets $(@)
	docker build -t $(NAME):$(@) --build-arg magento_version=$(@) $(@)
	docker tag $(NAME):$(@) latest

2.2.3-alpine:
	mkdir -p $(@)
	printf "`cat $(ALPINE_TEMPLATE)`" $(@) 7.1 $(@) 2.2.3 false > $(@)/Dockerfile
	cp -r alpine-docker-assets $(@)/docker-assets
	docker build -t $(NAME):$(@) --build-arg magento_version=2.2.3 $(@)

2.2.3-sass:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) 7.1 $(@) 2.2.3 true > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp -r docker-assets $(@)
	docker build -t $(NAME):$(@) --build-arg magento_version=2.2.3 --build-arg sass_enabled=true $(@)

2.2.3-alpine-sass:
	mkdir -p $(@)
	printf "`cat $(ALPINE_TEMPLATE)`" $(@) 7.0 $(@) 2.2.3 false > $(@)/Dockerfile
	cp -r alpine-docker-assets $(@)/docker-assets
	docker build -t $(NAME):$(@) --build-arg magento_version=2.2.3 $(@)

2.1.12:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) 7.0 $(@) $(@) false > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp -r docker-assets $(@)
	docker build -t $(NAME):$(@) --build-arg magento_version=$(@) $(@)

2.1.12-alpine:
	mkdir -p $(@)
	printf "`cat $(ALPINE_TEMPLATE)`" $(@) 7.0 $(@) 2.1.12 false > $(@)/Dockerfile
	cp -r alpine-docker-assets $(@)/docker-assets
	docker build -t $(NAME):$(@) --build-arg magento_version=2.1.12 $(@)

2.0.18:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) 7.0 $(@) $(@) false > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp -r docker-assets $(@)
	docker build -t $(NAME):$(@) --build-arg magento_version=$(@) $(@)

2.0.18-alpine:
	mkdir -p $(@)
	printf "`cat $(ALPINE_TEMPLATE)`" $(@) 7.0 $(@) 2.0.18 false > $(@)/Dockerfile
	cp -r alpine-docker-assets $(@)/docker-assets
	docker build -t $(NAME):$(@) --build-arg magento_version=2.0.18 $(@)

clean:
	rm -rf 2.2.3-alpine 2.2.3-alpine-sass 2.1.12-alpine 2.0.18-alpine 2.2.3 2.2.3-sass 2.1.12 2.0.18
