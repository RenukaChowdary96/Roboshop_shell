LOG_FILE=/tmp/Roboshop.log
rm -f $LOG_FILE

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


  PRINT  copy service file
  cp ${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  STAT $?


  PRINT  copy mongodb repo file
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
  STAT $?


  PRINT  adding application user
  useradd roboshop &>>$LOG_FILE
 STAT $?


  PRINT  cleaning old content
  rm -rf /app &>>$LOG_FILE
  STAT $?


  PRINT  create app directory
  mkdir /app &>>$LOG_FILE
STAT $?


  PRINT  download app content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  STAT $?

  cd /app

  PRINT  extract app content
  unzip /tmp/${component}.zip &>>$LOG_FILE
  STAT $?
  PRINT  install nodejs dependcies
  npm install &>>$LOG_FILE

  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  STAT $?

}