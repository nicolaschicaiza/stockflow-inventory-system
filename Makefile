# 🐳 StockFlow - Docker Development Makefile
# Simplifies Docker Compose commands for development workflow

# Variables
COMPOSE_FILE := docker-compose.yml
DEV_COMPOSE_FILE := docker-compose.dev.yml
ENV_FILE := .env.docker

# Default target
.DEFAULT_GOAL := help

# Colors for pretty output
GREEN := \033[0;32m
BLUE := \033[0;34m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

##@ Development Commands

.PHONY: dev
dev: ## 🚀 Start development environment (PostgreSQL + Backend + Frontend)
	@echo "$(GREEN)🚀 Starting StockFlow development environment...$(NC)"
	@cp $(ENV_FILE) .env 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) up --build

.PHONY: dev-detached
dev-detached: ## 🚀 Start development environment in background
	@echo "$(GREEN)🚀 Starting StockFlow development environment (detached)...$(NC)"
	@cp $(ENV_FILE) .env 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) up -d --build

.PHONY: dev-no-build
dev-no-build: ## ⚡ Start development environment without building
	@echo "$(BLUE)⚡ Starting StockFlow development environment (no build)...$(NC)"
	@cp $(ENV_FILE) .env 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) up

##@ Service Management

.PHONY: backend
backend: ## ⚡ Start only backend service (with PostgreSQL)
	@echo "$(BLUE)⚡ Starting Backend + PostgreSQL...$(NC)"
	@cp $(ENV_FILE) .env 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) up postgres backend --build

.PHONY: frontend
frontend: ## ⚛️ Start only frontend service
	@echo "$(BLUE)⚛️ Starting Frontend...$(NC)"
	@cp $(ENV_FILE) .env 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) up frontend --build

.PHONY: db
db: ## 🗄️ Start only PostgreSQL database
	@echo "$(BLUE)🗄️ Starting PostgreSQL database...$(NC)"
	@cp $(ENV_FILE) .env 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) up postgres

##@ Build & Maintenance

.PHONY: build
build: ## 🔨 Build all Docker images
	@echo "$(YELLOW)🔨 Building all Docker images...$(NC)"
	@cp $(ENV_FILE) .env 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) build

.PHONY: rebuild
rebuild: ## 🔨 Rebuild all images from scratch (no cache)
	@echo "$(YELLOW)🔨 Rebuilding all Docker images (no cache)...$(NC)"
	@cp $(ENV_FILE) .env 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) build --no-cache

##@ Monitoring & Debugging

.PHONY: logs
logs: ## 📊 Show logs from all services
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f

.PHONY: logs-backend
logs-backend: ## 📊 Show logs from backend service
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f backend

.PHONY: logs-frontend
logs-frontend: ## 📊 Show logs from frontend service
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f frontend

.PHONY: logs-db
logs-db: ## 📊 Show logs from database service
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) logs -f postgres

.PHONY: status
status: ## 📊 Show status of all services
	@echo "$(BLUE)📊 StockFlow Services Status:$(NC)"
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) ps

##@ Database Operations

.PHONY: db-shell
db-shell: ## 🗄️ Connect to PostgreSQL shell
	@echo "$(BLUE)🗄️ Connecting to PostgreSQL shell...$(NC)"
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) exec postgres psql -U stockflow_user -d stockflow_db

.PHONY: db-reset
db-reset: ## ⚠️ Reset database (DANGER: Deletes all data)
	@echo "$(RED)⚠️ This will delete ALL database data. Are you sure? (y/N)$(NC)"
	@read -r REPLY; \
	if [ "$$REPLY" = "y" ] || [ "$$REPLY" = "Y" ]; then \
		echo "$(RED)🗑️ Resetting database...$(NC)"; \
		docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) down -v; \
		docker volume rm stockflow_postgres_data 2>/dev/null || true; \
		echo "$(GREEN)✅ Database reset complete!$(NC)"; \
	else \
		echo "$(BLUE)ℹ️ Database reset cancelled.$(NC)"; \
	fi

##@ Container Management  

.PHONY: shell-backend
shell-backend: ## 💻 Access backend container shell
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) exec backend sh

.PHONY: shell-frontend
shell-frontend: ## 💻 Access frontend container shell
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) exec frontend sh

.PHONY: restart
restart: ## 🔄 Restart all services
	@echo "$(YELLOW)🔄 Restarting all services...$(NC)"
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) restart

##@ Cleanup Commands

.PHONY: stop
stop: ## 🛑 Stop all services
	@echo "$(YELLOW)🛑 Stopping all services...$(NC)"
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) stop

.PHONY: down
down: ## ⬇️ Stop and remove containers
	@echo "$(YELLOW)⬇️ Stopping and removing containers...$(NC)"
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) down

.PHONY: clean
clean: ## 🧹 Stop containers, remove volumes and networks
	@echo "$(YELLOW)🧹 Cleaning up containers, volumes and networks...$(NC)"
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) down -v --remove-orphans

.PHONY: clean-images
clean-images: ## 🧹 Remove all StockFlow Docker images
	@echo "$(YELLOW)🧹 Removing StockFlow Docker images...$(NC)"
	docker images | grep stockflow | awk '{print $$3}' | xargs -r docker rmi -f

.PHONY: clean-all
clean-all: clean clean-images ## 🧹 Full cleanup (containers, volumes, networks, images)
	@echo "$(GREEN)✅ Full cleanup complete!$(NC)"

##@ Testing & Quality

.PHONY: test
test: ## 🧪 Run all tests
	@echo "$(BLUE)🧪 Running tests...$(NC)"
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) exec backend npm test

.PHONY: test-backend
test-backend: ## 🧪 Run backend tests
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) exec backend npm test

.PHONY: test-frontend
test-frontend: ## 🧪 Run frontend tests
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) exec frontend npm test

.PHONY: lint
lint: ## 🔍 Run linting on all projects
	@echo "$(BLUE)🔍 Running linting...$(NC)"
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) exec backend npm run lint
	docker-compose -f $(COMPOSE_FILE) -f $(DEV_COMPOSE_FILE) --env-file $(ENV_FILE) exec frontend npm run lint

##@ Information

.PHONY: env
env: ## 📋 Show environment configuration
	@echo "$(BLUE)📋 Environment Configuration:$(NC)"
	@echo "ENV_FILE: $(ENV_FILE)"
	@echo "COMPOSE_FILE: $(COMPOSE_FILE)"
	@echo "DEV_COMPOSE_FILE: $(DEV_COMPOSE_FILE)"
	@echo ""
	@if [ -f $(ENV_FILE) ]; then \
		echo "$(GREEN)✅ Environment file exists$(NC)"; \
		cat $(ENV_FILE); \
	else \
		echo "$(RED)❌ Environment file not found$(NC)"; \
		echo "Run: cp $(ENV_FILE).example $(ENV_FILE)"; \
	fi

.PHONY: urls
urls: ## 🌐 Show service URLs
	@echo "$(BLUE)🌐 StockFlow Service URLs:$(NC)"
	@echo "Frontend:  $(GREEN)http://localhost:3000$(NC)"
	@echo "Backend:   $(GREEN)http://localhost:5000$(NC)"
	@echo "Database:  $(GREEN)localhost:5432$(NC)"
	@echo "Adminer:   $(GREEN)http://localhost:8080$(NC)"

.PHONY: help
help: ## ❓ Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "$(BLUE)🐳 StockFlow Docker Commands$(NC)\n\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2 } /^##@/ { printf "\n$(YELLOW)%s$(NC)\n", substr($$0, 5) } ' $(MAKEFILE_LIST)