#!/bin/bash
echo update sources list... 
sudo apt-get update 
echo done!
echo upgrade packages... 
sudo apt-get upgrade - y 
echo done! 

echo install mongodb gpg key
curl -fsSL https://pgp.mongodb.com/server-8.0.asc | \
    sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
    --dearmor
echo done! 

echo update source list...
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.2.list

sudo apt-get update


sudo apt-get install -y \
    mongodb-org=8.2.5 \
    mongodb-org-database=8.2.5 \
    mongodb-org-server=8.2.5 \
    mongodb-mongosh \
    mongodb-org-shell=8.2.5 \
    mongodb-org-mongos=8.2.5 \
    mongodb-org-tools=8.2.5 \
    mongodb-org-database-tools-extra=8.2.5

# configure mongodb bind ip
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

sudo systemctl enable mongod

sudo systemctl start mongod

