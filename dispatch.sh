source common.sh
component=dispatch
app_path=/app

PRINT Copy dispatch  service file
cp dispatch.service /etc/systemd/system/dispatch.service &>>$LOG_FILE
STAT $?

PRINT install golang
dnf install golang -y &>>$LOG_FILE
STAT $?

APP_PREREQ

PRINT setting up golang
go mod init dispatch &>>$LOG_FILE
go get &>>$LOG_FILE
go build &>>$LOG_FILE
STAT $?

PRINT Start dispatch Service
systemctl daemon-reload &>>$LOG_FILE
systemctl enable dispatch &>>$LOG_FILE
systemctl restart dispatch &>>$LOG_FILE
STAT $?