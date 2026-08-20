#!/bin/bash

set -e

DBDIR="/var/lib/mysql"

# 检测是否是第一次挂载空目录
if [ ! -d "$DBDIR/mysql" ]; then
  echo "Initializing database directory..."

  # 确保 mysql 用户对挂载的 Volume 有绝对所有权
  chown -R mysql:mysql "$DBDIR"

  # 初始化系统核心表
  mysql_install_db --user=mysql --datadir="$DBDIR" > /dev/null

  echo "Creating database and users..."
  # 使用 --bootstrap 直接灌入 SQL 语句，不启动后台 daemon
  cat << EOF | mysqld --user=mysql --bootstrap
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';
FLUSH PRIVILEGES;
EOF
  echo "Database initialized successfully."

fi

echo "start MariaDB foreground process..."
# 正式挂载 PID 1
exec mysqld --user=mysql --datadir="$DBDIR"
