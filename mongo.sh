 source common.sh
 component=mongo

PRINT COPY MONGODB REPO FILE
cp mongo.repo /etc/yum.repos.d/mongo.repo
STAT $?

PRINT Install Mongoodb
dnf install mongodb-org -y
STAT $?

PRINT   Update Config file
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
STAT $?

PRINT Start Mongodb Sevice
systemctl enable mongod
systemctl restart mongod
STAT $?
