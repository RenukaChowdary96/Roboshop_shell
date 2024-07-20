source common.sh
component=catalogue

NODEJS


dnf install mongodb-mongosh -y
mongosh --host mongo.dev.renuka.online </app/db/master-data.js

