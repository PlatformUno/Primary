#!/bin/bash

# Deployment Script
# Supports multiple environments and deployment strategies

set -e

# Default values
ENVIRONMENT=""
VERSION=""
STRATEGY="rolling"
DRY_RUN=false

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help function
show_help() {
    cat << EOF
Usage: ./deploy.sh [OPTIONS]

Deploy application to specified environment

OPTIONS:
    -e, --environment    Target environment (development|staging|production)
    -v, --version        Version to deploy (e.g., v1.0.0)
    -s, --strategy       Deployment strategy (rolling|blue-green|canary)
    -d, --dry-run        Run in dry-run mode (no actual deployment)
    -h, --help           Show this help message

EXAMPLES:
    ./deploy.sh -e development -v v1.0.0
    ./deploy.sh -e production -v v1.0.0 -s blue-green
    ./deploy.sh -e staging -v v1.0.0 -d

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--environment)
            ENVIRONMENT="$2"
            shift 2
            ;;
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -s|--strategy)
            STRATEGY="$2"
            shift 2
            ;;
        -d|--dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Validate required arguments
if [ -z "$ENVIRONMENT" ]; then
    echo -e "${RED}Error: Environment is required${NC}"
    show_help
    exit 1
fi

if [ -z "$VERSION" ]; then
    echo -e "${RED}Error: Version is required${NC}"
    show_help
    exit 1
fi

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(development|staging|production)$ ]]; then
    echo -e "${RED}Error: Invalid environment. Must be development, staging, or production${NC}"
    exit 1
fi

# Validate strategy
if [[ ! "$STRATEGY" =~ ^(rolling|blue-green|canary)$ ]]; then
    echo -e "${RED}Error: Invalid strategy. Must be rolling, blue-green, or canary${NC}"
    exit 1
fi

echo "================================"
echo "Deployment Configuration"
echo "================================"
echo "Environment: $ENVIRONMENT"
echo "Version: $VERSION"
echo "Strategy: $STRATEGY"
echo "Dry Run: $DRY_RUN"
echo "================================"
echo ""

# Confirmation for production
if [ "$ENVIRONMENT" = "production" ] && [ "$DRY_RUN" = false ]; then
    echo -e "${YELLOW}⚠️  You are about to deploy to PRODUCTION${NC}"
    read -p "Are you sure you want to continue? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Deployment cancelled"
        exit 0
    fi
fi

# Pre-deployment checks
echo "Running pre-deployment checks..."

# Check if version exists (git tag)
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo -e "${GREEN}✓${NC} Version $VERSION exists"
else
    echo -e "${RED}✗${NC} Version $VERSION does not exist"
    exit 1
fi

# Check if there are uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${YELLOW}⚠️  Warning: There are uncommitted changes${NC}"
fi

echo -e "${GREEN}✓${NC} Pre-deployment checks passed"
echo ""

# Deployment function
deploy() {
    local env=$1
    local version=$2
    local strategy=$3
    
    echo "Starting deployment..."
    
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN] Would deploy $version to $env using $strategy strategy${NC}"
        return 0
    fi
    
    case $strategy in
        rolling)
            deploy_rolling "$env" "$version"
            ;;
        blue-green)
            deploy_blue_green "$env" "$version"
            ;;
        canary)
            deploy_canary "$env" "$version"
            ;;
    esac
}

# Rolling deployment
deploy_rolling() {
    local env=$1
    local version=$2
    
    echo "Executing rolling deployment..."
    # Add your rolling deployment commands here
    # Example:
    # kubectl set image deployment/app app=image:$version
    # kubectl rollout status deployment/app
    
    echo -e "${GREEN}✓${NC} Rolling deployment completed"
}

# Blue-green deployment
deploy_blue_green() {
    local env=$1
    local version=$2
    
    echo "Executing blue-green deployment..."
    # Add your blue-green deployment commands here
    # 1. Deploy to blue environment
    # 2. Test blue environment
    # 3. Switch traffic to blue
    # 4. Decommission green
    
    echo -e "${GREEN}✓${NC} Blue-green deployment completed"
}

# Canary deployment
deploy_canary() {
    local env=$1
    local version=$2
    
    echo "Executing canary deployment..."
    # Add your canary deployment commands here
    # 1. Deploy canary version (small percentage)
    # 2. Monitor metrics
    # 3. Gradually increase traffic
    # 4. Full rollout
    
    echo -e "${GREEN}✓${NC} Canary deployment completed"
}

# Health check function
health_check() {
    local env=$1
    local max_attempts=30
    local attempt=0
    
    echo "Running health checks..."
    
    while [ $attempt -lt $max_attempts ]; do
        # Add your health check logic here
        # Example:
        # if curl -f http://$env.example.com/health; then
        #     echo -e "${GREEN}✓${NC} Health check passed"
        #     return 0
        # fi
        
        attempt=$((attempt + 1))
        echo "Health check attempt $attempt/$max_attempts..."
        sleep 10
    done
    
    echo -e "${RED}✗${NC} Health check failed"
    return 1
}

# Execute deployment
deploy "$ENVIRONMENT" "$VERSION" "$STRATEGY"

# Run health checks
if [ "$DRY_RUN" = false ]; then
    if health_check "$ENVIRONMENT"; then
        echo ""
        echo "================================"
        echo -e "${GREEN}Deployment Successful!${NC}"
        echo "================================"
        echo "Environment: $ENVIRONMENT"
        echo "Version: $VERSION"
        echo "Strategy: $STRATEGY"
        echo "================================"
    else
        echo ""
        echo "================================"
        echo -e "${RED}Deployment Failed!${NC}"
        echo "================================"
        echo "Consider rolling back to previous version"
        exit 1
    fi
else
    echo ""
    echo "================================"
    echo -e "${YELLOW}Dry Run Completed${NC}"
    echo "================================"
    echo "No actual deployment was performed"
fi
