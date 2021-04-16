#!/usr/bin/env bash

# Install node
curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

# Install pm2
yarn add -g pm2

# Install codedeploy agent
curl -O https://aws-codedeploy-eu-west-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto > /tmp/logfile

# Install certbot
sudo snap install core; sudo snap refresh core
sudo apt-get remove certbot
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly \
  --dns-route53 \
  -d dev.mlem-mlem.net

echo "00 3 * * 1 /usr/bin/certbot renew --dns-route53 --dns-route53-propagation-seconds 30") | crontab

# Install and Configure nginx
sudo apt update
sudo apt install nginx
sudo rm /etc/nginx/nginx.conf

[[ ! -d $HOME/app ]] && mkdir $HOME/app
[[ -f /tmp/.env ]] && mv /tmp/.env $HOME/app

[[ -f /tmp/nginx.conf ]] && sudo mv /tmp/nginx.conf /etc/nginx
# [[ -f /etc/nginx/sites-enabled/default ]] && sudo rm /etc/nginx/sites-enabled/default
# [[ -f /etc/nginx/sites-enabled/server ]] && sudo rm /etc/nginx/sites-enabled/server

# sudo ln -f /etc/nginx/sites-available/server /etc/nginx/sites-enabled
sudo nginx -s reload