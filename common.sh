LOG_FILE=/tmp/Roboshop.log
rm -f $LOG_FILE

PRINT() {
  echo &>>$LOG_FILE
  echo &>>$LOG_FILE
  echo "###############################$*###############################" &>>$LOG_FILE
  echo $*
}
NODEJS () {

  PRINT disable nodejs default version
  dnf module disable nodejs -y &>>$LOG_FILE
  if [ $? -eq 0 ]; then
    echo SUCCESS
  else
    echo FALIURE
  fi

  PRINT  enable nojejs 20 module
  dnf module enable nodejs:20 -y &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
    fi


  PRINT  install nodejs
  dnf install nodejs -y &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
    fi


  PRINT  copy service file
  cp ${component}.service /etc/systemd/system/${component}.service &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
    fi


  PRINT  copy mongodb repo file
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
    fi


  PRINT  adding application user
  useradd roboshop &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
    fi


  PRINT  cleaning old content
  rm -rf /app &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
  fi


  PRINT  create app directory
  mkdir /app &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
    fi


  PRINT  download app content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
    fi

  cd /app

  PRINT  extract app content
  unzip /tmp/${component}.zip &>>$LOG_FILE
  if [ $? -eq 0]; then
      echo SUCCESS
    else
      echo FALIURE
     fi
  PRINT  install nodejs dependcies
  npm install &>>$LOG_FILE
  if [ $? -eq 0 ];then
      echo SUCCESS
    else
      echo FALIURE
     fi

  systemctl daemon-reload &>>$LOG_FILE
  systemctl enable ${component} &>>$LOG_FILE
  systemctl restart ${component} &>>$LOG_FILE
  if [ $? -eq 0 ]; then
      echo SUCCESS
    else
      echo FALIURE
    fi

}