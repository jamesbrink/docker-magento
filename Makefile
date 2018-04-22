#!/usr/bin/make -f
NAME=jamesbrink/magento
TEMPLATE=Dockerfile.template
DOCKER_COMPOSE_TEMPLATE=docker-compose.template

.PHONY: all clean 2.2 2.2-sample-data 2.2-sass 2.2-sass-sample-data 2.1 2.0
.DEFAULT_GOAL := 2.2

all: 2.2 2.2-sample-data 2.2-sass 2.2-sass-sample-data 2.1 2.0

2.2:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.1 2.2.3 false 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)
	docker tag $(NAME):$(@) latest

2.2-sample-data:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.1 2.2.3 false 2.2.3 > $(@)/Dockerfile
	sed -i -r 's/ARG ENABLE_SAMPLE_DATA.*/ARG ENABLE_SAMPLE_DATA="true"/g' $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build --build-arg ENABLE_SAMPLE_DATA="true" -t $(NAME):$(@) $(@)

2.2-sass:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.1 2.2.3 true 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

2.2-sass-sample-data:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.1 2.2.3 true 2.2.3 > $(@)/Dockerfile
	sed -i -r 's/ARG ENABLE_SAMPLE_DATA.*/ARG ENABLE_SAMPLE_DATA="true"/g' $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

2.1:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.0 2.2.3 false 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

2.0:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.0 2.2.3 false 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

clean:
	rm -rf 2.2 2.2-sample-data 2.2-sass 2.2-sass-sample-data 2.1 2.0
