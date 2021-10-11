#!/bin/bash

case $1 in
    workspace | mysql | nginx | "php-fpm" | phpmyadmin)
        docker-compose exec "$1" bash
        ;;
    *)
        docker-compose exec workspace bash
        ;;
esac
