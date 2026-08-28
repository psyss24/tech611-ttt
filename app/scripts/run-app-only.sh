#!/bin/bash
cd /tech611-ttt/app
pm2 start npm --name "app" -- start
