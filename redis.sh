PRINT Disable redis Default
dnf module disable redis -y
STAT $?

PRINT Enable redis 7
dnf module enable redis:7 -y
STAT $?


PRINT install redis 7
dnf install redis -y
STAT $?

PRINT update  Redis config file
sed -i '/^bind/ s/127.0.0.1/0.0.0.0/' -e '/protected mode/ c protected-mode no' /etc/redis/redis.conf
STAT $?

PRINT Start Redsis Service
systemctl enable redis
systemctl restart redis
STAT $?

