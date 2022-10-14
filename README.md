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
    - SMTP: mailhog:1025

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

- **Addition config for magento**:
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
sudo ./build --nc # build images without cache

sudo ./start # start docker
sudo ./stop # stop docker
sudo ./restart # stop and start docker
sudo ./restart -q # restart docker

sudo ./bash # exec to workspace bash
sudo ./bash -r # exec to workspace bash as root user
# exec to other service bash
sudo ./bash nginx
sudo ./bash php-fpm
sudo ./bash mysql
sudo ./bash phpmyadmin
```

- [Run without sudo](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user)
```bash
sudo ./run_without_sudo.sh
```

## Config SSL

### Enable SSL for domains
```bash
cd ./ssl

cp domains.ext.example domains.ext
```
- Open `domains.ext`, change `docker.dev` to your domain, or add domain with format
```
DNS.2 = domain.com
DNS.3 = other-domain.com
```

- Add these line to docker/nginx/sites config
```
listen 443 ssl;
ssl_certificate /etc/nginx/ssl/default.crt;
ssl_certificate_key /etc/nginx/ssl/default.key;
```
Or Apache in `VirtualHost *:443` tag:
```
SSLEngine on
SSLCertificateFile /etc/apache2/ssl/default.crt
SSLCertificateKeyFile /etc/apache2/ssl/default.key
```
- `./restart` (if needed)

### Setting browsers to allow created certs
#### Chrome
Goto: `chrome://settings/certificates` > Authorities > Import > Select RootCA.crt in ./ssl
#### Firefox
Goto: `about:preferences#privacy` > View Certificates > Authorities > Import > Select RootCA.crt in ./ssl

## Config xDebug
- Edit `./.env` file:
```
# for php-fpm debug (required)
PHP_FPM_INSTALL_XDEBUG=true

# for php-cli debug (optional)
WORKSPACE_INSTALL_XDEBUG=true
```
### VSCode
- Install VSCode extension: [felixfbecker.php-debug](https://marketplace.visualstudio.com/items?itemName=xdebug.php-debug)
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
# Start php-fpm debug
- Click `Listen for xDebug` in Editor/IDE toolbar.
- PHP 8 or newer use xDebug 3 with [some changes](https://xdebug.org/docs/step_debug#activate_debugger), you must install a Browser extension for enable debug mode.
    - [Xdebug Helper for Chrome](https://chrome.google.com/extensions/detail/eadndfjplgieldjbigjakmdgkmoaaaoc) ([source](https://github.com/mac-cain13/xdebug-helper-for-chrome)).
    - [Xdebug Helper for Firefox](https://addons.mozilla.org/en-GB/firefox/addon/xdebug-helper-for-firefox/) ([source](https://github.com/BrianGilbert/xdebug-helper-for-firefox)).
