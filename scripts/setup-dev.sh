#!/bin/bash

# Development Environment Setup Script
# This script sets up the development environment for rapid development

set -e

echo "================================"
echo "Primary Development Setup"
echo "================================"
echo ""

# Check prerequisites
echo "Checking prerequisites..."

# Check for Docker
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi
echo "✓ Docker found"

# Check for Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi
echo "✓ Docker Compose found"

# Check for Git
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install Git first."
    exit 1
fi
echo "✓ Git found"

echo ""
echo "Setting up project structure..."

# Create necessary directories
mkdir -p logs tmp data docs/api monitoring/prometheus monitoring/grafana/{dashboards,datasources}

echo "✓ Directories created"

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    if [ -f templates/.env.example ]; then
        cp templates/.env.example .env
        echo "✓ .env file created from template"
        echo "⚠️  Please update .env with your configuration"
    else
        echo "⚠️  .env.example not found in templates/"
    fi
else
    echo "✓ .env file already exists"
fi

# Copy Makefile if it doesn't exist
if [ ! -f Makefile ]; then
    if [ -f templates/Makefile ]; then
        cp templates/Makefile .
        echo "✓ Makefile copied from templates"
    fi
fi

# Copy docker-compose.yml if it doesn't exist
if [ ! -f docker-compose.yml ]; then
    if [ -f templates/docker-compose.yml ]; then
        cp templates/docker-compose.yml .
        echo "✓ docker-compose.yml copied from templates"
    fi
fi

# Copy Dockerfile if it doesn't exist
if [ ! -f Dockerfile ]; then
    if [ -f templates/Dockerfile ]; then
        cp templates/Dockerfile .
        echo "✓ Dockerfile copied from templates"
    fi
fi

echo ""
echo "Installing git hooks..."

# Set up pre-commit hooks
if [ -d .git ]; then
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for code quality

echo "Running pre-commit checks..."

# Run linting (if make lint is available)
if command -v make &> /dev/null && grep -q "^lint:" Makefile 2>/dev/null; then
    echo "Running linters..."
    make lint || exit 1
fi

echo "✓ Pre-commit checks passed"
EOF

    chmod +x .git/hooks/pre-commit
    echo "✓ Git hooks installed"
else
    echo "⚠️  Not a git repository, skipping git hooks"
fi

echo ""
echo "================================"
echo "Setup Complete!"
echo "================================"
echo ""
echo "Next steps:"
echo "1. Review and update the .env file with your configuration"
echo "2. Run 'make install' to install dependencies"
echo "3. Run 'make dev' to start the development environment"
echo ""
echo "Quick commands:"
echo "  make help       - Show all available commands"
echo "  make dev        - Start development environment"
echo "  make test       - Run tests"
echo "  make lint       - Run linters"
echo ""
echo "Documentation:"
echo "  README.md           - Project overview"
echo "  ARCHITECTURE.md     - System architecture"
echo "  DEVELOPMENT.md      - Development workflow"
echo "  DEPLOYMENT.md       - Deployment guide"
echo ""
echo "Happy coding! 🚀"
