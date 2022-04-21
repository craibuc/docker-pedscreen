# variables
APP_NAME=pedscreen

build:
	docker build \
	--build-arg ACCOUNT=$(ACCOUNT) \
	--build-arg TOKEN=$(TOKEN) \
	--build-arg BRANCH=$(BRANCH) \
	--tag $(APP_NAME):latest \
	.

tty:
	docker run -it --rm --env-file=.env $(APP_NAME):latest /bin/bash

run:
	docker run --rm --env-file=.env $(APP_NAME):latest
