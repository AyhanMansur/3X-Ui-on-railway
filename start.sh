#!/bin/bash
set -e

echo "Starting X-UI + Nginx with ArvanCloud Real-IP support..."

# پورت ثابت داخلی Nginx برای ارتباط با Railway
export NGINX_PORT=3000

cd /usr/local/x-ui

echo "Applying 3x-ui settings..."
./x-ui setting -port 2053 -webBasePath /managepanel/ || true

echo "Generating nginx.conf from template..."
envsubst '${NGINX_PORT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "Starting 3x-ui..."
./x-ui &

sleep 2

echo "Starting Nginx..."
nginx -t
exec nginx -g "daemon off;"
