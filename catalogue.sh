source common.sh
component=catalogue

NODEJS

echo install mongodb cilent
dnf install mongodb-mongosh -y &>>$LOG_FILE

echo load master data
mongosh --host mongo.dev.renuka.online </app/db/master-data.js &>>$LOG_FILE

