# Microservice Template

A template for creating new microservices that follow our architecture patterns.

## Structure

```
microservice-template/
├── src/
│   ├── domain/          # Business logic
│   ├── application/     # Use cases
│   ├── infrastructure/  # External integrations
│   └── presentation/    # API controllers
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── Dockerfile
├── package.json
└── README.md
```

## Features

- Clean Architecture implementation
- Domain-Driven Design patterns
- Health check endpoints
- Metrics and monitoring
- Structured logging
- Environment configuration
- Comprehensive testing

## Quick Start

```bash
# Copy template
cp -r examples/microservice-template my-new-service
cd my-new-service

# Install dependencies
npm install

# Configure environment
cp .env.example .env

# Run in development
npm run dev

# Run tests
npm test

# Build for production
npm run build
```

## Endpoints

- `GET /health` - Health check
- `GET /ready` - Readiness check
- `GET /metrics` - Prometheus metrics
- `GET /api/v1/*` - API endpoints

## Configuration

Edit `.env` file with your service-specific configuration:

```env
SERVICE_NAME=my-service
PORT=3000
LOG_LEVEL=info
DATABASE_URL=postgresql://...
```

## Testing

```bash
# Unit tests
npm run test:unit

# Integration tests
npm run test:integration

# E2E tests
npm run test:e2e

# All tests with coverage
npm run test:coverage
```

## Deployment

```bash
# Build Docker image
docker build -t my-service:v1.0.0 .

# Run container
docker run -p 3000:3000 my-service:v1.0.0

# Deploy using deployment script
../../scripts/deploy.sh -e production -v v1.0.0
```

## Best Practices

- Keep domain logic pure and testable
- Use dependency injection
- Write tests first (TDD)
- Document API with OpenAPI/Swagger
- Monitor all external calls
- Handle errors gracefully
- Log structured data
