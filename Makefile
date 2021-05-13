# Extremely simple HTTP server that responds on port 8000 with a hello message.

# maybe change this to lazy sets, so it works more out of the box
DOCKER_HUB_ID:=clementkng
NAME:="web-hello-ruby"
VERSION:="1.0.0"

default: build run

build:
	docker build -t $(DOCKER_HUB_ID)/$(NAME):$(VERSION) .

dev: stop build
	docker run -it -v `pwd`:/outside \
          --name ${NAME} \
          -p 8000:8000 \
          $(DOCKER_HUB_ID)/$(NAME):$(VERSION) /bin/bash

run: stop
	docker run -d \
          --name ${NAME} \
          --restart unless-stopped \
          -p 8000:8000 \
          $(DOCKER_HUB_ID)/$(NAME):$(VERSION)

test:
	@curl -sS http://127.0.0.1:8000

push:
	docker push $(DOCKER_HUB_ID)/$(NAME):$(VERSION) 

stop:
	@docker rm -f ${NAME} >/dev/null 2>&1 || :

clean:
	@docker rmi -f $(DOCKER_HUB_ID)/$(NAME):$(VERSION) >/dev/null 2>&1 || :

.PHONY: build dev run push test stop clean