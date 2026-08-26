#!/bin/bash
echo update package lists...
sudo apt-get update

# -y -> answer yes to prompts we get -> can't get user inp>
# actually updates packages can break things!
echo installing updates...
sudo apt-get upgrade -y


echo installing nginx web server...
sudo apt-get install nginx -y


echo git cloning...
git clone https://github.com/psyss24/tech611-ttt

cd tech611-ttt
echo getting latest app changes...
git pull
echo getting into the app directory...
cd app


echo downloading script to install node js...
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh

echo running nodejs script...
sudo bash nodesource_setup.sh

echo install nodejs
sudo apt install nodejs

node -v

echo install node modules for the app...
npm install
sudo npm install -g pm2

echo configuring proxy...
sudo sed -i 's|try_files $uri $uri/ =404;|proxy_pass http://127.0.0.1:3000;|' /etc/nginx/sites-available/default
sudo systemctl reload nginx

echo stopping app...
pm2 stop app
echo starting app...
pm2 start npm --name "app" -- start
