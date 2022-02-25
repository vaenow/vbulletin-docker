# vbulletin-docker
vbulletin docker


## build docker
```bash
docker build -f Dockerfile  -t vbulletin-php:v5.6.601 .
```

## run
```bash
docker run  --name vbulletin-php \
  --privileged  \
  --link mysql-php \
  -e PMA_HOST="mysql-php-pwd" \
  -e ServerName="host.com"  \
  -d -p 80:80 vbulletin-php:v5.6.601
```
