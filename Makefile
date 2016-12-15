NAME = hilv/php
VERSION = debug

.PHONY: all

all: build

build:
	docker pull php:5.6-fpm
	docker build -t $(NAME):$(VERSION) --rm .

