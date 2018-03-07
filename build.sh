#!/usr/bin/env bash

docker build -t revenuewire/docker-php7-alpine:v2 .
docker run -it -p 8090:80 revenuewire/docker-php7-alpine:v2