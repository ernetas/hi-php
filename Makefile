NAME = registry.mendo.lv/servers/php56-op

.PHONY: all build push
all: build push

build:
	docker build --pull -t $(NAME):$(shell git rev-parse --short HEAD) .

push:
	docker push $(NAME):$(shell git rev-parse --short HEAD)
