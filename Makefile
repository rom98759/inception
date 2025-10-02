NAME=inception
include srcs/.env
export $(shell sed 's/=.*//' srcs/.env)


all: setup up

setup: dns-setup data-setup

dns-setup:
	@if ! grep -q "$(DOMAIN_NAME)" /etc/hosts; then \
		echo "127.0.0.1	$(DOMAIN_NAME)" | sudo tee -a /etc/hosts; \
		echo "DNS configuré pour $(DOMAIN_NAME)"; \
	else \
		echo "DNS déjà configuré pour $(DOMAIN_NAME)"; \
	fi

data-setup:
	@mkdir -p /home/$(USER)/data/mariadb
	@mkdir -p /home/$(USER)/data/wordpress
	@echo "Dossiers de données créés dans /home/$(USER)/data/"

up:
	docker compose -f ./srcs/docker-compose.yml --env-file ./srcs/.env up --build -d

down:
	docker compose -f ./srcs/docker-compose.yml down

fclean: down
	docker compose -f ./srcs/docker-compose.yml down --volumes --rmi all
	docker builder prune -f
	@sudo rm -rf /home/$(USER)/data/mariadb/*
	@sudo rm -rf /home/$(USER)/data/wordpress/*
	@echo "Dossiers de données nettoyés dans /home/$(USER)/data/"

dns-clean:
	@sudo sed -i '/$(DOMAIN_NAME)/d' /etc/hosts
	@echo "DNS nettoyé pour $(DOMAIN_NAME)"

clean_cache:
	docker builder prune -f

re: fclean all

.PHONY: all setup dns-setup data-setup up down fclean dns-clean re clean_cache