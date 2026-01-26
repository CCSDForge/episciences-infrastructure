# Variables
COMPOSE_FILE := infra-system/docker-compose.yml
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE)

# Default target
.DEFAULT_GOAL := help

# Phony targets
.PHONY: help up build restart down logs ps urls

help: ## Show this help message
	@echo "📦 Episciences Infrastructure"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@$(MAKE) -s urls

urls: ## Show service URLs
	@echo "🌐 Service URLs:"
	@echo "  🔍 Solr:        https://solr.episciences.org"
	@echo "  🐘 phpMyAdmin:  https://pma.episciences.org"
	@echo ""
	@echo "💡 Note: Ensure these domains are in your /etc/hosts mapping to 127.0.0.1"

up: ## Start containers in detached mode
	$(DOCKER_COMPOSE) up -d

build: ## Build or rebuild services
	$(DOCKER_COMPOSE) build

restart: ## Restart containers
	$(DOCKER_COMPOSE) restart

down: ## Stop and remove containers, networks (with confirmation)
	@echo "Are you sure you want to stop and remove containers? [y/N] " && read ans && [ "$${ans:-N}" = "y" ]
	$(DOCKER_COMPOSE) down

logs: ## View output from containers
	$(DOCKER_COMPOSE) logs -f

ps: ## List containers
	$(DOCKER_COMPOSE) ps