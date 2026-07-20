# Variables
COMPOSE_FILE   := infra-system/docker-compose.yml
DOCKER_COMPOSE := docker compose -f $(COMPOSE_FILE)

SOLR_CONTAINER  := episciences-solr
ZK_HOST         := episciences-zoo:2181
CONFIGSETS_DIR  := /opt/configsets

# Default target
.DEFAULT_GOAL := help

.PHONY: help up network build restart down logs ps urls \
        db-import-episciences db-import-auth db-import-indexing db-import-citations db-import \
        solr-upload-config solr-create-collection solr-setup

help: ## Show this help message
	@echo "📦 Episciences Infrastructure"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-28s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@$(MAKE) -s urls

urls: ## Show all service and application URLs
	@echo "🌐 Infrastructure services:"
	@echo "  🛠️  Traefik:             https://traefik.episciences.org/dashboard/"
	@echo "  🔍 Solr:                https://solr.episciences.org"
	@echo "  🐘 phpMyAdmin:          https://pma.episciences.org"
	@echo "  📧 Mailpit:             https://mailpit.episciences.org"
	@echo "  📊 SonarQube:           https://sonar.episciences.org"
	@echo ""
	@echo "🚀 Connected applications (start each project separately):"
	@echo "  📰 Journal platform:    https://dev.episciences.org"
	@echo "  📡 OAI-PMH endpoint:   https://oai-dev.episciences.org"
	@echo "  📡 OAI-PMH Next Gen:    https://oaing-dev.episciences.org"
	@echo "  🌍 Portal / data site:  https://data-dev.episciences.org"
	@echo "  📚 Citations service:   https://citations-dev.episciences.org"
	@echo "  🔌 Platform API:        https://api-dev.episciences.org"
	@echo "  🖥️  Manager front-end:   https://manager-ng-dev.episciences.org"
	@echo ""
	@echo "💡 All domains must resolve to 127.0.0.1 in /etc/hosts"
	@echo "   TLS is terminated by Traefik (self-signed cert — accept browser warning)"

network: ## Create shared epi-network if it does not exist
	@docker network inspect epi-network > /dev/null 2>&1 \
		|| (docker network create epi-network && echo "✅ epi-network created")

up: network ## Start all containers in detached mode
	@if [ -f /proc/sys/vm/max_map_count ]; then \
		MAP_COUNT=$$(cat /proc/sys/vm/max_map_count); \
		if [ $$MAP_COUNT -lt 262144 ]; then \
			echo "\033[33m⚠️  [Warning] vm.max_map_count is $$MAP_COUNT, which is too low for SonarQube.\033[0m"; \
			echo "   Elasticsearch (embedded in SonarQube) will likely crash."; \
			echo "   Please run the following command on your host to increase it:"; \
			echo "   \033[36msudo sysctl -w vm.max_map_count=524288\033[0m"; \
			echo ""; \
		fi; \
	fi
	$(DOCKER_COMPOSE) up -d
	@$(MAKE) -s urls

build: ## Pull or rebuild services
	$(DOCKER_COMPOSE) pull

restart: ## Restart containers
	$(DOCKER_COMPOSE) restart

down: ## Stop and remove containers (with confirmation)
	@echo "Are you sure you want to stop and remove containers? [y/N] " && read ans && [ "$${ans:-N}" = "y" ]
	$(DOCKER_COMPOSE) down

logs: ## View output from containers
	$(DOCKER_COMPOSE) logs -f

ps: ## List containers
	$(DOCKER_COMPOSE) ps

# ─── MySQL ────────────────────────────────────────────────────────────────────

db-import-episciences: ## Import episciences database (resets existing data)
	@echo "⏳ Importing episciences DB..."
	@docker exec -i episciences-db-episciences \
		mysql -u episciences -pepisciences episciences \
		< infra-system/mysql/episciences/episciences.sql
	@echo "✅ episciences DB imported"

db-import-auth: ## Import auth (cas_users) database (resets existing data)
	@echo "⏳ Importing auth DB..."
	@docker exec -i episciences-db-auth \
		mysql -u cas_users -pcas_users cas_users \
		< infra-system/mysql/auth/cas_users.sql
	@echo "✅ auth DB imported"

db-import-indexing: ## Import Solr indexing queue database (resets existing data)
	@echo "⏳ Importing indexing DB..."
	@docker exec -i episciences-db-indexing \
		mysql -u solr_index -psolr_index solr_index \
		< infra-system/mysql/solr/solr_index_queue.sql
	@echo "✅ indexing DB imported"

db-import-citations: ## Import citations database (resets existing data)
	@echo "⏳ Importing citations DB..."
	@docker exec -i episciences-db-citations \
		mysql -u 'epi-citations' -p'epi-citations' 'epi-citations' \
		< infra-system/mysql/citations/citations.sql
	@echo "✅ citations DB imported"

db-import: db-import-episciences db-import-auth db-import-indexing db-import-citations ## Import all databases

# ─── Solr ─────────────────────────────────────────────────────────────────────

solr-upload-config: ## Upload episciences configset to ZooKeeper
	@echo "⏳ Uploading episciences configset to ZooKeeper..."
	@docker exec $(SOLR_CONTAINER) \
		/opt/solr/bin/solr zk upconfig \
		-d $(CONFIGSETS_DIR)/episciences \
		-n episciences \
		-z $(ZK_HOST)
	@echo "✅ Configset uploaded"

solr-create-collection: ## Create episciences Solr collection (skips if already exists)
	@echo "⏳ Creating episciences Solr collection..."
	@docker exec $(SOLR_CONTAINER) \
		curl -sf "http://localhost:8983/solr/admin/collections?action=CREATE&name=episciences&numShards=1&replicationFactor=1&collection.configName=episciences" \
		> /dev/null \
		&& echo "✅ Collection created" \
		|| echo "⚠️  Collection may already exist — check http://localhost:8983/solr/#/~collections"

solr-setup: solr-upload-config solr-create-collection ## Upload configset and create Solr collection