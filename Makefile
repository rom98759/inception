NAME=inception
include srcs/.env
export $(shell sed 's/=.*//' srcs/.env)


all: setup up ping

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

ping:
	@echo "Attente que le service https://$(DOMAIN_NAME) soit opérationnel..."
	@until [ "$$(curl -k -o /dev/null -s -w '%{http_code}' https://$(DOMAIN_NAME))" = "200" ]; do \
		echo "Pas encore prêt ..."; \
		sleep 1; \
	done
	@echo "✅ Le service https://$(DOMAIN_NAME) est opérationnel."

# 	@echo "Attente que le service https://$(DOMAIN_NAME)/adminer soit opérationnel..."
# 	@until [ "$$(curl -k -o /dev/null -s -w '%{http_code}' https://$(DOMAIN_NAME)/adminer) " = "200" ]; do \
# 		echo "Pas encore prêt ..."; \
# 		sleep 1; \
# 	done
# 	@echo "✅ Le service https://$(DOMAIN_NAME)/adminer est opérationnel."

# 	@echo "Attente que le service https://$(DOMAIN_NAME)/cv soit opérationnel..."
# 	@until [ "$$(curl -k -o /dev/null -s -w '%{http_code}' https://$(DOMAIN_NAME)/cv) " = "200" ]; do \
# 		echo "Pas encore prêt ..."; \
# 		sleep 1; \
# 	done
# 	@echo "✅ Le service https://$(DOMAIN_NAME)/cv est opérationnel."
# 	@echo "Tous les services sont opérationnels."

re: fclean all

.PHONY: all setup dns-setup data-setup up down fclean dns-clean re clean_cache