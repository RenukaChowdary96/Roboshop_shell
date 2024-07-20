NODEJS () {

  echo disable nodejs default version
  dnf module disable nodejs -y

  echo enable nojejs 20 module
  dnf module enable nodejs:20 -y

  echo install nodejs
  dnf install nodejs -y

  echo copy service file
  cp ${component}.service /etc/systemd/system/${component}.service

  echo copy mongodb repo file
  cp mongo.repo /etc/yum.repos.d/mongo.repo

  echo adding application user
  useradd roboshop

  echo cleaning old content
  rm -rf /app

  echo create app directory
  mkdir /app

  echo download app content
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}-v3.zip
  cd /app

  echo extract app content
  unzip /tmp/${component}.zip


  echo install nodejs dependcies
  npm install
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}
}