# API Gateway Example

An example API Gateway implementation for routing and managing microservices.

## Features

- Request routing to microservices
- Authentication and authorization
- Rate limiting
- Request/response transformation
- Caching
- Monitoring and metrics
- Circuit breaker pattern

## Configuration

```yaml
# gateway-config.yml
gateway:
  port: 8080
  cors:
    enabled: true
    origins: ["*"]
  
  routes:
    - path: /api/users/*
      service: user-service
      url: http://user-service:3000
      methods: [GET, POST, PUT, DELETE]
      auth: required
      rate_limit: 100
      
    - path: /api/orders/*
      service: order-service
      url: http://order-service:3001
      methods: [GET, POST, PUT, DELETE]
      auth: required
      rate_limit: 50
      
    - path: /api/public/*
      service: public-service
      url: http://public-service:3002
      methods: [GET]
      auth: optional
      rate_limit: 1000

  auth:
    jwt:
      secret: ${JWT_SECRET}
      expiration: 1h
      
  rate_limiting:
    strategy: sliding_window
    default_limit: 100
    window: 60s
    
  circuit_breaker:
    failure_threshold: 5
    timeout: 30s
    reset_timeout: 60s
```

## Usage

### Start Gateway

```bash
# Development
npm run dev

# Production
npm start
```

### Example Requests

```bash
# Public endpoint (no auth)
curl http://localhost:8080/api/public/status

# Authenticated endpoint
curl -H "Authorization: Bearer $TOKEN" \
     http://localhost:8080/api/users/123

# POST request
curl -X POST \
     -H "Authorization: Bearer $TOKEN" \
     -H "Content-Type: application/json" \
     -d '{"name":"John Doe"}' \
     http://localhost:8080/api/users
```

## Middleware

### Authentication

```javascript
const authMiddleware = async (req, res, next) => {
  try {
    const token = req.headers.authorization?.split(' ')[1];
    if (!token) {
      return res.status(401).json({ error: 'No token provided' });
    }
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({ error: 'Invalid token' });
  }
};
```

### Rate Limiting

```javascript
const rateLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 minute
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests, please try again later.'
});
```

### Circuit Breaker

```javascript
const circuitBreaker = new CircuitBreaker(async (url, options) => {
  return await fetch(url, options);
}, {
  timeout: 3000,
  errorThresholdPercentage: 50,
  resetTimeout: 30000
});
```

## Monitoring

The gateway exposes metrics at `/metrics`:

- Request count by route and status
- Request duration
- Active connections
- Circuit breaker state
- Rate limit violations

## Deployment

```bash
# Build Docker image
docker build -t api-gateway:v1.0.0 .

# Deploy
kubectl apply -f k8s/gateway-deployment.yml
```

## Best Practices

- Use JWT for authentication
- Implement rate limiting per client
- Enable circuit breakers for resilience
- Cache responses where appropriate
- Log all requests for audit
- Monitor gateway health
- Version your API routes
