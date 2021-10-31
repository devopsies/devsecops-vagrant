#!/bin/bash

apt-get update
apt-get install -y nginx

cp /vagrant/index.html /usr/share/nginx/html/index.html
