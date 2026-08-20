# Developer Documentation - Inception

## 1. Environment Setup

### Prerequisites
Before launching the project, ensure the host machine (VM) has the following packages and configurations ready:
* `make`
* **Domain Routing:** The host file `/etc/hosts` must be modified to point `hanwang.42.fr` to `127.0.0.1`.

### Environment Variables (`./srcs/.env`)
Create a `.env` file inside the `./srcs/` directory. This file centralizes the runtime parameters, database configurations, and credentials required for the containers. 

```env
# User Configuration
DOMAIN_NAME=hanwang.42.fr

# MariaDB Configurations
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_secret_pass
MYSQL_ROOT_PASSWORD=super_secret_root

# WordPress Account Credentials
WP_ADMIN_USER=chief_commander
WP_ADMIN_PASSWORD=chief_secret_pass
WP_ADMIN_EMAIL=chief@hanwang.42.fr

WP_USER=author_john
WP_USER_EMAIL=john@hanwang.42.fr
WP_USER_PASSWORD=author_secret_pass
```

---

## 2. Project Management via Makefile

The `Makefile` at the root automates the entire deployment process, including creating the required physical data directories on the host machine before launching containers.

```bash
# Build custom images and start NGINX, WordPress, and MariaDB containers in the background
make 

# Stop and remove containers and custom networks (preserves persistent data volumes)
make clean

# Remove all containers, volumes, unused images, and permanently wipe the host data directory
make fclean

# Complete reset: executes fclean followed by make
make re
```


---

## 3. Native Docker Compose Commands

While the `Makefile` automates the workflow, developers can directly manage the container stack lifecycle using native `docker compose` commands from the `./srcs` directory:

```bash
# Build and start all containers in detached (background) mode
docker compose --env-file .env -f docker-compose.yml up -d --build

# Stop containers without removing them or their associated volumes
docker compose --env-file .env -f docker-compose.yml stop

# Stop and remove containers and networks, AND purge associated Docker volumes
docker compose --env-file .env -f docker-compose.yml down -v
```

---

## 4. Container & Network Management Commands

Use these commands for debugging and monitoring during the evaluation session:

* **Container Lifecycle & Live Logs:**
  ```bash
  docker ps -a
  docker-compose -f srcs/docker-compose.yml logs -f
  ```

* **Interactive Debugging (Shell Execution):**
  ```bash
  docker exec -it nginx bash
  docker exec -it wordpress bash
  ```

* **Inspect Volumes and Networks:**
  ```bash
  docker volume ls
  docker volume inspect mariadb_data
  
  docker network ls
  docker network inspect inception_network
  ```

---

## 5. Data Persistence Architecture

The project strictly prohibits direct bind mounts for persistent data. Instead, **local named volumes** are configured in `docker-compose.yml` to securely manage database and website files.

* **Storage Locations:**
  * **`wordpress_data`:** Stores WordPress core files, themes, and uploaded media. Mounted to `/var/www/html` inside the container, stored physically at `/home/hanwang/data/wordpress` on the host.
  * **`mariadb_data`:** Stores database tables. Mounted to `/var/lib/mysql` inside the container, stored physically at `/home/hanwang/data/mariadb` on the host.

* **Container Lifecycle Resilience:**
  Running `make clean` or `docker compose down` destroys the containers and virtual networks, but these volumes ensure data survives. Running `make` again re-attaches the existing data to the new containers seamlessly.

* **Complete Data Purge:**
  Executing `make fclean` permanently deletes the local named volumes via Docker, and runs `sudo rm -rf /home/hanwang/data` to completely wipe the physical files from the host machine.