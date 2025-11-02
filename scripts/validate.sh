#!/bin/bash

# Validation Script
# Validates the foundation setup and documentation

# Don't exit on error, we want to collect all failures
set +e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "================================"
echo "Primary Foundation Validation"
echo "================================"
echo ""

# Track validation results
PASS=0
FAIL=0
WARN=0

# Helper functions
pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASS++))
}

fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAIL++))
}

warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARN++))
}

# Check documentation files
echo "Checking documentation..."
for file in README.md GETTING_STARTED.md ARCHITECTURE.md DEVELOPMENT.md DEPLOYMENT.md ROADMAP.md; do
    if [ -f "$file" ]; then
        pass "$file exists"
    else
        fail "$file is missing"
    fi
done
echo ""

# Check docs directory
echo "Checking specialized documentation..."
for file in docs/DESIGN_PRINCIPLES.md docs/MIGRATION_GUIDE.md docs/VALUE_METRICS.md docs/OVERVIEW.md; do
    if [ -f "$file" ]; then
        pass "$file exists"
    else
        fail "$file is missing"
    fi
done
echo ""

# Check templates
echo "Checking templates..."
for file in templates/Dockerfile templates/docker-compose.yml templates/Makefile templates/.env.example; do
    if [ -f "$file" ]; then
        pass "$file exists"
    else
        fail "$file is missing"
    fi
done
echo ""

# Check scripts
echo "Checking scripts..."
for file in scripts/setup-dev.sh scripts/deploy.sh; do
    if [ -f "$file" ]; then
        if [ -x "$file" ]; then
            pass "$file exists and is executable"
        else
            warn "$file exists but is not executable"
        fi
    else
        fail "$file is missing"
    fi
done
echo ""

# Check CI/CD
echo "Checking CI/CD configuration..."
if [ -f ".github/workflows/ci-cd.yml" ]; then
    pass "CI/CD workflow exists"
else
    fail "CI/CD workflow is missing"
fi
echo ""

# Check examples
echo "Checking examples..."
if [ -d "examples/microservice-template" ]; then
    pass "Microservice template exists"
else
    fail "Microservice template is missing"
fi

if [ -d "examples/api-gateway" ]; then
    pass "API gateway example exists"
else
    fail "API gateway example is missing"
fi

if [ -d "examples/infrastructure" ]; then
    pass "Infrastructure example exists"
else
    fail "Infrastructure example is missing"
fi
echo ""

# Check .gitignore
echo "Checking configuration..."
if [ -f ".gitignore" ]; then
    pass ".gitignore exists"
else
    fail ".gitignore is missing"
fi
echo ""

# Check directory structure
echo "Checking directory structure..."
for dir in docs examples scripts templates infrastructure; do
    if [ -d "$dir" ]; then
        pass "$dir/ directory exists"
    else
        warn "$dir/ directory is missing (optional)"
    fi
done
echo ""

# Check file content (basic validation)
echo "Checking file content..."

# Check if README has content
if [ -f "README.md" ] && [ $(wc -l < README.md) -gt 50 ]; then
    pass "README.md has substantial content"
else
    warn "README.md may need more content"
fi

# Check if scripts have shebang
if [ -f "scripts/setup-dev.sh" ] && head -1 scripts/setup-dev.sh | grep -q "#!/bin/bash"; then
    pass "setup-dev.sh has proper shebang"
else
    fail "setup-dev.sh missing or has incorrect shebang"
fi

if [ -f "scripts/deploy.sh" ] && head -1 scripts/deploy.sh | grep -q "#!/bin/bash"; then
    pass "deploy.sh has proper shebang"
else
    fail "deploy.sh missing or has incorrect shebang"
fi
echo ""

# Summary
echo "================================"
echo "Validation Summary"
echo "================================"
echo -e "${GREEN}Passed:${NC} $PASS"
echo -e "${YELLOW}Warnings:${NC} $WARN"
echo -e "${RED}Failed:${NC} $FAIL"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All critical validations passed!${NC}"
    echo ""
    echo "Foundation is ready for use! 🚀"
    echo ""
    echo "Next steps:"
    echo "1. Review the documentation"
    echo "2. Run ./scripts/setup-dev.sh"
    echo "3. Start with GETTING_STARTED.md"
    exit 0
else
    echo -e "${RED}✗ Some validations failed.${NC}"
    echo "Please fix the issues above and run validation again."
    exit 1
fi
