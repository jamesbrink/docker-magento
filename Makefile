#!/usr/bin/make -f
NAME=jamesbrink/magento
TEMPLATE=Dockerfile.template
DOCKER_COMPOSE_TEMPLATE=docker-compose.template

.PHONY: all clean latest 2.2 2.2-sample-data 2.2-sass 2.2-sass-sample-data 2.1 2.1-sample-data 2.0 2.0-sample-data
.DEFAULT_GOAL := latest

all: latest 2.2 2.2-sample-data 2.2-sass 2.2-sass-sample-data 2.1 2.1-sample-data 2.0 2.0-sample-data


latest:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.1 2.2.3 false 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)
	docker tag $(NAME):$(@) latest

2.2:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.2 7.1 2.2.3 false 2.2.3 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

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
	printf "`cat $(TEMPLATE)`" 2.1 7.0 2.1.12 false 2.1.12 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

2.1-sample-data:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.1 7.0 2.1.12 false 2.1.12 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build --build-arg ENABLE_SAMPLE_DATA="true" -t $(NAME):$(@) $(@)

2.0:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.0 7.0 2.0.18 false 2.0.18 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build -t $(NAME):$(@) $(@)

2.0-sample-data:
	mkdir -p $(@)
	printf "`cat $(TEMPLATE)`" 2.0 7.0 2.0.18 false 2.0.18 > $(@)/Dockerfile
	printf "`cat $(DOCKER_COMPOSE_TEMPLATE)`" $(@) > $(@)/docker-compose.yml
	cp .dockerignore $(@)/.dockerignore
	cp -rp docker-assets $(@)
	cp -rp hooks $(@)
	docker build --build-arg ENABLE_SAMPLE_DATA="true" -t $(NAME):$(@) $(@)


test: test-2.0 test-2.0-sample-data test-2.1 test-2.1-sample-data test-2.2 test-2.2-sample-data test-2.2-sass test-2.2-sass-sample-data

test-2.0:
	docker run -it --rm jamesbrink/magento:2.0 magento --version|grep --quiet "2.0.18"; if [ $$? -ne 0 ]; then exit 1;fi
test-2.0-sample-data:
	docker run -it --rm jamesbrink/magento:2.0-sample-data magento --version|grep --quiet "2.0.18"; if [ $$? -ne 0 ]; then exit 1;fi
test-2.1:
	docker run -it --rm jamesbrink/magento:2.1 magento --version|grep --quiet "2.1.12"; if [ $$? -ne 0 ]; then exit 1;fi
test-2.1-sample-data:
	docker run -it --rm jamesbrink/magento:2.1-sample-data magento --version|grep --quiet "2.1.12"; if [ $$? -ne 0 ]; then exit 1;fi
test-2.2:
	docker run -it --rm jamesbrink/magento:2.2 magento --version|grep --quiet "2.2.3"; if [ $$? -ne 0 ]; then exit 1;fi
test-2.2-sample-data:
	docker run -it --rm jamesbrink/magento:2.2-sample-data magento --version|grep --quiet "2.2.3"; if [ $$? -ne 0 ]; then exit 1;fi
test-2.2-sass:
	docker run -it --rm jamesbrink/magento:2.2-sass magento --version|grep --quiet "2.2.3"; if [ $$? -ne 0 ]; then exit 1;fi
test-2.2-sass-sample-data:
	docker run -it --rm jamesbrink/magento:2.2-sass-sample-data magento --version|grep --quiet "2.2.3"; if [ $$? -ne 0 ]; then exit 1;fi

clean:
	rm -rf latest 2.2 2.2-sample-data 2.2-sass 2.2-sass-sample-data 2.1 2.1-sample-data 2.0 2.0-sample-data
