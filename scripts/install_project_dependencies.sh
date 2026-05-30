#!/bin/bash

#give permission for everything in the express-app directory
sudo chmod -R 777 /home/ec2-user/express-app

cd /home/ec2-user/express-app

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # loads nvm bash_completion (node is in path now)

npm install pm2 -g

# Force Node 22
nvm use 22

npm install --legacy-peer-deps

# Use AWS Secrets service for setting env variables in prod;
file_location=./.env
cat >$file_location <<EOF
ENDPOINT="shop-db.c32qkoeaiiky.eu-west-1.rds.amazonaws.com"
USER_NAME="postgres"
DB_PORT="5432"
PASSWORD="iihan_postgres"
TABLE_SCHEMA_AUTOUPDATE="false"
DEVELOPMENT="false"
PORT="3000"
DATABASE_NAME="shop"
SSL="true"
EOF

npm run build

npm run run-migration
