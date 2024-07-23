source common.sh
component=catalogue

NODEJS

echo install mongodb cilent
dnf install mongodb-mongosh -y &>>$LOG_FILE
if [ $? -eq 0 ]; then
    echo SUCCESS
  else
    echo FALIURE
  fi


echo load master data
mongosh --host mongo.dev.renuka.online </app/db/master-data.js &>>$LOG_FILE
if [ $? -eq 0 ]; then
    echo SUCCESS
  else
    echo FALIURE
    fi


