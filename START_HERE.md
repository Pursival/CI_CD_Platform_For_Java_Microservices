# 🎯 ЗАПОЧНЕТЕ ОТ ТУК

## ✅ Какво е създадено?

Пълна **CI/CD платформа за Java микросървиси** според точно предоставената структура:

```
CI_CD_Platform_For_Java_Microservices/
├── jenkins/          # Jenkins + Docker Registry + SonarQube
├── k8s/              # Kubernetes manifests (per-service)
├── services/         # 3 Spring Boot microservices
├── README.md         # Пълна документация
└── LICENSE           # MIT License
```

## 🎯 Компоненти

### ✅ 3 Spring Boot Микросървиса

1. **Auth Service** (port 8081, NodePort 30081)
   - Package: `com.example.auth`
   - Endpoint: `/health`, `/login`
   - Tests: JUnit 5

2. **Payment Service** (port 8082, NodePort 30082)
   - Package: `com.example.payment`
   - Endpoint: `/health`, `/process`
   - Tests: JUnit 5

3. **Balance Service** (port 8083, NodePort 30083)
   - Package: `com.example.balance`
   - Endpoint: `/health`, `/balance/{userId}`
   - Tests: JUnit 5

### ✅ Jenkins CI/CD Pipeline

- **Location**: `jenkins/Jenkinsfile`
- **Stages**: 7 (Checkout → Build → Test → Docker Build → Push → Deploy → Verify)
- **Features**: Parallel builds, параметризиран, automatic rollout
- **Docker Compose**: Jenkins + Registry + SonarQube

### ✅ Kubernetes Deployment

- **Per-service structure**: `k8s/<service-name>/`
- **Files**: deployment.yaml, service.yaml, ingress.yaml
- **Replicas**: 2 per service (6 pods total)
- **Access**: NodePort (30081, 30082, 30083)

### ✅ Docker

- **Multi-stage builds**: OpenJDK 17 + Maven
- **Local registry**: localhost:5000
- **Registry UI**: localhost:8081
- **Optimized images**: Alpine runtime

## 📖 Документация

### Основни документи:

1. **[QUICK_START.md](QUICK_START.md)** ⭐ **ЗАПОЧНЕТЕ ОТ ТУК!**
   - 5 стъпки за пълен deployment
   - ~30 минути за стартиране

2. **[README.md](README.md)** - Пълна документация
   - Детайлни инструкции
   - Troubleshooting
   - API примери

3. **[jenkins/README.md](jenkins/README.md)** - Jenkins setup
   - Plugin installation
   - Pipeline creation
   - Configuration

4. **[PROJECT_STRUCTURE_NEW.md](PROJECT_STRUCTURE_NEW.md)** - Структура
   - Детайлно описание
   - Naming conventions
   - Components

5. **[NEW_STRUCTURE_SUMMARY.md](NEW_STRUCTURE_SUMMARY.md)** - Comparison
   - Old vs New structure
   - Feature checklist
   - Benefits

## 🚀 Quick Start (5 Steps)

### 1. Стартиране на Minikube
```bash
minikube start --driver=docker --cpus=4 --memory=8192
minikube addons enable ingress
```

### 2. Стартиране на Jenkins
```bash
cd jenkins
docker-compose up -d
```

### 3. Конфигуриране на Jenkins
- Отворете http://localhost:8080
- Install plugins: Docker Pipeline, Kubernetes CLI, Maven Integration

### 4. Build & Deploy
**Опция A (Jenkins):**
- Create pipeline → Point to `jenkins/Jenkinsfile`
- Build with parameters (SERVICE=all)

**Опция B (Manual):**
```bash
cd services/auth-service
mvn clean package
docker build -t localhost:5000/auth-service:latest .
docker push localhost:5000/auth-service:latest
kubectl apply -f k8s/auth-service/
```

### 5. Test
```bash
curl http://$(minikube ip):30081/health
curl http://$(minikube ip):30082/health
curl http://$(minikube ip):30083/health
```

## 📊 Architecture

```
Developer
    ↓
Jenkins Pipeline
    ↓ (mvn clean package)
JAR Files
    ↓ (docker build)
Docker Images
    ↓ (docker push)
Local Registry (localhost:5000)
    ↓ (kubectl apply)
Minikube Cluster
    ↓
6 Running Pods (2 replicas × 3 services)
```

## 🎯 Access Points

| Service | URL | Purpose |
|---------|-----|---------|
| Jenkins | http://localhost:8080 | CI/CD |
| Registry UI | http://localhost:8081 | Docker images |
| SonarQube | http://localhost:9000 | Code quality |
| Auth API | http://MINIKUBE_IP:30081 | Authentication |
| Payment API | http://MINIKUBE_IP:30082 | Payments |
| Balance API | http://MINIKUBE_IP:30083 | Balances |

## ✨ Key Features

- ✅ **Fully local** - No cloud dependencies
- ✅ **100% free** - Only open-source tools
- ✅ **Production-ready patterns** - Best practices
- ✅ **Automated CI/CD** - End-to-end pipeline
- ✅ **High availability** - 2 replicas per service
- ✅ **Health monitoring** - Liveness & readiness probes
- ✅ **Zero-downtime deploys** - Rolling updates
- ✅ **Comprehensive tests** - JUnit 5 tests

## 📁 File Breakdown

### Jenkins Files (4 files)
```
jenkins/
├── Jenkinsfile                 # Pipeline (7 stages)
├── docker-compose.yml          # Infrastructure (5 services)
├── registry/config.yml         # Registry config
└── README.md                   # Setup guide
```

### Kubernetes Files (9 files)
```
k8s/
├── auth-service/               # 3 files
├── payment-service/            # 3 files
└── balance-service/            # 3 files
```

### Service Files (15 files per service)
```
services/<service-name>/
├── pom.xml                     # Maven config
├── Dockerfile                  # Multi-stage build
├── src/main/java/              # Application code
├── src/main/resources/         # Config
└── src/test/java/              # Tests
```

## 🎓 Learning Path

### Beginner (Day 1)
1. Read [QUICK_START.md](QUICK_START.md)
2. Deploy platform
3. Test endpoints
4. Explore Jenkins UI

### Intermediate (Day 2-3)
1. Read [README.md](README.md)
2. Run Jenkins pipeline
3. Modify a service
4. Redeploy changes

### Advanced (Week 1)
1. Read [PROJECT_STRUCTURE_NEW.md](PROJECT_STRUCTURE_NEW.md)
2. Add new microservice
3. Customize pipeline
4. Implement new features

## 🐛 Common Issues

### Problem: Jenkins can't access Docker
```bash
docker-compose -f jenkins/docker-compose.yml restart jenkins
```

### Problem: Minikube can't pull images
```bash
minikube ssh
sudo vi /etc/docker/daemon.json
# Add: {"insecure-registries": ["host.minikube.internal:5000"]}
sudo systemctl restart docker
```

### Problem: Pods in ImagePullBackOff
```bash
docker build -t localhost:5000/auth-service:latest services/auth-service/
docker push localhost:5000/auth-service:latest
kubectl rollout restart deployment/auth-service
```

## 🛑 Cleanup

```bash
# Delete K8s resources
kubectl delete -f k8s/auth-service/
kubectl delete -f k8s/payment-service/
kubectl delete -f k8s/balance-service/

# Stop Jenkins
cd jenkins && docker-compose down

# Stop Minikube
minikube stop
```

## 📚 Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Language | Java | 17 |
| Framework | Spring Boot | 3.1.5 |
| Build | Maven | 3.9+ |
| Testing | JUnit | 5 |
| Container | Docker | 20.10+ |
| CI/CD | Jenkins | LTS |
| Orchestration | Kubernetes | 1.27+ |
| Local K8s | Minikube | 1.30+ |

## ✅ Requirements Met

- [x] 3 Spring Boot services (Java 17)
- [x] Simple REST endpoints with /health
- [x] JUnit tests for each service
- [x] pom.xml with dependencies
- [x] Dockerfile using OpenJDK 17 and Maven
- [x] Jenkins pipeline (Jenkinsfile)
- [x] Pull code from Git
- [x] Run `mvn clean package`
- [x] Execute unit tests
- [x] Build Docker images
- [x] Push to local registry (localhost:5000)
- [x] Deploy to Minikube using kubectl
- [x] Kubernetes YAMLs per service
- [x] docker-compose.yml for infrastructure
- [x] 100% local and free

## 🎉 Ready to Start!

**Next steps:**
1. Read [QUICK_START.md](QUICK_START.md) (5 minutes)
2. Follow the 5 steps (30 minutes)
3. You're running! 🚀

---

**Need help?** Check the documentation:
- [QUICK_START.md](QUICK_START.md) - Quick deployment
- [README.md](README.md) - Full documentation
- [jenkins/README.md](jenkins/README.md) - Jenkins details
- [PROJECT_STRUCTURE_NEW.md](PROJECT_STRUCTURE_NEW.md) - Structure details

**For Windows users:** See [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md)

---

**🚀 The platform is ready to use! Start with [QUICK_START.md](QUICK_START.md)**

