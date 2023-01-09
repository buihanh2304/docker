#!/bin/bash

case $1 in
    mysql | nginx | "php-fpm" | phpmyadmin | redis | elasticsearch)
        docker-compose exec "$1" bash
        ;;
    "php-worker")
        docker-compose exec "$1" sh
        ;;
    "-r")
        docker-compose exec workspace bash
        ;;
    "")
        docker-compose exec --user=laradock workspace bash
        ;;
    *)
        echo "Wrong service name"
esac
