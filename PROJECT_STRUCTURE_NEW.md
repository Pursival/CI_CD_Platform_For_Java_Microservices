# 📁 Проектна Структура (Нова)

Това е актуализираната структура на проекта според изискванията.

```
CI_CD_Platform_For_Java_Microservices/
│
├── jenkins/                                    # Jenkins CI/CD конфигурация
│   ├── Jenkinsfile                            # Pipeline definition
│   ├── docker-compose.yml                     # Jenkins + Registry + SonarQube
│   ├── registry/                              # Docker Registry config
│   │   └── config.yml                         # Registry configuration
│   └── README.md                              # Jenkins setup guide
│
├── k8s/                                       # Kubernetes манифести
│   ├── auth-service/
│   │   ├── deployment.yaml                    # Auth deployment (2 replicas)
│   │   ├── service.yaml                       # Auth service (NodePort 30081)
│   │   └── ingress.yaml                       # Auth ingress
│   │
│   ├── payment-service/
│   │   ├── deployment.yaml                    # Payment deployment (2 replicas)
│   │   ├── service.yaml                       # Payment service (NodePort 30082)
│   │   └── ingress.yaml                       # Payment ingress
│   │
│   └── balance-service/
│       ├── deployment.yaml                    # Balance deployment (2 replicas)
│       ├── service.yaml                       # Balance service (NodePort 30083)
│       └── ingress.yaml                       # Balance ingress
│
├── services/                                  # Микросървиси
│   ├── auth-service/                          # Authentication Service
│   │   ├── src/
│   │   │   ├── main/java/com/example/auth/
│   │   │   │   └── AuthServiceApplication.java    # Main + Controller
│   │   │   └── main/resources/
│   │   │       └── application.yml                 # Spring config (port 8081)
│   │   ├── src/test/java/com/example/auth/
│   │   │   └── AuthServiceTests.java              # JUnit tests
│   │   ├── pom.xml                                # Maven dependencies
│   │   └── Dockerfile                             # Multi-stage Docker build
│   │
│   ├── payment-service/                       # Payment Processing Service
│   │   ├── src/
│   │   │   ├── main/java/com/example/payment/
│   │   │   │   └── PaymentServiceApplication.java # Main + Controller
│   │   │   └── main/resources/
│   │   │       └── application.yml                 # Spring config (port 8082)
│   │   ├── src/test/java/com/example/payment/
│   │   │   └── PaymentServiceTests.java           # JUnit tests
│   │   ├── pom.xml                                # Maven dependencies
│   │   └── Dockerfile                             # Multi-stage Docker build
│   │
│   └── balance-service/                       # Balance Management Service
│       ├── src/
│       │   ├── main/java/com/example/balance/
│       │   │   └── BalanceServiceApplication.java # Main + Controller
│       │   └── main/resources/
│       │       └── application.yml                 # Spring config (port 8083)
│       ├── src/test/java/com/example/balance/
│       │   └── BalanceServiceTests.java           # JUnit tests
│       ├── pom.xml                                # Maven dependencies
│       └── Dockerfile                             # Multi-stage Docker build
│
├── README.md                                  # Главна документация
├── QUICK_START.md                             # Бърз старт гид
├── LICENSE                                    # MIT License
└── .gitignore                                 # Git ignore правила
```

## 📊 Статистика

### Services
- **Брой**: 3
- **Package**: `com.example.*`
- **Ports**: 8081, 8082, 8083
- **NodePorts**: 30081, 30082, 30083

### Kubernetes Resources
- **Deployments**: 3 (2 replicas всеки = 6 pods)
- **Services**: 3 (NodePort)
- **Ingress**: 3

### CI/CD
- **Jenkins**: localhost:8080
- **Docker Registry**: localhost:5000
- **Registry UI**: localhost:8081
- **SonarQube**: localhost:9000 (optional)

## 🎯 Ключови Директории

### `/jenkins`
Съдържа всички CI/CD конфигурации:
- Jenkinsfile за pipeline
- docker-compose.yml за локална инфраструктура
- Registry конфигурация

### `/k8s`
Kubernetes манифести за всеки service:
- **deployment.yaml** - Pod template, replicas, resources
- **service.yaml** - NodePort service за external access
- **ingress.yaml** - HTTP routing

### `/services`
Java Spring Boot микросървиси:
- **Simple structure** - Application + Controller в един файл
- **REST endpoints** - /health endpoint за всеки service
- **JUnit tests** - Unit tests за всеки service
- **Dockerfile** - Multi-stage build с OpenJDK 17 и Maven

## 🔄 Pipeline Flow

```
Git Repository
    ↓
Jenkins (Checkout)
    ↓
Maven Build (mvn clean package)
    ↓
JUnit Tests
    ↓
Docker Build
    ↓
Push to localhost:5000
    ↓
kubectl apply -f k8s/
    ↓
Minikube Cluster (6 pods running)
```

## 📝 Naming Conventions

### Java Packages
- Format: `com.example.<service-name>`
- Example: `com.example.auth`, `com.example.payment`

### Docker Images
- Format: `localhost:5000/<service-name>:latest`
- Example: `localhost:5000/auth-service:latest`

### Kubernetes Resources
- Format: `<service-name>`
- Example: `auth-service`, `payment-service`

## 🚀 Deployment

### Jenkins Pipeline Parameters
- **SERVICE**: `all` | `auth-service` | `payment-service` | `balance-service`
- **SKIP_TESTS**: Skip unit tests for faster builds
- **DEPLOY_TO_K8S**: Deploy to Kubernetes after build

### Manual Deployment
```bash
# Build
cd services/auth-service
mvn clean package
docker build -t localhost:5000/auth-service:latest .
docker push localhost:5000/auth-service:latest

# Deploy
kubectl apply -f k8s/auth-service/
```

## 📦 Components

| Component | Location | Purpose |
|-----------|----------|---------|
| Jenkins Pipeline | `jenkins/Jenkinsfile` | CI/CD automation |
| Docker Compose | `jenkins/docker-compose.yml` | Local infrastructure |
| K8s Manifests | `k8s/<service>/` | Kubernetes configs |
| Auth Service | `services/auth-service/` | Authentication API |
| Payment Service | `services/payment-service/` | Payment API |
| Balance Service | `services/balance-service/` | Balance API |

## 🔗 Service Communication

Services communicate via Kubernetes internal DNS:
- `http://auth-service:8081`
- `http://payment-service:8082`
- `http://balance-service:8083`

External access via NodePort:
- `http://$(minikube ip):30081`
- `http://$(minikube ip):30082`
- `http://$(minikube ip):30083`

---

**За пълна документация вижте [README.md](README.md)**

**За бърз старт вижте [QUICK_START.md](QUICK_START.md)**

