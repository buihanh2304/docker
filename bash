#!/bin/bash

case $1 in
    mysql | nginx | "php-fpm" | phpmyadmin | redis | elasticsearch)
        docker-compose exec "$1" bash
        ;;
    "-r")
        docker-compose exec workspace bash
        ;;
    *)
        docker-compose exec --user=laradock workspace bash
        ;;
esac
