LOG_FILE=/tmp/Roboshop.log
NODEJS () {

  echo disable nodejs default version
  dnf module disable nodejs -y &>$LOG_FILE

  echo enable nojejs 20 module
  dnf module enable nodejs:20 -y &>$LOG_FILE

  echo install nodejs
  dnf install nodejs -y &>$LOG_FILE

  echo copy service file
  cp ${component}.service /etc/systemd/system/${component}.service &>$LOG_FILE

  echo copy mongodb repo file
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>$LOG_FILE

  echo adding application user
  useradd roboshop &>$LOG_FILE

  echo cleaning old content
  rm -rf /app &>$LOG_FILE

  echo create app directory
  mkdir /app &>$LOG_FILE

  echo download app content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip &>$LOG_FILE
  cd /app

  echo extract app content
  unzip /tmp/${component}.zip &>$LOG_FILE


  echo install nodejs dependcies
  npm install &>$LOG_FILE
  systemctl daemon-reload &>$LOG_FILE
  systemctl enable ${component}&>$LOG_FILE
  systemctl restart ${component}&>$LOG_FILE
}