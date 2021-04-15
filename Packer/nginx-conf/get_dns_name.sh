#!/bin/sh
sleep 300
aws s3 cp s3://frankfurt-loadbalancer-dns-names/app-dns-name /tmp/app-dns-name
APP_DNS_NAME=$(cat /tmp/app-dns-name)
sudo sed -i "16s/127.0.0.1/$APP_DNS_NAME/" /etc/nginx/nginx.conf
sudo systemctl reload nginx
