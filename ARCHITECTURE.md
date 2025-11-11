# 🏗️ Архитектура на CI/CD платформата

## Преглед

Тази платформа демонстрира пълен CI/CD цикъл за Java микросървиси, използвайки само безплатни и локални технологии.

## Компоненти

### 1. Микросървиси (Spring Boot)

#### Auth Service
- **Port**: 8081 (Kubernetes NodePort: 30081)
- **Отговорности**:
  - Управление на потребителска автентикация
  - Генериране и валидиране на токени
  - Logout функционалност
- **Endpoints**:
  - `GET /api/auth/health` - Health check
  - `POST /api/auth/login` - Вход в системата
  - `POST /api/auth/validate` - Валидация на токен
  - `POST /api/auth/logout` - Изход от системата
- **Технологии**: Spring Boot 3.1.5, Java 17

#### Payment Service
- **Port**: 8082 (Kubernetes NodePort: 30082)
- **Отговорности**:
  - Обработка на плащания
  - История на транзакции
  - Интеграция с Balance Service (планирана)
- **Endpoints**:
  - `GET /api/payment/health` - Health check
  - `POST /api/payment/process` - Обработка на плащане
  - `GET /api/payment/history/{userId}` - История на плащания
  - `GET /api/payment/{paymentId}` - Детайли за плащане
- **Технологии**: Spring Boot 3.1.5, Java 17, WebFlux (за REST calls)

#### Balance Service
- **Port**: 8083 (Kubernetes NodePort: 30083)
- **Отговорности**:
  - Управление на потребителски баланси
  - Актуализация на салда
  - Създаване на нови баланси
- **Endpoints**:
  - `GET /api/balance/health` - Health check
  - `GET /api/balance/{userId}` - Получаване на баланс
  - `POST /api/balance/create` - Създаване на баланс
  - `POST /api/balance/update` - Актуализация на баланс
  - `GET /api/balance/all` - Всички баланси
- **Технологии**: Spring Boot 3.1.5, Java 17

### 2. CI/CD Pipeline (Jenkins)

```
┌─────────────────────────────────────────────────────────┐
│                    Jenkins Pipeline                      │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  Stage 1: Checkout                                       │
│  └─ Clone repository from Git                           │
│                                                          │
│  Stage 2: Build (Parallel per service)                  │
│  ├─ Auth Service: mvn clean package                     │
│  ├─ Payment Service: mvn clean package                  │
│  └─ Balance Service: mvn clean package                  │
│                                                          │
│  Stage 3: Test (Parallel per service)                   │
│  ├─ Auth Service: mvn test                              │
│  ├─ Payment Service: mvn test                           │
│  └─ Balance Service: mvn test                           │
│                                                          │
│  Stage 4: Docker Build (Parallel per service)           │
│  ├─ Build auth-service:latest                           │
│  ├─ Build payment-service:latest                        │
│  └─ Build balance-service:latest                        │
│                                                          │
│  Stage 5: Push to Registry (Parallel per service)       │
│  ├─ Push localhost:5000/auth-service:latest             │
│  ├─ Push localhost:5000/payment-service:latest          │
│  └─ Push localhost:5000/balance-service:latest          │
│                                                          │
│  Stage 6: Deploy to Kubernetes                          │
│  ├─ Apply Deployments                                   │
│  ├─ Apply Services                                      │
│  ├─ Apply Ingress                                       │
│  └─ Wait for rollout completion                         │
│                                                          │
│  Stage 7: Verify Deployment                             │
│  └─ Check pods, services, deployments status            │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

**Характеристики**:
- Параметризиран pipeline (избор на service за build)
- Паралелно изпълнение на builds и тестове
- Automatic rollout и health checks
- Rollback при грешка

### 3. Контейнеризация (Docker)

#### Multi-stage Dockerfile
Всички микросървиси използват multi-stage build за оптимизация:

```dockerfile
# Stage 1: Build
FROM maven:3.9.5-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 808X
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Предимства**:
- Малък размер на финалния image (Alpine Linux)
- Cached dependencies за по-бързи builds
- Separation of concerns (build vs runtime)

#### Docker Compose Setup

```yaml
services:
  jenkins:        # CI/CD Server
  registry:       # Docker Registry
  registry-ui:    # Registry Web UI
  sonarqube:      # Code Quality (optional)
  postgres:       # DB for SonarQube
```

### 4. Оркестрация (Kubernetes/Minikube)

#### Deployment Strategy

```yaml
Deployment:
  replicas: 2
  strategy: RollingUpdate
  livenessProbe: /api/{service}/health
  readinessProbe: /api/{service}/health
  resources:
    requests: {memory: 256Mi, cpu: 250m}
    limits: {memory: 512Mi, cpu: 500m}
```

#### Service Types

1. **ClusterIP** (вътрешна комуникация):
   - auth-service:8081
   - payment-service:8082
   - balance-service:8083

2. **NodePort** (външен достъп):
   - auth-service-nodeport:30081
   - payment-service-nodeport:30082
   - balance-service-nodeport:30083

3. **Ingress** (HTTP routing):
   - /auth → auth-service
   - /payment → payment-service
   - /balance → balance-service

## Data Flow

### 1. CI/CD Flow

```
Developer
    ↓ (git push)
Jenkins
    ↓ (mvn build)
JAR file
    ↓ (docker build)
Docker Image
    ↓ (docker push)
Local Registry (localhost:5000)
    ↓ (kubectl apply)
Kubernetes Deployment
    ↓ (pull image)
Running Pods
```

### 2. Request Flow (Runtime)

```
External User
    ↓
NodePort Service (30081-30083)
    ↓
ClusterIP Service
    ↓
Pod (Replica 1 or 2)
    ↓
Spring Boot Application
    ↓
Response
```

### 3. Inter-service Communication

```
Payment Service
    ↓ (HTTP REST)
Balance Service
    ↓ (get/update balance)
Response
```

## Network Architecture

```
┌─────────────────────────────────────────────────┐
│ Host Machine                                     │
│                                                  │
│  Docker Network (bridge)                         │
│  ├─ Jenkins (8080)                               │
│  ├─ Registry (5000)                              │
│  ├─ Registry UI (8081)                           │
│  └─ SonarQube (9000)                             │
│                                                  │
│  Minikube Cluster                                │
│  ├─ Default Namespace                            │
│  │  ├─ auth-service pods (x2)                    │
│  │  ├─ payment-service pods (x2)                 │
│  │  ├─ balance-service pods (x2)                 │
│  │  ├─ Services (ClusterIP)                      │
│  │  ├─ Services (NodePort)                       │
│  │  └─ Ingress                                   │
│  │                                                │
│  └─ kube-system Namespace                        │
│     ├─ ingress-nginx                             │
│     └─ other system pods                         │
│                                                  │
└─────────────────────────────────────────────────┘
```

## Security Considerations

### Current Implementation (Demo)
- In-memory storage (не за production)
- Няма TLS/SSL encryption
- Basic token-based auth (UUID tokens)
- No password hashing
- Insecure registry configuration

### Production Recommendations
- Използвайте persistent database (PostgreSQL/MySQL)
- Имплементирайте JWT tokens
- Добавете TLS certificates
- Използвайте Kubernetes Secrets
- Имплементирайте RBAC
- Добавете API Gateway с rate limiting
- Използвайте secure registry с credentials
- Имплементирайте network policies
- Добавете secrets management (Vault)

## Scalability

### Horizontal Scaling
```bash
# Scale up
kubectl scale deployment auth-service --replicas=5

# Scale down
kubectl scale deployment auth-service --replicas=1
```

### Auto-scaling (Planned)
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: auth-service-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: auth-service
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## Monitoring & Observability (Planned)

### Metrics
- Prometheus for metrics collection
- Grafana for visualization
- Spring Boot Actuator endpoints

### Logging
- Centralized logging with ELK Stack
  - Elasticsearch
  - Logstash
  - Kibana
- Fluentd for log aggregation

### Tracing
- Jaeger for distributed tracing
- Spring Cloud Sleuth for trace IDs

## High Availability

### Current Setup
- 2 replicas per service
- Rolling updates with zero downtime
- Liveness and readiness probes
- Automatic pod restart on failure

### Production Improvements
- Multi-zone deployment
- External load balancer
- Database replication
- Redis for session management
- Circuit breaker pattern (Resilience4j)
- Service mesh (Istio/Linkerd)

## Build Optimization

### Maven
- Dependency caching
- Multi-module builds
- Parallel builds with `-T` flag

### Docker
- Multi-stage builds
- Layer caching
- .dockerignore for faster context

### Kubernetes
- Resource limits and requests
- Pod disruption budgets
- Node affinity rules

## Technology Stack Summary

| Layer | Technology | Version | Purpose |
|-------|-----------|---------|---------|
| Application | Spring Boot | 3.1.5 | Microservices framework |
| Language | Java | 17 | Programming language |
| Build Tool | Maven | 3.9+ | Dependency & build management |
| Testing | JUnit | 5 | Unit testing |
| Containerization | Docker | 20.10+ | Container runtime |
| CI/CD | Jenkins | LTS | Automation server |
| Registry | Docker Registry | 2 | Image storage |
| Orchestration | Kubernetes | 1.27+ | Container orchestration |
| Local K8s | Minikube | 1.30+ | Local Kubernetes cluster |
| Code Quality | SonarQube | Community | Static analysis (optional) |

## Future Enhancements

1. **Service Mesh**: Istio for advanced traffic management
2. **API Gateway**: Spring Cloud Gateway
3. **Config Server**: Spring Cloud Config
4. **Service Discovery**: Eureka or Consul
5. **Message Broker**: RabbitMQ or Kafka
6. **Database**: PostgreSQL with replication
7. **Caching**: Redis
8. **Monitoring**: Prometheus + Grafana
9. **Logging**: ELK Stack
10. **Tracing**: Jaeger
11. **Security**: OAuth2/OIDC with Keycloak
12. **GitOps**: ArgoCD or Flux

## References

- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)
- [Kubernetes Best Practices](https://kubernetes.io/docs/concepts/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Microservices Patterns](https://microservices.io/patterns/)

