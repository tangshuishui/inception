# Inception - Developer Documentation

## 1. Prerequisites and Setup from Scratch
Before launching the project, ensure that:
- Docker and Docker Compose are installed.
- The host file `/etc/hosts` is modified to point `hanwang.42.fr` to `127.0.0.1`.
- A properly configured `.env` file exists in the `srcs/` directory.

## 2. Building and Launching
The `Makefile` at the root automates the entire deployment:
- It creates the required data directories on the host machine.
- It triggers `docker-compose up -d --build` using the configuration in `srcs/docker-compose.yml`.

## 3. Useful Commands for Container Management
- View live logs of all containers: `docker-compose -f srcs/docker-compose.yml logs -f`
- Enter a specific container (e.g., NGINX): `docker exec -it nginx bash`
- Inspect volumes: `docker volume ls`

## 4. Data Persistence Architecture
The project strictly prohibits bind mounts for persistent data. Instead, local named volumes are used.
- **wordpress_data:** Stores WP core files. Mounted to `/var/www/html` in containers, stored physically in `/home/hanwang/data/wordpress` on the host.
- **mariadb_data:** Stores database tables. Mounted to `/var/lib/mysql` in containers, stored physically in `/home/hanwang/data/mariadb` on the host.

These volumes ensure data survives container destruction.