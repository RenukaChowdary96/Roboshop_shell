source common.sh
component=mongo

PRINT  install mysql server
dnf install mysql-server -y &>>$LOG_FILE
STAT $?


PRINT start mysql service
systemctl enable mysqld &>>$LOG_FILE
systemctl restart mysqld &>>$LOG_FILE
STAT $?


PRINT Setup Mysql   Root Password
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOG_FILE
STAT $?

