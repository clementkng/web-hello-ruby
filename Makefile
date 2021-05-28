# Extremely simple HTTP server that responds on port 8000 with a hello message.

# maybe change this to lazy sets, so it works more out of the box
DOCKER_HUB_ID:=clementkng
SERVICE_NAME:="web-hello-ruby"
VERSION:="1.0.0"
PATTERN_NAME:="pattern-web-hello-ruby"

# These statements automatically configure some environment variables
ARCH:=$(shell ../../helper -a)

# Leave blank for open DockerHub containers
# CONTAINER_CREDS:=-r "registry.wherever.com:myid:mypw"
CONTAINER_CREDS:=

default: build run

build:
	docker build -t $(DOCKER_HUB_ID)/$(SERVICE_NAME):$(VERSION) .

dev: stop build
	docker run -it -v `pwd`:/outside \
          --name ${SERVICE_NAME} \
          -p 8000:8000 \
          $(DOCKER_HUB_ID)/$(SERVICE_NAME):$(VERSION) /bin/bash

run: stop
	docker run -d \
          --name ${SERVICE_NAME} \
          --restart unless-stopped \
          -p 8000:8000 \
          $(DOCKER_HUB_ID)/$(SERVICE_NAME):$(VERSION)

test:
	@curl -sS http://127.0.0.1:8000

push:
	docker push $(DOCKER_HUB_ID)/$(SERVICE_NAME):$(VERSION)

stop:
	@docker rm -f ${SERVICE_NAME} >/dev/null 2>&1 || :

clean:
	@docker rmi -f $(DOCKER_HUB_ID)/$(SERVICE_NAME):$(VERSION) >/dev/null 2>&1 || :

publish-service:
	@ARCH=$(ARCH) \
	    SERVICE_NAME="$(SERVICE_NAME)" \
	    VERSION="$(VERSION)"\
	    SERVICE_CONTAINER="$(DOCKERHUB_ID)/$(SERVICE_NAME):$(VERSION)" \
	    hzn exchange service publish -O $(CONTAINER_CREDS) -P -f horizon/service.definition.json

publish-pattern:
	@ARCH=$(ARCH) \
	    SERVICE_NAME="$(SERVICE_NAME)" \
	    VERSION="$(VERSION)"\
	    PATTERN_NAME="$(PATTERN_NAME)" \
	    hzn exchange pattern publish -f horizon/pattern.json

agent-run:
	hzn register --pattern "${HZN_ORG_ID}/$(PATTERN_NAME)"

agent-stop:
	hzn unregister -f

.PHONY: build dev run push test stop clean publish-service publish-pattern agent-run agent-stop
