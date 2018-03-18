#!/usr/bin/make -f
NAME=jamesbrink/magento
TEMPLATE=Dockerfile.template
SED:=$(shell [[ `command -v gsed` ]] && echo gsed || echo sed)
.PHONY: all 2.2.3 2.2.3-sass 2.1.12 2.0.18
.DEFAULT_GOAL := 2.2.3

all: 2.2.3 2.2.3-sass 2.1.12 2.0.18

2.2.3:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) 7.1 $(@) > $(@)/Dockerfile
	cp -r docker-assets $(@)
	docker build -t $(NAME):$(@) --build-arg magento_version=$(@) $(@)
	docker tag $(NAME):$(@) latest

2.2.3-sass:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) 7.1 $(@) > $(@)/Dockerfile
	cp -r docker-assets $(@)
	docker build -t $(NAME):$(@) --build-arg magento_version=2.2.3 --build-arg sass_enabled=true $(@)

2.1.12:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) 7.0 $(@) > $(@)/Dockerfile
	cp -r docker-assets $(@)
	docker build -t $(NAME):$(@) --build-arg magento_version=$(@) $(@)

2.0.18:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" $(@) 7.0 $(@) > $(@)/Dockerfile
	cp -r docker-assets $(@)
	docker build -t $(NAME):$(@) --build-arg magento_version=$(@) $(@)
