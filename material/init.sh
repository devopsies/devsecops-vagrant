#!/bin/bash

apt update
apt install -y nginx

cp /vagrant/index.html /usr/share/nginx/html/index.html
