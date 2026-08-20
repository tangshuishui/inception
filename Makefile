DATA_DIR = /home/hanwang/data

all: 
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/mariadb
	@cd srcs && docker-compose up -d --build

clean:
	@cd srcs && docker-compose down -v

fclean: clean
	@sudo rm -rf $(DATA_DIR)/wordpress/*
	@sudo rm -rf $(DATA_DIR)/mariadb/*
	@docker system prune -af

re: fclean all

.PHONY: all clean fclean re