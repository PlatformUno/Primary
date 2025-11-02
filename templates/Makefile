# Makefile for rapid development automation

.PHONY: help setup install dev build test lint format clean deploy

# Default target
.DEFAULT_GOAL := help

# Variables
PROJECT_NAME := primary
DOCKER_COMPOSE := docker-compose
PYTHON := python3
NODE := npm

## help: Display this help message
help:
	@echo "Available commands:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## setup: Initial project setup
setup:
	@echo "Setting up development environment..."
	@mkdir -p logs tmp data
	@cp .env.example .env 2>/dev/null || echo "No .env.example found"
	@echo "Setup complete! Run 'make install' to install dependencies."

## install: Install all dependencies
install:
	@echo "Installing dependencies..."
	# Add your installation commands here
	# Example for Node.js:
	# $(NODE) install
	# Example for Python:
	# $(PYTHON) -m pip install -r requirements.txt
	@echo "Dependencies installed!"

## dev: Start development environment
dev:
	@echo "Starting development environment..."
	$(DOCKER_COMPOSE) up -d
	@echo "Development environment running!"
	@echo "Application: http://localhost:3000"

## dev-logs: View development logs
dev-logs:
	$(DOCKER_COMPOSE) logs -f

## dev-stop: Stop development environment
dev-stop:
	@echo "Stopping development environment..."
	$(DOCKER_COMPOSE) down

## build: Build the application
build:
	@echo "Building application..."
	# Add your build commands here
	# Example: $(NODE) run build
	@echo "Build complete!"

## test: Run all tests
test:
	@echo "Running tests..."
	# Add your test commands here
	# Example: $(NODE) test
	@echo "Tests complete!"

## test-unit: Run unit tests
test-unit:
	@echo "Running unit tests..."
	# Add unit test commands
	@echo "Unit tests complete!"

## test-integration: Run integration tests
test-integration:
	@echo "Running integration tests..."
	# Add integration test commands
	@echo "Integration tests complete!"

## test-e2e: Run end-to-end tests
test-e2e:
	@echo "Running e2e tests..."
	# Add e2e test commands
	@echo "E2E tests complete!"

## test-watch: Run tests in watch mode
test-watch:
	@echo "Running tests in watch mode..."
	# Example: $(NODE) test -- --watch

## test-coverage: Run tests with coverage
test-coverage:
	@echo "Running tests with coverage..."
	# Example: $(NODE) test -- --coverage
	@echo "Coverage report generated!"

## lint: Run linters
lint:
	@echo "Running linters..."
	# Add linting commands
	# Example: $(NODE) run lint
	@echo "Linting complete!"

## format: Format code
format:
	@echo "Formatting code..."
	# Add formatting commands
	# Example: $(NODE) run format
	@echo "Code formatted!"

## clean: Clean build artifacts and caches
clean:
	@echo "Cleaning up..."
	@rm -rf dist/ build/ coverage/ .cache/
	@rm -rf node_modules/.cache/
	@rm -rf tmp/* logs/*
	@echo "Cleanup complete!"

## docker-build: Build Docker images
docker-build:
	@echo "Building Docker images..."
	$(DOCKER_COMPOSE) build
	@echo "Docker images built!"

## docker-push: Push Docker images
docker-push:
	@echo "Pushing Docker images..."
	# Add docker push commands
	@echo "Docker images pushed!"

## migrate: Run database migrations
migrate:
	@echo "Running database migrations..."
	# Add migration commands
	@echo "Migrations complete!"

## migrate-rollback: Rollback last migration
migrate-rollback:
	@echo "Rolling back migration..."
	# Add rollback commands
	@echo "Migration rolled back!"

## seed: Seed database with test data
seed:
	@echo "Seeding database..."
	# Add seed commands
	@echo "Database seeded!"

## deploy-dev: Deploy to development environment
deploy-dev:
	@echo "Deploying to development..."
	# Add deployment commands
	@echo "Deployed to development!"

## deploy-staging: Deploy to staging environment
deploy-staging:
	@echo "Deploying to staging..."
	# Add deployment commands
	@echo "Deployed to staging!"

## deploy-prod: Deploy to production environment
deploy-prod:
	@echo "Deploying to production..."
	@read -p "Are you sure you want to deploy to production? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "Deploying..."; \
	else \
		echo "Deployment cancelled."; \
	fi

## logs: View application logs
logs:
	@tail -f logs/*.log

## status: Check status of services
status:
	$(DOCKER_COMPOSE) ps

## shell: Open shell in application container
shell:
	$(DOCKER_COMPOSE) exec app sh

## db-shell: Open database shell
db-shell:
	$(DOCKER_COMPOSE) exec db psql -U postgres

## security-scan: Run security scans
security-scan:
	@echo "Running security scans..."
	# Add security scanning commands
	# Example: npm audit
	@echo "Security scan complete!"

## deps-update: Update dependencies
deps-update:
	@echo "Updating dependencies..."
	# Add dependency update commands
	@echo "Dependencies updated!"

## ci: Run CI pipeline locally
ci: lint test build
	@echo "CI pipeline complete!"

## validate: Validate configuration files
validate:
	@echo "Validating configurations..."
	# Add validation commands
	@echo "Validation complete!"
