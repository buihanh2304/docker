### Laradock mini version by [HanhBT](https://github.com/buihanh2304/docker)

### Which is included?

- PHP-FPM (xDebug), PHP-Worker, MailHog

- Nginx, Apache

- MySQL
    - PHPMyAdmin: http://localhost:8081
    - Host: mysql:3306
    - Users:
        - root / root
        - default / secret

    You can change in `.env` file and `phpmyadmin/config.inc.php`

- Mailhog
    - Web: http://localhost:8025
    - Host: mailhog
    - Post: 1025

- Redis
    - Host: redis:6379

- Elastic Search
    - Host: elasticsearch:9200

- Laravel Echo Server
    - Port: 6001

### How to use?
- Clone this repository to project folder.
- Change `.env` `COMPOSE_PROJECT_NAME` to your project name.
- [Config xDebug](#config-xdebug) (optional)
- Edit `/etc/hosts`, add domain for your project:
```
127.0.0.1 docker.dev
```
- Create `.conf` file in `apache2/sites` or `nginx/sites` folder. Examples in these folder will help you.
- [Config SSL](#config-ssl) (optional)

- **For magento**:
    - edit `./.env` file:
    ```
    WORKSPACE_INSTALL_SOAP=true
    PHP_FPM_INSTALL_SOAP=true
    PHP_WORKER_INSTALL_SOAP=true
    ```
    - edit `./build` and `./start` file, add ` elasticsearch` to each docker-composer command line
- Run bash:
```bash
cd docker
sudo ./build
sudo ./start
```
- Done!

## Common use
```bash
sudo ./build # build images
sudo ./build no-cache # build images without cache

sudo ./start # start docker
sudo ./stop # stop docker

sudo ./bash # exec to workspace bash
# exec to other service bash
sudo ./bash nginx
sudo ./bash php-fpm
sudo ./bash mysql
sudo ./bash phpmyadmin
```

## Config SSL

### Create Self-Signed Cert
```bash
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
```bash
openssl req -new -nodes -newkey rsa:2048 -keyout localhost.key -out localhost.csr -subj "/C=US/ST=YourState/L=YourCity/O=Example-Certificates/CN=localhost"
openssl x509 -req -sha256 -days 1024 -in localhost.csr -CA RootCA.pem -CAkey RootCA.key -CAcreateserial -extfile domains.ext -out localhost.crt
```
Add these line to docker/nginx/sites config
```
listen 443 ssl;
ssl_certificate /etc/nginx/ssl/localhost.crt;
ssl_certificate_key /etc/nginx/ssl/localhost.key;
```
Or Apache in `VirtualHost *:443` tag:
```
SSLEngine on
SSLCertificateFile /etc/apache2/ssl/localhost.crt
SSLCertificateKeyFile /etc/apache2/ssl/localhost.key
```

### Setting browsers to allow created certs
#### Chrome
Goto: `chrome://settings/certificates` > Authorities > Import > Select RootCA.crt in docker/nginx/ssl
#### Firefox
Goto: `about:preferences#privacy` > View Certificates > Authorities > Import > Select RootCA.crt in docker/nginx/ssl

## Config xDebug
- Edit `./.env` file:
```
WORKSPACE_INSTALL_XDEBUG=true
PHP_FPM_INSTALL_XDEBUG=true
```
### VSCode
- Install VSCode extension: `felixfbecker.php-debug`
- Create file `./.vscode/launch.json` with bellow content, replace `/project_path` with your project path.
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9000,
            "pathMappings": {
                "/var/www": "/project_path",
            }
        }
    ]
}
```
