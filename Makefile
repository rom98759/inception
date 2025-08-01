NAME=inception

all: up

up:
	docker compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up --build -d

down:
	docker compose -f ./srcs/docker-compose.yml down

fclean: down
	docker compose -f ./srcs/docker-compose.yml down --volumes --rmi all

re: fclean all

.PHONY: all up down fclean re