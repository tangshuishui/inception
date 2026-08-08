*This project has been created as part of the 42 curriculum by hanwang.*

# Inception

## Description

The **Inception** project aims to broaden knowledge of system administration by implementing a fully containerized infrastructure using Docker. The goal is to virtualize several Docker images within a personal virtual machine, building an entire LEMP-like stack (Linux, NGINX, MariaDB, PHP/WordPress) from scratch.

### Overview and Design Choices
This project strictly avoids ready-made Docker Hub images (like `nginx` or `wordpress`). Instead, every service is built manually using custom `Dockerfile`s based on the penultimate stable version of Debian (Bookworm). 

Key design choices include:
- **One Container, One Service:** NGINX, WordPress + php-fpm, and MariaDB all run in their own dedicated containers.
- **PID 1 Compliance:** Daemons run in the foreground (e.g., `nginx -g "daemon off;"`) rather than using hacky patches like `tail -f` to keep containers alive.
- **TLS Secure Entry:** NGINX serves as the sole entry point to the infrastructure via port 443 (HTTPS) using TLSv1.2/1.3.

### Architectural Comparisons

As part of the technical exploration, this project highlights the differences between several core concepts:

- **Virtual Machines vs Docker:** 
  A Virtual Machine virtualizes an entire hardware stack, requiring a full Guest OS to run, which consumes significant RAM and CPU. Docker, on the other hand, virtualizes at the OS level. Containers share the Host OS kernel, making them extremely lightweight, fast to start, and less resource-intensive.
  
- **Secrets vs Environment Variables:** 
  Environment variables (managed via `.env`) are convenient for configuring containers but can be exposed if a container is inspected (`docker inspect`) or if an application leaks its environment. Docker Secrets provide a higher level of security by encrypting the data at rest and mounting it directly into the container's memory (`tmpfs`), ensuring sensitive credentials are never written to disk.

- **Docker Network vs Host Network:** 
  Using a Host Network (`network_mode: host`) binds the container directly to the host's network interfaces, offering no isolation and potential port conflicts. A Docker Bridge Network (used in this project) creates an isolated, internal LAN for the containers. This provides security (ports aren't exposed unless explicitly mapped) and enables automatic internal DNS resolution (e.g., WordPress can reach the database simply by calling `mariadb`).

- **Docker Volumes vs Bind Mounts:** 
  Bind Mounts link a specific path on the host machine to a directory inside the container, heavily relying on the host's exact filesystem structure and permissions. Docker Volumes are entirely managed by Docker within a dedicated storage area. Volumes are the preferred method for persistent data because they are easier to back up, migrate, and are safely isolated from core host system files.

## Instructions

### Prerequisites
Before launching the project, ensure **Docker** and **Docker Compose** are installed on your Virtual Machine.

1. **Domain Configuration:** You must route your personal domain to your local loopback address. Edit your host machine's `/etc/hosts` file (`sudo nano /etc/hosts`) and add the following line:
    ```text
    127.0.0.1 hanwang.42.fr
    ```
2. **Environment Variables:** Ensure a valid `.env` file is present inside the `srcs/` directory. This file must contain all necessary credentials (database passwords, WordPress admin details, etc.) and should **never** be pushed to the repository.


### Compilation and Execution
The entire infrastructure is automated via a `Makefile` located at the root of the repository.

1. Clone the repository and navigate to the root directory.
    ```bash
    cd inception
    ```
2. Run the following command to build the images and start the containers in the background:
   ```bash
   make
   ```
   (Note: The Makefile will automatically create the necessary local volume directories at `/home/hanwang/data/wordpress` and `/home/hanwang/data/mariadb` before launching Docker Compose).
3. **Verification**: Check that all three containers (`nginx`, `wordpress`, `mariadb`) are running successfully:
    ```bash
    docker ps
    ```
4. **Access the website**: Open a web browser and navigate to `https://hanwang.42.fr`. Since the TLS certificate is self-signed locally, you will need to explicitly accept and bypass the browser's security warning.

5. **Access the WordPress admin panel**: Go to `https://hanwang.42.fr/wp-admin` and log in using the administrator credentials specified in your `.env` file.

### Management Commands
Use the following Makefile rules to manage the lifecycle of your infrastructure:

- `make clean`: Stops and removes the Docker containers and networks.

- `make fclean`: Performs a deep clean, removing all containers, images, volumes, and physically deleting the persistent data on the host machine.

- `make re`: Fully cleans and rebuilds the project from scratch.

## Resources
- Docker Documentation: https://docs.docker.com/

- NGINX Official Docs: https://nginx.org/en/docs/

- MariaDB Configuration: https://mariadb.com/kb/en/configuring-mariadb-with-option-files/

- WordPress CLI (WP-CLI): https://make.wordpress.org/cli/

## AI Usage Statement
Artificial Intelligence was utilized during the development of this project for the following tasks:

- Conceptual Clarification: Used to better understand the differences between Docker components (e.g., Volumes vs Bind Mounts, internal networking) for documentation purposes.

- Bash Script Optimization: Assisted in formatting and optimizing the initialization shell scripts (wp-script.sh and mariadb.sh) to ensure proper foreground execution and error handling.

- Markdown Formatting: Aided in structuring and formatting this README.md, USER_DOC.md, and DEV_DOC.md to ensure clarity, readability, and strict adherence to the subject's requirements.