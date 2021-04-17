#!/usr/bin/env bash

server_ip=$1
scp -i "../ec2.key" ubuntu@${server_ip}:~/.pm2/logs/mlem-mlem-backend-* ./logs