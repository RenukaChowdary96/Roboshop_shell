source common.sh
component=frontend
app_path=/usr/share/nginx/html/

PRINT Disable  Nginx Default Version
dnf module disable nginx -y &>>$LOG_FILE
STAT $?

PRINT Enable nginx default version
dnf module enable nginx:1.24 -y &>>$LOG_FILE
STAT $?

PRINT install Nginx
dnf install nginx -y &>>$LOG_FILE
STAT $?

PRINT copy nginx config file
cp nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
STAT $?

APP_PREREQUISTES

PRINT Start  Nginx service
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
STAT $?