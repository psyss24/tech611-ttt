#!/bin/bash
# update package lists
sudo apt-get update

# -y -> answer yes to prompts we get -> can't get user input in scripts!
# actually updates packages can break things!
sudo apt-get upgrade -y

# install nginx web server
sudo apt-get install nginx -y

# copy your github repo with the app folder
git clone https://github.com/psyss24/tech611-ttt
cd tech611-ttt

# download script to prepare to install node js 
curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh

# run script
sudo bash nodesource_setup.sh

# install nodejs
sudo apt install nodejs

# make sure we installed correct verion
node -v

# install node modules for the app
npm install

# run app
npm start &
