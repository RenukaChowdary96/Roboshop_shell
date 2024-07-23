source common.sh
component=catalogue
app_path=/app

NODEJS

echo install mongodb cilent
dnf install mongodb-mongosh -y &>>$LOG_FILE
STAT $?


echo load master data
mongosh --host mongo.dev.renuka.online </app/db/master-data.js &>>$LOG_FILE
STAT $?


