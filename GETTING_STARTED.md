# Getting Started Guide

Welcome! This guide will help you get up and running with the Primary foundation in minutes.

## Overview

Primary is a comprehensive foundation for building modern solutions that address legacy platform challenges through:
- **Radical Design**: Modern architecture patterns
- **Rapid Development**: Fast iteration cycles
- **Continuous Deployment**: Automated delivery
- **Value-Driven**: Focus on outcomes

## Prerequisites

Before you begin, ensure you have:

- ✅ **Docker** (version 20.x or higher)
- ✅ **Docker Compose** (version 2.x or higher)
- ✅ **Git** (version 2.x or higher)
- ✅ **Make** (optional, but recommended)
- ✅ Text editor or IDE of your choice

### Check Prerequisites

```bash
# Check Docker
docker --version
docker-compose --version

# Check Git
git --version

# Check Make (optional)
make --version
```

## Quick Start (5 Minutes)

### 1. Clone the Repository

```bash
git clone https://github.com/PlatformUno/Primary.git
cd Primary
```

### 2. Run Setup

```bash
chmod +x scripts/setup-dev.sh
./scripts/setup-dev.sh
```

This script will:
- Create necessary directories
- Copy configuration templates
- Set up git hooks
- Prepare your environment

### 3. Configure Environment

```bash
# Edit the .env file with your preferences
nano .env
# or
code .env
```

Key settings to review:
- `PROJECT_NAME`: Your project name
- `NODE_ENV`: Set to 'development'
- Database credentials
- API keys (if needed)

### 4. Start Development Environment

```bash
# Using Make
make dev

# Or using Docker Compose directly
docker-compose up -d
```

### 5. Verify Installation

```bash
# Check running containers
docker-compose ps

# View logs
docker-compose logs -f app

# Access services
# - Application: http://localhost:3000
# - Database: localhost:5432
# - Redis: localhost:6379
# - Grafana: http://localhost:3001 (admin/admin)
# - Prometheus: http://localhost:9090
```

## What's Next?

Now that your environment is running, here's what you can do:

### 1. Explore the Documentation

- **[Architecture](ARCHITECTURE.md)**: Understand the system design
- **[Development Guide](DEVELOPMENT.md)**: Learn the development workflow
- **[Deployment Guide](DEPLOYMENT.md)**: Deploy your applications
- **[Design Principles](docs/DESIGN_PRINCIPLES.md)**: Value-driven design approaches

### 2. Try the Examples

```bash
# Explore microservice template
cd examples/microservice-template

# Check API Gateway example
cd examples/api-gateway

# Review infrastructure code
cd examples/infrastructure
```

### 3. Create Your First Service

```bash
# Copy the microservice template
cp -r examples/microservice-template my-first-service
cd my-first-service

# Follow the README
cat README.md
```

### 4. Run Tests

```bash
# Run all tests
make test

# Run specific test types
make test-unit
make test-integration
```

### 5. Make Your First Change

```bash
# Create a feature branch
git checkout -b feature/my-first-feature

# Make your changes
# ... edit files ...

# Run tests
make test

# Commit changes
git add .
git commit -m "feat: add my first feature"

# Push your branch
git push origin feature/my-first-feature
```

## Common Tasks

### Starting and Stopping

```bash
# Start all services
make dev

# View logs
make dev-logs

# Stop all services
make dev-stop

# Restart a service
docker-compose restart app
```

### Development

```bash
# Install dependencies
make install

# Run linters
make lint

# Format code
make format

# Build for production
make build
```

### Database

```bash
# Access database shell
make db-shell

# Run migrations
make migrate

# Seed test data
make seed
```

### Monitoring

```bash
# View application logs
make logs

# Check service status
make status

# Open Grafana dashboard
open http://localhost:3001
```

## Troubleshooting

### Containers won't start

```bash
# Check Docker is running
docker ps

# Clean up and restart
make clean
docker-compose down -v
docker-compose up -d
```

### Port conflicts

If ports 3000, 5432, 6379, etc. are already in use:

1. Edit `.env` file to change ports
2. Edit `docker-compose.yml` port mappings
3. Restart: `docker-compose down && docker-compose up -d`

### Permission errors

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Fix file ownership (if needed)
sudo chown -R $USER:$USER .
```

### Cannot connect to database

```bash
# Check database is running
docker-compose ps db

# View database logs
docker-compose logs db

# Restart database
docker-compose restart db
```

## Getting Help

- 📚 **Documentation**: Check `/docs` folder
- 🔍 **Examples**: Review `/examples` folder
- 🐛 **Issues**: Create an issue on GitHub
- 💬 **Discussion**: Join team discussions
- 📧 **Contact**: Reach out to team leads

## Best Practices for Beginners

### 1. Start Small
- Begin with one microservice
- Add complexity incrementally
- Test frequently

### 2. Follow the Patterns
- Use the templates provided
- Follow the architecture guide
- Review example implementations

### 3. Write Tests
- Test as you code
- Aim for good coverage
- Run tests before committing

### 4. Document Your Work
- Update README files
- Add code comments where needed
- Document API endpoints

### 5. Ask for Help
- Don't struggle alone
- Review existing documentation
- Reach out to the team

## Learning Path

### Week 1: Fundamentals
- ✅ Set up development environment
- ✅ Understand architecture
- ✅ Create a simple service
- ✅ Write basic tests
- ✅ Deploy to development

### Week 2: Intermediate
- 🔲 Implement business logic
- 🔲 Add API endpoints
- 🔲 Integrate with database
- 🔲 Add comprehensive tests
- 🔲 Set up monitoring

### Week 3: Advanced
- 🔲 Implement event-driven patterns
- 🔲 Add caching strategies
- 🔲 Optimize performance
- 🔲 Implement CI/CD
- 🔲 Deploy to production

## Resources

### Documentation
- [Architecture Overview](ARCHITECTURE.md)
- [Development Guide](DEVELOPMENT.md)
- [Deployment Guide](DEPLOYMENT.md)
- [Design Principles](docs/DESIGN_PRINCIPLES.md)

### Examples
- [Microservice Template](examples/microservice-template/)
- [API Gateway](examples/api-gateway/)
- [Infrastructure Code](examples/infrastructure/)

### External Resources
- Docker Documentation: https://docs.docker.com
- Kubernetes Documentation: https://kubernetes.io/docs
- Microservices Patterns: https://microservices.io

## Next Steps

Now that you're set up:

1. ✅ Complete the quick start
2. 📖 Read the architecture documentation
3. 🔨 Build your first service
4. 🧪 Write comprehensive tests
5. 🚀 Deploy to development
6. 📊 Monitor and iterate

## Feedback

We're constantly improving this foundation. If you have:
- 💡 Suggestions for improvement
- 🐛 Bug reports
- 📝 Documentation feedback
- ❓ Questions

Please create an issue or reach out to the team!

---

**Welcome aboard! Let's build something amazing together! 🚀**
