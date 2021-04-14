#!/bin/sh
aws s3 cp s3://frankfurt-loadbalancer-dns-names/nginx-dns-name /tmp/nginx-dns-name
NGINX_DNS_NAME=$(cat /tmp/nginx-dns-name)
sed -i "52s/127.0.0.1:80/$NGINX_DNS_NAME/" /etc/nginx/nginx.conf