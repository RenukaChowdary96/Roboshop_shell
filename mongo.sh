cp mongo.repo /etc/yum.repos.d/mongo.repo
dnf install mongodb-org -y

systemctl start mongod
# update config file
systemctl enable mongod
systemctl restart mongod