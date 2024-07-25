source common.sh
component=payment
app_path=/app

PRINT Copy payment  service file
cp payment.service /etc/systemd/system/payment.service &>>$LOG_FILE
STAT $?

PRINT install python3
dnf install python3 gcc python3-devel -y &>>$LOG_FILE
STAT $?

APP_PREREQ

PRINT install requirements
pip3 install -r requirements.txt &>>$LOG_FILE
STAT $?

PRINT Start payment Service
systemctl daemon-reload &>>$LOG_FILE
systemctl enable payment &>>$LOG_FILE
systemctl restart payment &>>$LOG_FILE
STAT $?