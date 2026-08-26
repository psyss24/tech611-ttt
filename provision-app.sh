#!/bin/bash

# ssh -i "~/.ssh/tech611-saad-aws.pem" ubuntu@ec2-3-253-69-233.eu-west-1.compute.amazonaws.com 

# scp -i "~/.ssh/tech611-saad-aws.pem" desktop/nodejs20-sparta-tictactoe-v1-2.zip ubuntu@ec2-3-253-69-233.eu-west-1.compute.amazonaws.com:

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

unzip app.zip
cd app


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


# Develop your prov-app.sh script to:
# update & upgrade
# install nginx
# install nodejs v20
# cd into the app folder
# install & run the app in the background:
# Next steps:
# Test your script to make sure it works in your current VM, then on a fresh VM
# Document, include...
# Why we need to run the app in the background