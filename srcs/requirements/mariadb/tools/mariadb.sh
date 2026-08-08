#!/bin/bash

set -e

DBDIR="/var/lib/mysql"

# 检测是否是第一次挂载空目录
if [ ! -d "$DBDIR/mysql" ]; then
  echo "Initializing database directory..."
  # 初始化系统核心表
  mysql_install_db --user=mysql --datadir="$DBDIR" > /dev/null

  echo "start temporarily MariaDB process..."
  # 安全模式后台启动
  mysqld --datadir="$DBDIR" --skip-networking --skip-bind-address &

  # 智能等待数据库启动完毕
  until mysqladmin ping --silent; do
    sleep 1
  done

  echo "Creating database and users..."
  # 使用 Heredoc 设置 root 密码
  mysql -u root <<-EOSQL
  ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
  FLUSH PRIVILEGES;
EOSQL
  # 使用你的环境变量创建项目所需的数据库和用户
  mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
  mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
  mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
  mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

  echo "close MariaDB process..."
  # 关闭临时进程
  mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
fi

echo "start MariaDB foreground process..."
# 正式挂载 PID 1
exec mysqld_safe --datadir="/var/lib/mysql"



# # 启动 mysql 服务以便我们在初始化时执行 SQL 命令
# service mariadb start 

# # 等待几秒钟确保服务已启动
# sleep 5 

# # 使用环境变量创建数据库、用户，并赋予权限
# mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
# mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
# mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
# mysql -e "FLUSH PRIVILEGES;"

# # 关闭后台服务
# mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

# # 以前台守护进程模式启动 MariaDB（满足 Subject 不允许后台死循环的要求，PID 1）
# exec mysqld_safe