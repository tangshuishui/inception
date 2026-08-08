FROM debian:bookworm

# 安装 NGINX （Web服务器）和 OpenSSL（用于生成加密证书的工具）
RUN apt-get update -y && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

# 创建存放 SSL 证书的目录
RUN mkdir -p /etc/nginx/ssl

# 生成自签名证书（有效天数 365，没有密码，直接输出到指定路径）
# req -x509 ： 标准的X.509格式自签名证书，不是普通证书（CSR）
# -nodes： 生成的私钥不会被加密（DO DES）
# -out / -keyout： 指定公钥（.crt)和私钥（.key)的保存路径
# -subj: 证书的主体信息
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=hanwang.42.fr/UID=hanwang"

# 将准备好的配置文件覆盖 NGINX 默认配置
COPY conf/nginx.conf /etc/nginx/sites-available/default

# 暴露 443 端口（HTTPS）
EXPOSE 443

# 前台运行 NGINX (PID 1 规则)
CMD ["nginx", "-g", "daemon off;"]