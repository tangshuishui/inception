# Inception - User Documentation

## 1. Services Provided
This infrastructure provides a fully functional WordPress website running on a secure NGINX web server, backed by a MariaDB database. 

## 2. How to Start and Stop the Project
- **Start the project:** Run `make` in the root directory.
- **Stop the project:** Run `make clean`.
- **Complete wipe (including data):** Run `make fclean`.

## 3. Accessing the Services
- **Main Website:** `https://hanwang.42.fr`
- **Administration Panel:** `https://hanwang.42.fr/wp-admin`

## 4. Credentials
All default passwords and usernames (Database, WordPress Admin, WordPress User) are stored in the `.env` file located at `srcs/.env`. 

Do not share this file.

## 5. Checking Service Status
To verify that all services are running correctly, execute:
`docker ps`

You should see three containers (`nginx`, `wordpress`, `mariadb`) with the status "Up".