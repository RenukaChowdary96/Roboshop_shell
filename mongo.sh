 source common.sh
 component=mongo

PRINT COPY MONGODB REPO FILE
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
STAT $?

PRINT Install Mongoodb
dnf install mongodb-org -y &>>$LOG_FILE
STAT $?

PRINT   Update Config file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
STAT $?

PRINT Start Mongodb Sevice
systemctl enable mongod &>>$LOG_FILE
systemctl restart mongod &>>$LOG_FILE
STAT $?
