# variables
APP_NAME=pedscreen
APP_VERSION=1.2
OPENJDK_TAG=11
SBT_VERSION=1.5.7

build:
	docker build \
	--build-arg OPENJDK_TAG=$(OPENJDK_TAG) \
	--build-arg SBT_TAG=${OPENJDK_TAG}_${SBT_VERSION} \
	--build-arg ACCOUNT=$(ACCOUNT) \
	--build-arg TOKEN=$(TOKEN) \
	--build-arg BRANCH=$(BRANCH) \
	--tag $(APP_NAME):${OPENJDK_TAG}_${SBT_VERSION} \
	--tag $(APP_NAME):latest \
	.

tty:
	docker run -it --rm --env-file=.env $(APP_NAME):latest /bin/bash

run:
	docker run --rm --env-file=.env $(APP_NAME):latest
