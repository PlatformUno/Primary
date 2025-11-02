# Deployment Guide

## Continuous Deployment Strategy

This guide covers the continuous deployment practices for delivering value incrementally and safely.

## Deployment Philosophy

**Principles:**
- Deploy frequently (multiple times per day)
- Automate everything
- Monitor continuously
- Rollback quickly if needed
- Learn from every deployment

## Environments

### Development
- **Purpose**: Testing latest changes
- **Deployment**: Automatic on merge to `develop`
- **Data**: Synthetic test data
- **Monitoring**: Basic health checks

### Staging
- **Purpose**: Pre-production validation
- **Deployment**: Automatic on `release/*` branches
- **Data**: Anonymized production data
- **Monitoring**: Full production-like monitoring

### Production
- **Purpose**: Live user traffic
- **Deployment**: Automatic on merge to `main`
- **Data**: Real user data
- **Monitoring**: Comprehensive monitoring and alerting

## Deployment Strategies

### Blue-Green Deployment

```yaml
# Deploy new version alongside old version
# Switch traffic when new version is verified

stages:
  - name: Deploy Blue (new version)
    steps:
      - deploy_application:
          environment: blue
          version: v2.0.0
  
  - name: Validate Blue
    steps:
      - run_smoke_tests:
          target: blue
      - validate_metrics:
          duration: 5m
  
  - name: Switch Traffic
    steps:
      - route_traffic:
          from: green
          to: blue
          percentage: 100
  
  - name: Decommission Green
    steps:
      - scale_down:
          environment: green
```

**Benefits:**
- Zero downtime deployments
- Quick rollback capability
- Easy testing before switchover

### Canary Deployment

```yaml
# Gradually increase traffic to new version

stages:
  - name: Deploy Canary
    steps:
      - deploy_version:
          version: v2.0.0
          replicas: 1
  
  - name: Route 10% Traffic
    steps:
      - update_routing:
          canary: 10%
          stable: 90%
      - monitor:
          duration: 10m
  
  - name: Route 50% Traffic
    steps:
      - update_routing:
          canary: 50%
          stable: 50%
      - monitor:
          duration: 20m
  
  - name: Route 100% Traffic
    steps:
      - update_routing:
          canary: 100%
          stable: 0%
      - monitor:
          duration: 30m
```

**Benefits:**
- Gradual risk mitigation
- Real user feedback
- Early issue detection

### Rolling Deployment

```yaml
# Update instances one at a time

deployment:
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
```

**Benefits:**
- Resource efficient
- Gradual rollout
- Always available

## Infrastructure as Code

### Terraform Example

```hcl
# infrastructure/main.tf

terraform {
  required_version = ">= 1.0"
  
  backend "s3" {
    bucket = "terraform-state"
    key    = "primary/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "./modules/networking"
  
  vpc_cidr = var.vpc_cidr
  environment = var.environment
}

module "compute" {
  source = "./modules/compute"
  
  vpc_id = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
  environment = var.environment
}

module "database" {
  source = "./modules/database"
  
  vpc_id = module.networking.vpc_id
  subnet_ids = module.networking.database_subnet_ids
  environment = var.environment
}

module "monitoring" {
  source = "./modules/monitoring"
  
  environment = var.environment
  alert_email = var.alert_email
}
```

### Kubernetes Manifests

```yaml
# k8s/deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: primary-app
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: primary
  template:
    metadata:
      labels:
        app: primary
        version: v1.0.0
    spec:
      containers:
      - name: app
        image: ghcr.io/platformuno/primary:v1.0.0
        ports:
        - containerPort: 3000
        env:
        - name: NODE_ENV
          value: "production"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: primary-service
  namespace: production
spec:
  selector:
    app: primary
  ports:
  - port: 80
    targetPort: 3000
  type: LoadBalancer
```

## Deployment Automation

### GitHub Actions Integration

The CI/CD pipeline automatically deploys based on branch:

```
develop → Development Environment
release/* → Staging Environment
main → Production Environment
```

### Manual Deployment

```bash
# Deploy to specific environment
./scripts/deploy.sh --environment production --version v1.0.0

# Deploy with specific strategy
./scripts/deploy.sh --environment production --strategy canary

# Rollback to previous version
./scripts/rollback.sh --environment production --to-version v0.9.5
```

## Database Migrations

```bash
# Run migrations
./scripts/migrate.sh --environment production --action up

# Rollback migration
./scripts/migrate.sh --environment production --action down

# Check migration status
./scripts/migrate.sh --environment production --action status
```

**Migration Best Practices:**
- Always test migrations in staging first
- Make migrations backward compatible
- Plan for zero-downtime migrations
- Have rollback plan ready

## Configuration Management

### Environment Variables

```bash
# Production secrets management
# Use secure secret stores (AWS Secrets Manager, HashiCorp Vault)

# Set secrets
aws secretsmanager create-secret \
  --name primary/production/database \
  --secret-string '{"username":"admin","password":"secret"}'

# Get secrets in application
aws secretsmanager get-secret-value \
  --secret-id primary/production/database
```

### Feature Flags

```yaml
# feature-flags.yml

features:
  new_dashboard:
    enabled: true
    environments:
      production: false
      staging: true
      development: true
    rollout_percentage: 0
    
  advanced_analytics:
    enabled: true
    environments:
      production: true
      staging: true
      development: true
    rollout_percentage: 25
    user_segments:
      - beta_users
      - internal_users
```

## Monitoring and Observability

### Health Checks

```javascript
// health-check.js

app.get('/health', (req, res) => {
  const health = {
    status: 'healthy',
    timestamp: new Date(),
    uptime: process.uptime(),
    checks: {
      database: checkDatabase(),
      cache: checkCache(),
      external_api: checkExternalAPI()
    }
  };
  
  const isHealthy = Object.values(health.checks)
    .every(check => check.status === 'ok');
  
  res.status(isHealthy ? 200 : 503).json(health);
});
```

### Metrics

```javascript
// metrics.js

const prometheus = require('prom-client');

// Request duration
const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

// Request counter
const httpRequestTotal = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Custom business metrics
const ordersProcessed = new prometheus.Counter({
  name: 'orders_processed_total',
  help: 'Total number of orders processed'
});
```

### Logging

```javascript
// logger.js

const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.json(),
  defaultMeta: {
    service: 'primary-app',
    environment: process.env.NODE_ENV
  },
  transports: [
    new winston.transports.Console({
      format: winston.format.simple()
    }),
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error'
    }),
    new winston.transports.File({
      filename: 'logs/combined.log'
    })
  ]
});
```

## Rollback Procedures

### Automatic Rollback

```yaml
# Automatic rollback triggers
rollback_conditions:
  - error_rate > 5%
  - response_time > 2000ms
  - health_check_failures > 3
  - custom_metric_threshold_exceeded
```

### Manual Rollback

```bash
# Rollback using deployment script
./scripts/rollback.sh --environment production

# Rollback using Kubernetes
kubectl rollout undo deployment/primary-app -n production

# Rollback specific revision
kubectl rollout undo deployment/primary-app -n production --to-revision=2

# Check rollout status
kubectl rollout status deployment/primary-app -n production
```

## Post-Deployment

### Verification Checklist

- [ ] Health checks passing
- [ ] Metrics within normal range
- [ ] No error spikes in logs
- [ ] Critical user flows working
- [ ] Performance within SLA
- [ ] Database migrations completed
- [ ] Feature flags configured correctly
- [ ] Monitoring alerts configured
- [ ] Team notified of deployment

### Incident Response

If issues are detected:

1. **Assess Impact**: Check metrics, logs, alerts
2. **Decide**: Fix forward or rollback?
3. **Act**: Execute chosen strategy quickly
4. **Communicate**: Update stakeholders
5. **Verify**: Confirm issue resolved
6. **Document**: Record incident details
7. **Learn**: Conduct post-mortem

## Security Considerations

- Use encrypted secrets management
- Implement network policies
- Enable audit logging
- Regular security scanning
- Principle of least privilege
- Zero-trust networking

## Compliance

- Maintain deployment audit trail
- Document change approvals
- Regular compliance audits
- Data privacy considerations
- Regulatory requirements

## Resources

- [CI/CD Pipeline](.github/workflows/ci-cd.yml)
- [Infrastructure Code](infrastructure/)
- [Deployment Scripts](scripts/)
- [Monitoring Dashboards](docs/monitoring/)
- [Runbooks](docs/runbooks/)
