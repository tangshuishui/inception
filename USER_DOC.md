# User Documentation - Inception

## 1. Overview of Provided Services
This infrastructure provides a fully functional, secure web architecture using Docker containers:
- **NGINX**: Web server acting as a TLS Reverse Proxy (listening on Port 443 only).
- **WordPress + PHP-FPM**: Dynamic website engine and FastCGI handler for processing PHP requests.
- **MariaDB**: Relational database management system securely isolated from the public network.

---

## 2. Quick Start: How to start or stop the project?
Use the provided `Makefile` in the root directory to manage the project lifecycle:

`make all`
Build Docker images and start all containers in the background.

`make clean`
Stop containers and remove networks created by docker-compose.

`make fclean`
Complete wipe: Stop containers, remove volumes, delete host data directories (/home/hanwang/data), and prune images.

`make re`
Rebuild the entire project from scratch.

---

## 3. Accessing the Website & Admin Dashboard

### Main Website
- **URL**: `https://hanwang.42.fr`
- **Security Notice**: Since this project uses a self-signed SSL certificate, your browser will display a security warning. Click on **Advanced** and select **Accept the Risk and Continue** (or *Proceed*) to view the website.

### WordPress Administration Panel
- **URL**: `https://hanwang.42.fr/wp-admin`
- **Authentication**: Enter the administrator username and password to log into the dashboard. From here, you can manage posts, themes, plugins, and the second user account.

---

## 4. Credentials Management
For security reasons and to comply with project guidelines, no credentials are hardcoded in the Dockerfiles or scripts.

- **Location**: All passwords and usernames (MariaDB root, MariaDB user, WordPress Admin, WordPress User) are securely stored as environment variables in the `.env` file located at: `./srcs/.env`
- **Security Warning**: This `.env` file contains highly sensitive information. **Do not share this file or commit it to a public Git repository.**

---

## 5. Service Health & Status Verification

### Check Container Status
Verify that all containers are running properly:
`docker ps`

*Expected output: You should see three containers (`nginx`, `wordpress`, `mariadb`) with the status "Up". Ensure that only NGINX exposes port `443` to `0.0.0.0` and `[::]`, while MariaDB (3306) and WordPress (9000) remain strictly internal.*

### Check Container Logs
If a service is misbehaving, you can follow its logs for debugging:
`docker logs <container_name>`  *(e.g., docker logs wordpress)*

### Check Website HTTP Response
Verify that the NGINX reverse proxy is successfully serving the HTTPS traffic:
`curl -kI https://hanwang.42.fr`

*Expected output: You should receive an `HTTP/1.1 200 OK` or `302 Found` status code.*
EOF