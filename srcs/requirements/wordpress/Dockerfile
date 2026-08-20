FROM debian:bookworm

# 下载，安装，清理
# wget 下载工具, php 处理网页请求
# php-mysql扩展 看懂MySQL/MariaDB的协议，wordpress连接数据库
# mariadb-client 数据库客户端，用于在命令行里测试连接数据库
RUN apt-get update -y && apt-get install -y \
    curl \
    php8.2-cli \
    php8.2-fpm \
    php8.2-mysql \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# 创建 php-fpm 运行所需的目录
# Debian 的 PHP-FPM 默认会尝试在 /run/php/ 目录下创建 sock 或 pid 文件
# 如果目录不存在，容器启动时会直接 Crash
RUN mkdir -p /run/php

# 下载并安装 wp-cli
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# 把宿主机上的 www.conf 替换到容器内部 PHP-FPM 的默认配置目录
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# 复制脚本并赋予权限
COPY tools/wp-script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/wp-script.sh

# 指定容器运行时的默认路径
WORKDIR /var/www/html

EXPOSE 9000

# 使用 ENTRYPOINT 锁定容器的唯一入口进程
ENTRYPOINT ["/usr/local/bin/wp-script.sh"]