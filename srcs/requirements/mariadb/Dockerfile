FROM debian:bookworm

# 安装 MariaDB
# -y 静默
RUN apt-get update -y && apt-get install mariadb-server -y \
    && rm -rf /var/lib/apt/lists/*

# 替换默认配置
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# 复制初始化脚本并赋予执行权限
COPY tools/mariadb.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/mariadb.sh

# 暴露端口
EXPOSE 3306

# 设置启动入口
CMD ["mariadb.sh"]