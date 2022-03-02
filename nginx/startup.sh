#!/bin/bash

if [[ ! -f /etc/nginx/ssl/default.crt && -f /etc/nginx/ssl/domains.ext ]]; then
    openssl req -new -nodes -newkey rsa:2048 -keyout "/etc/nginx/ssl/default.key" -out "/etc/nginx/ssl/default.csr" -subj "/CN=default/O=default/C=UK"
    openssl x509 -req -sha256 -days 1024 -in "/etc/nginx/ssl/default.csr" -CA "/etc/nginx/ssl/RootCA.pem" -CAkey "/etc/nginx/ssl/RootCA.key" -CAcreateserial -extfile "/etc/nginx/ssl/domains.ext" -out "/etc/nginx/ssl/default.crt"
    chmod 644 /etc/nginx/ssl/default.key
fi

# Start crond in background
crond -l 2 -b

# Start nginx in foreground
nginx
