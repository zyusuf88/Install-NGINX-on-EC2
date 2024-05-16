
Part 2 - Configuring the database deploying nginx on an EC2 instance  <br>

After deploying the EC2 instance [here](https://github.com/zyusuf88/EC2-nginx-deployment)     (part1) follow the steps below to complete the 2-tier app deployment using nginx and mongoDB

# configure the database 
```bash 
#!/bin/bash

# Update
echo update
sudo DEBIAN_FRONTEND=noninteractive apt update -y
echo done!

# Upgrade
echo upgrade
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo finished upgrading

# install mongo db 7.0.6 version

sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
--dearmor

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

sudo apt-get update

sudo apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh=2.2.4 mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6



# Replace the bindIp setting with 0.0.0.0
sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' /etc/mongod.conf

# restart mongo db 
sudo systemctl restart mongod

# enable mongo db
sudo systemctl enable mongod

```
### This script automates the setup and configuration of a MongoDB server, ensuring that the database service is installed, configured to accept external connections, and set to start automatically on system boot.

--------------------------
# Configure the app 

```bash 
#!/bin/bash

echo updating
sudo DEBIAN_FRONTEND=noninteractive apt apt update -y
echo finished updating

echo upgrading
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo finished upgrading

echo installing nginx
sudo DEBIAN_FRONTEND=noninteractive apt install nginx -y
echo finished installing nginx

echo restarting nginx
sudo systemctl restart nginx
echo finished restarting nginx

echo enabling nginx
sudo systemctl enable nginx
echo finished enabling nginx

echo installing nodejs v20
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo DEBIAN_FRONTEND=noninteractive -E bash - &&\
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
echo finished installing nodejs v20

echo checking node version
node -v
echo finished checking node version

echo creating an app folder 
mkdir apps
cd apps

echo clone the app folder
sudo git clone https://github.com/zyusuf88/test-app.git
echo got app folder


echo going to app folder
cd ~/apps/test-app/app
echo in app folder

echo set db_host env var
#put your private ip address of your databse instance here: 
export DB_HOST=mongodb://<privateIpaddress>/posts 
echo  db_host env var done.

echo installing npm
sudo -E npm install
echo finished installing app

echo installing pm2
sudo npm install -g pm2
echo pm2 installed

echo start the app
npm start 
echo app started

#Configure the reverse Proxy to ensure the smooth flow of network traffic between clients and applications

sudo sed -i '51s/.*/\t        proxy_pass http:\/\/localhost:3000;/' /etc/nginx/sites-available/default

``` 
### This script automates the setup of a server environment, installs necessary software, and configures both the application and web server to run a Node.js application efficiently.

### Best practice
- Create a backup of the existing nginx configuration file to ensure that you can revert to the original configuration if needed.
- Run this prior to setting the reverse proxy as local host `sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.bk`