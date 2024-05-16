
#!/bin/bash

echo updating
sudo DEBIAN_FRONTEND=noninteractive apt update -y
echo done!

echo upgrading packages
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
echo done!

echo installing nginx
sudo DEBIAN_FRONTEND=noninteractive apt install nginx -y
echo done!

echo restarting nginx
sudo systemctl restart nginx
echo done!

echo enabling nginx
sudo DEBIAN_FRONTEND=noninteractive systemctl enable nginx
echo done!

echo install node js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
echo done!

echo check js version
node -v
echo done!

echo create apps folder
mkdir apps
cd apps
echo created apps folder

echo clone the app folder
git clone https://github.com/zyusuf88/tech258-sparta-test-app.git
echo cloning done 

echo cd into app folder
cd ~/tech258-sparta-test-app/app
echo done!

echo install npm
sudo npm install
echo done!

echo installing pm2
sudo npm install -g pm2
echo finished

echo  all processes that pm2 is managing
sudo pm2 stop all
echo stopped

echo start app.js using pm2
sudo pm2 start node app.js
echo app started


