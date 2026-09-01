#!/bin/bash
cd /tech611-ttt/app
export MONGODB_URI=mongodb://172.31.63.53:27017/tictactoe
sudo -E npm install
npm start
# pm2 start npm --name "app" -- start