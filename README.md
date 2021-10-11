### Laradock mini version by [HanhBT](https://github.com/buihanh2304/docker)

## How to use?
- Just clone this repository to project folder.

## Create site
- Create `.conf` file in `apache2/sites` or `nginx/sites` folder. Examples in these folder will help you.

## Environment
### MySQL
Host: http://localhost:8081
- root / root
- default / secret

You can change in `.env` file and `phpmyadmin/config.inc.php`
### Mailhog
Host: http://localhost:8025
## Common use
```
cd docker
sudo ./build # build images
sudo ./build no-cache # build images without cache

sudo ./start # start docker
sudo ./stop # stop docker

sudo ./bash # exec to workspace bash
sudo ./bash nginx # exec to service bash
sudo ./bash php-fpm
sudo ./bash mysql
sudo ./bash phpmyadmin
```

## Config SSL

### Create Self-Signed Cert
```
cd docker/nginx/ssl # for nginx
cd docker/apache2/ssl # for apache

openssl req -x509 -nodes -new -sha256 -days 1024 -newkey rsa:2048 -keyout RootCA.key -out RootCA.pem -subj "/C=US/CN=Local-Root-CA"
openssl x509 -outform pem -in RootCA.pem -out RootCA.crt
touch domains.ext
```
Paste code bellow to domains.ext
```
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = docker.dev
```
change `docker.dev` to your domain, or add domain with format
```
DNS.2 = domain.com
DNS.3 = other-domain.com
```
```
openssl req -new -nodes -newkey rsa:2048 -keyout localhost.key -out localhost.csr -subj "/C=US/ST=YourState/L=YourCity/O=Example-Certificates/CN=localhost"
openssl x509 -req -sha256 -days 1024 -in localhost.csr -CA RootCA.pem -CAkey RootCA.key -CAcreateserial -extfile domains.ext -out localhost.crt
```
Add these line to docker/nginx/sites config
```
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/localhost.crt;
    ssl_certificate_key /etc/nginx/ssl/localhost.key;
```

### Setting browsers to allow created certs
#### Chrome
Goto: `chrome://settings/certificates` > Authorities > Import > Select RootCA.crt in docker/nginx/ssl
#### Firefox
Goto: `about:preferences#privacy` > View Certificates > Authorities > Import > Select RootCA.crt in docker/nginx/ssl
