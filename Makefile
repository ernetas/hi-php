NAME = hilv/php

.PHONY: all

all: build

build:
	docker build --pull -t $(NAME):hi-phalcon-$(shell git show-ref HEAD -s) --rm .
	docker push $(NAME):hi-phalcon-$(shell git show-ref HEAD -s)

