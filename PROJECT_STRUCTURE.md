# 📁 Структура на проекта

```
CI_CD_Platform_For_Java_Microservices/
│
├── microservices/                          # Всички микросървиси
│   │
│   ├── auth-service/                       # Authentication Service
│   │   ├── src/
│   │   │   ├── main/
│   │   │   │   ├── java/com/microservices/auth/
│   │   │   │   │   ├── AuthServiceApplication.java       # Main класс
│   │   │   │   │   ├── controller/
│   │   │   │   │   │   └── AuthController.java           # REST endpoints
│   │   │   │   │   └── model/
│   │   │   │   │       ├── LoginRequest.java             # Login DTO
│   │   │   │   │       └── AuthResponse.java             # Auth DTO
│   │   │   │   └── resources/
│   │   │   │       └── application.yml                    # Spring config
│   │   │   └── test/
│   │   │       └── java/com/microservices/auth/
│   │   │           ├── AuthServiceApplicationTests.java   # Context test
│   │   │           └── controller/
│   │   │               └── AuthControllerTest.java        # Controller tests
│   │   ├── pom.xml                                        # Maven config
│   │   └── Dockerfile                                     # Docker config
│   │
│   ├── payment-service/                    # Payment Processing Service
│   │   ├── src/
│   │   │   ├── main/
│   │   │   │   ├── java/com/microservices/payment/
│   │   │   │   │   ├── PaymentServiceApplication.java    # Main класс
│   │   │   │   │   ├── controller/
│   │   │   │   │   │   └── PaymentController.java        # REST endpoints
│   │   │   │   │   ├── service/
│   │   │   │   │   │   └── PaymentService.java           # Business logic
│   │   │   │   │   └── model/
│   │   │   │   │       ├── Payment.java                  # Payment entity
│   │   │   │   │       └── PaymentRequest.java           # Payment DTO
│   │   │   │   └── resources/
│   │   │   │       └── application.yml                    # Spring config
│   │   │   └── test/
│   │   │       └── java/com/microservices/payment/
│   │   │           ├── PaymentServiceApplicationTests.java
│   │   │           └── controller/
│   │   │               └── PaymentControllerTest.java
│   │   ├── pom.xml
│   │   └── Dockerfile
│   │
│   └── balance-service/                    # Balance Management Service
│       ├── src/
│       │   ├── main/
│       │   │   ├── java/com/microservices/balance/
│       │   │   │   ├── BalanceServiceApplication.java    # Main класс
│       │   │   │   ├── controller/
│       │   │   │   │   └── BalanceController.java        # REST endpoints
│       │   │   │   ├── service/
│       │   │   │   │   └── BalanceService.java           # Business logic
│       │   │   │   └── model/
│       │   │   │       ├── Balance.java                  # Balance entity
│       │   │   │       └── BalanceUpdateRequest.java     # Update DTO
│       │   │   └── resources/
│       │   │       └── application.yml                    # Spring config
│       │   └── test/
│       │       └── java/com/microservices/balance/
│       │           ├── BalanceServiceApplicationTests.java
│       │           └── controller/
│       │               └── BalanceControllerTest.java
│       ├── pom.xml
│       └── Dockerfile
│
├── kubernetes/                             # Kubernetes манифести
│   ├── namespace.yaml                      # Namespace definition
│   ├── auth-service-deployment.yaml        # Auth deployment
│   ├── auth-service-service.yaml           # Auth service
│   ├── payment-service-deployment.yaml     # Payment deployment
│   ├── payment-service-service.yaml        # Payment service
│   ├── balance-service-deployment.yaml     # Balance deployment
│   ├── balance-service-service.yaml        # Balance service
│   └── ingress.yaml                        # Ingress + NodePort services
│
├── scripts/                                # Automation scripts
│   ├── setup-jenkins.sh                    # Jenkins setup помощник
│   ├── setup-minikube.sh                   # Minikube инициализация
│   ├── deploy-all.sh                       # Build и deploy всички services
│   ├── cleanup.sh                          # Изчистване на deployments
│   ├── test-services.sh                    # Тестване на endpoints
│   └── check-status.sh                     # Проверка на системен статус
│
├── Jenkinsfile                             # Jenkins Pipeline definition
├── docker-compose.yml                      # Docker Compose за Jenkins/Registry
├── .gitignore                              # Git ignore правила
│
├── README.md                               # Главна документация
├── QUICKSTART.md                           # Бърз старт гид
├── ARCHITECTURE.md                         # Архитектурна документация
├── PROJECT_STRUCTURE.md                    # Този файл
└── LICENSE                                 # MIT License

```

## 📊 Статистика на проекта

### Микросървиси
- **Брой**: 3
- **Общо Java класове**: ~15
- **Общо тестове**: ~9
- **Ports**: 8081, 8082, 8083

### Kubernetes Resources
- **Deployments**: 3
- **Services**: 6 (3 ClusterIP + 3 NodePort)
- **Ingress**: 1
- **Total replicas**: 6 (2 per service)

### Scripts
- **Bash scripts**: 5
- **Total lines**: ~400

### Docker
- **Dockerfiles**: 3
- **Docker Compose services**: 5

## 🔍 Кратко описание на файловете

### Микросървиси

#### Auth Service
```
Отговорности: Authentication, Token management
REST API: /api/auth/*
Port: 8081
Dependencies: Spring Boot Web, Actuator
```

#### Payment Service
```
Отговорности: Payment processing, Transaction history
REST API: /api/payment/*
Port: 8082
Dependencies: Spring Boot Web, WebFlux, Actuator
```

#### Balance Service
```
Отговорности: Balance management, Balance updates
REST API: /api/balance/*
Port: 8083
Dependencies: Spring Boot Web, Actuator
```

### Kubernetes Files

| File | Purpose | Replicas |
|------|---------|----------|
| `namespace.yaml` | Creates microservices namespace | - |
| `*-deployment.yaml` | Defines pod template and scaling | 2 |
| `*-service.yaml` | ClusterIP service for internal access | - |
| `ingress.yaml` | HTTP routing + NodePort services | - |

### Scripts

| Script | Purpose | Platform |
|--------|---------|----------|
| `setup-minikube.sh` | Initialize Minikube cluster | Linux/macOS |
| `setup-jenkins.sh` | Jenkins initial setup helper | Linux/macOS |
| `deploy-all.sh` | Build and deploy all services | Linux/macOS |
| `cleanup.sh` | Remove all Kubernetes resources | Linux/macOS |
| `test-services.sh` | Test all endpoints | Linux/macOS |
| `check-status.sh` | Check platform status | Linux/macOS |

**Note**: Windows потребители могат да изпълняват командите ръчно от скриптовете.

### Configuration Files

| File | Purpose |
|------|---------|
| `Jenkinsfile` | CI/CD pipeline definition |
| `docker-compose.yml` | Local infrastructure setup |
| `pom.xml` | Maven dependencies and build config |
| `Dockerfile` | Container image build instructions |
| `application.yml` | Spring Boot configuration |

### Documentation Files

| File | Content |
|------|---------|
| `README.md` | Пълна документация с инструкции |
| `QUICKSTART.md` | Бърз старт гид |
| `ARCHITECTURE.md` | Архитектура и дизайн решения |
| `PROJECT_STRUCTURE.md` | Структура на проекта (този файл) |
| `LICENSE` | MIT License |

## 🎯 Key Locations

### За разработка
```bash
microservices/*/src/main/java/          # Java source code
microservices/*/src/main/resources/     # Configuration files
microservices/*/src/test/java/          # Test code
```

### За deployment
```bash
kubernetes/                             # K8s manifests
Jenkinsfile                             # CI/CD pipeline
docker-compose.yml                      # Local infrastructure
```

### За администрация
```bash
scripts/                                # Helper scripts
README.md                               # Main documentation
```

## 📦 Artifact Locations

### Build artifacts
```bash
microservices/*/target/*.jar            # Built JAR files (gitignored)
```

### Docker artifacts
```bash
localhost:5000/auth-service:*           # In local registry
localhost:5000/payment-service:*        # In local registry
localhost:5000/balance-service:*        # In local registry
```

### Kubernetes artifacts
```bash
kubectl get pods                        # Running pods
kubectl get services                    # Service endpoints
kubectl get deployments                 # Deployment status
```

## 🔄 File Dependencies

### Build Process Flow
```
pom.xml → Maven → target/*.jar → Dockerfile → Docker Image → Registry → K8s Deployment
```

### Pipeline Flow
```
Jenkinsfile → microservices/*/pom.xml
           → microservices/*/Dockerfile
           → kubernetes/*.yaml
```

### Service Communication
```
Auth Service ←→ (future) Payment Service
Payment Service ←→ Balance Service (planned integration)
```

## 📝 Naming Conventions

### Java Files
- **Classes**: PascalCase (e.g., `AuthController`, `PaymentService`)
- **Methods**: camelCase (e.g., `processPayment`, `getBalance`)
- **Packages**: lowercase (e.g., `com.microservices.auth`)

### Kubernetes Resources
- **Deployments**: `service-name` (e.g., `auth-service`)
- **Services**: `service-name` (e.g., `auth-service`)
- **NodePort Services**: `service-name-nodeport` (e.g., `auth-service-nodeport`)

### Docker Images
- **Format**: `localhost:5000/service-name:tag`
- **Example**: `localhost:5000/auth-service:latest`

### Scripts
- **Format**: `action-target.sh`
- **Examples**: `setup-minikube.sh`, `deploy-all.sh`

## 🛠️ How to Navigate

### To add a new microservice:
1. Create folder: `microservices/new-service/`
2. Copy structure from existing service
3. Update `pom.xml` with new artifact name
4. Create Kubernetes manifests in `kubernetes/`
5. Update `Jenkinsfile` to include new service
6. Update `deploy-all.sh` script

### To modify a service:
1. Edit code in `microservices/service-name/src/`
2. Run tests: `mvn test`
3. Build locally: `mvn clean package`
4. Test locally: `java -jar target/*.jar`
5. Build Docker: `docker build -t ...`
6. Deploy: `kubectl apply -f kubernetes/`

### To modify pipeline:
1. Edit `Jenkinsfile`
2. Commit changes
3. Trigger Jenkins build
4. Monitor in Jenkins UI

## 🔗 Related Files

When modifying a service, you typically need to update:

```
microservices/SERVICE_NAME/
├── src/main/java/              → Code changes
├── src/test/java/              → Test updates
├── pom.xml                     → Dependencies
├── Dockerfile                  → Container changes
└── src/main/resources/         → Configuration

kubernetes/
├── SERVICE_NAME-deployment.yaml → K8s deployment config
└── SERVICE_NAME-service.yaml    → K8s service config

Jenkinsfile                     → CI/CD pipeline
```

## 💡 Tips

- **IDE Support**: Import as Maven project in IntelliJ IDEA or Eclipse
- **Local Testing**: Run Spring Boot apps directly from IDE
- **Quick Rebuild**: Use `mvn clean package -DskipTests` for faster builds
- **Log Viewing**: Use `kubectl logs -f pod-name` to follow logs
- **Port Forwarding**: Use `kubectl port-forward` for local access

---

**For detailed information, see [README.md](README.md)**

