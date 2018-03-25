#!/usr/bin/make -f
NAME=jamesbrink/magento
TEMPLATE=Dockerfile.template
DOCKER_COMPOSE_TEMPLATE=docker-compose.template
SED:=$(shell [[ `command -v gsed` ]] && echo gsed || echo sed)
.PHONY: all clean 2.2 2.2-sass 2.1 2.0
.DEFAULT_GOAL := 2.2

all: 2.2 2.2-sass 2.1 2.0

2.2:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.1 2.2.3 false 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)
	docker tag $(NAME):$(@) latest

2.2-sass:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.1 2.2.3 true 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

2.1:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.0 2.2.3 false 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

2.0:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.0 2.2.3 false 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

clean:
	rm -rf 2.2 2.2-sass 2.1 2.0
