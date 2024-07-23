LOG_FILE=/tmp/Roboshop.log
rm -f $LOG_FILE
code_dir=$(pwd)

PRINT() {
  echo &>>$LOG_FILE
  echo &>>$LOG_FILE
  echo "###############################$*###############################" &>>$LOG_FILE
  echo $*
}

STAT() {
  if [ $1 -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    echo
    echo "Refer the log file for the more information: file path: ${LOG_FILE}"
    exit $1
  fi

}
APP_PREREQUISTES(){

   PRINT  adding application user
    id roboshop &>>LOG_FILE
    if [ $? -ne 0 ]; then
     useradd roboshop &>>$LOG_FILE
    fi
     STAT $?

   PRINT Remove old content
   rm -rf ${app_path} &>>$LOG_FILE
   mkdir ${app_path} &>>$LOG_FILE
   STAT $?

   PRINT Create App Directory
   mkdir ${app_path} &>>$LOG_FILE
   STAT $?

   PRINT Download Application Content
     curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
      STAT $?

   PRINT Extract Application Content
      cd ${app_path}
      unzip /tmp/{component}.zip &>>$LOG_FILE
      STAT $?


}

SYSTEMD_SETUP() {
  PRINT Copy Service file
  cp ${code_dir}/${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  STAT $?

  PRINT Start service
  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  STAT $?
}
NODEJS () {

  PRINT disable nodejs default version
  dnf module disable nodejs -y &>>$LOG_FILE
  STAT $?

  PRINT  enable nojejs 20 module
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  STAT $?


  PRINT  install nodejs
  dnf install nodejs -y &>>$LOG_FILE
  STAT $?

  APP_PREREQUISTES

  PRINT  install nodejs dependcies
  npm install &>>$LOG_FILE
  STAT $?

  SCHEMA_SETUP
  SYSTEMD_SETUP

}
JAVA(){
  PRINT Download Maven and java
  dnf install maven -y &>>$LOG_FILE
  STAT $?

  APP_PREREQUISTES

  PRINT download Dependencies
  mvn clean package &>>$LOG_FILE
  mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
  STAT $?

  SCHEMA_SETUP
  SYSTEMD_SETUP


}
SCHEMA_SETUP(){
  if [ "$schema_setup" == "mongo" ]; then
    PRINT  copy mongodb repo file
      cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
      STAT $?

    PRINT install mongodb cilent
    dnf install mongodb-mongosh -y &>>$LOG_FILE
    STAT $?

    PRINT load master data
    mongosh --host mongo.dev.renuka.online </app/db/master-data.js &>>$LOG_FILE
    STAT $?
 fi

if [ "$sechema_setup" == "mysql" ]; then
    PRINT install MySQL cilent
    dnf install mysql-y &>>$LOG_FILE
    STAT $?

    PRINT load Schema
     mysql -h mysql.dev.renuka.online -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
     STAT $?

     PRINT load  Mater Schema
     mysql -h mysql.dev.renuka.online -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
     STAT $?

     PRINT Create app users
     mysql -h mysql.dev.renuka.online -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    STAT $?
  fi

}
