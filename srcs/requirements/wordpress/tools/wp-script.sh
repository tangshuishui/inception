#!/bin/bash

# 进入工作目录 (稍后会在 docker-compose 中挂载 volume 到这里)
cd /var/www/html

sleep 5

# 如果 wp-config.php 不存在，说明是第一次启动，需要安装
# 使用 WP-CLI (wp) 自动化部署
# --allow-root 因为在容器里脚本通常是以 root 权限运行的，而 WP-CLI 默认禁止 root 用户执行，加上这个参数强制允许
if [ ! -f wp-config.php ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Configuring WordPress..."
    # 生成 wp-config.php，连接数据库 (这里的 db host 填 mariadb 容器的名字)
    wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb:3306 --allow-root

    echo "Installing WordPress..."
    wp core install --url=$DOMAIN_NAME --title="Inception" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root

    echo "Creating a second user..."
    wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root
    # chown （change owner），统统交接给打工人 www-data:www-data (用户：用户组)
    echo "Setting correct permissions..."
    chown -R www-data:www-data /var/www/html
fi

# 准备系统环境，PHP-FPM 需要这个目录存在才能运行
# -p 如果已存在则不报错
mkdir -p /run/php

# 以前台模式运行 PHP-FPM ，成为容器主进程(PID 1)
# 匹配 Debian 12 默认提供的 PHP 8.2
# -F (--nodaemonize) 不要转入后台
exec /usr/sbin/php-fpm8.2 -F