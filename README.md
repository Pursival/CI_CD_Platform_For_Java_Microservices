# CI/CD Platform за Java Микросървиси

Пълна CI/CD платформа за Java микросървиси, използваща **само безплатни и локални технологии**: Jenkins, Docker, Kubernetes (Minikube), Maven и Spring Boot.

## 📋 Преглед

Този проект демонстрира пълна CI/CD платформа, която автоматизира build, test и deploy процеса на Java 17 микросървиси. Всичко работи **локално и безплатно** без облачни услуги.

### Компоненти

- **3 Spring Boot микросървиса**: Auth Service, Payment Service, Balance Service
- **Jenkins CI/CD**: Автоматизиран pipeline с параметри
- **Docker**: Контейнеризация с multi-stage builds
- **Локален Docker Registry**: Съхранение на images (localhost:5000)
- **Kubernetes (Minikube)**: Оркестрация с 2 replicas per service
- **SonarQube**: Code quality analysis (опционално)

## 🏗️ Структура на проекта

```
CI_CD_Platform_For_Java_Microservices/
├── jenkins/
│   ├── Jenkinsfile                    # Pipeline definition
│   ├── docker-compose.yml             # Jenkins + Registry + SonarQube
│   ├── registry/                      # Registry config
│   └── README.md                      # Jenkins setup guide
│
├── k8s/
│   ├── auth-service/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── ingress.yaml
│   ├── payment-service/
│   │   ├── deployment.yaml
│   │   ├── service.yaml
│   │   └── ingress.yaml
│   └── balance-service/
│       ├── deployment.yaml
│       ├── service.yaml
│       └── ingress.yaml
│
├── services/
│   ├── auth-service/                  # Authentication service (port 8081)
│   │   ├── src/main/java/
│   │   ├── src/test/java/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   ├── payment-service/               # Payment processing (port 8082)
│   │   ├── src/main/java/
│   │   ├── src/test/java/
│   │   ├── pom.xml
│   │   └── Dockerfile
│   └── balance-service/               # Balance management (port 8083)
│       ├── src/main/java/
│       ├── src/test/java/
│       ├── pom.xml
│       └── Dockerfile
│
├── README.md                          # Този файл
└── LICENSE                            # MIT License
```

## 📦 Предварителни изисквания

### Задължителни инструменти

1. **Docker Desktop** / **Docker Engine**
   - Windows/Mac: https://docs.docker.com/desktop/
   - Linux: https://docs.docker.com/engine/install/

2. **Docker Compose**
   - Идва с Docker Desktop
   - Linux: `sudo apt-get install docker-compose`

3. **Minikube**
   ```bash
   # Windows (Chocolatey)
   choco install minikube
   
   # macOS (Homebrew)
   brew install minikube
   
   # Linux
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   ```

4. **kubectl**
   ```bash
   # Windows
   choco install kubernetes-cli
   
   # macOS
   brew install kubectl
   
   # Linux
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   ```

5. **Java 17**
   ```bash
   # Windows/macOS/Linux
   choco install openjdk17  # Windows
   brew install openjdk@17  # macOS
   sudo apt-get install openjdk-17-jdk  # Linux
   ```

6. **Maven 3.9+**
   ```bash
   choco install maven    # Windows
   brew install maven     # macOS
   sudo apt-get install maven  # Linux
   ```

### Системни изисквания
- **RAM**: 8GB минимум (16GB препоръчително)
- **CPU**: 4 cores минимум
- **Disk**: 20GB свободно пространство

## 🚀 Бърз Старт

### Стъпка 1: Клониране на проекта

```bash
git clone <repository-url>
cd CI_CD_Platform_For_Java_Microservices
```

### Стъпка 2: Стартиране на Minikube

```bash
# Стартиране на Minikube с необходимите ресурси
minikube start --driver=docker --cpus=4 --memory=8192

# Активиране на Ingress addon
minikube addons enable ingress

# Конфигуриране на insecure registry
minikube ssh "echo '{\"insecure-registries\": [\"localhost:5000\", \"host.minikube.internal:5000\"]}' | sudo tee /etc/docker/daemon.json"
minikube ssh "sudo systemctl restart docker"

# Проверка
kubectl cluster-info
kubectl get nodes
```

### Стъпка 3: Стартиране на Jenkins и Docker Registry

```bash
cd jenkins
docker-compose up -d

# Проверка на статус
docker-compose ps

# Получаване на Jenkins initial password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Стъпка 4: Конфигуриране на Jenkins

1. **Отворете Jenkins**: http://localhost:8080
2. **Въведете initial admin password** (от предишната команда)
3. **Изберете "Install suggested plugins"**
4. **Създайте admin потребител**

5. **Инсталирайте допълнителни plugins**:
   - Manage Jenkins → Manage Plugins → Available
   - Изберете: Docker Pipeline, Kubernetes CLI, Pipeline, Git, Maven Integration
   - Install without restart

6. **Конфигурирайте инструменти**:
   - Manage Jenkins → Global Tool Configuration
   - **Maven**: Name: `Maven 3.9`, Install automatically: ✓
   - **JDK**: Name: `JDK17`, Install automatically: ✓

### Стъпка 5: Създаване на Pipeline в Jenkins

1. **New Item** → Име: `Microservices-Pipeline` → **Pipeline**
2. **Pipeline section**:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: `<your-git-repo-url>` или локален path
   - Script Path: `jenkins/Jenkinsfile`
3. **Save**

### Стъпка 6: Build и Deploy

#### Опция A: Чрез Jenkins (препоръчително)

1. Отворете pipeline в Jenkins
2. Click **Build with Parameters**
3. Изберете опции:
   - SERVICE: `all`
   - SKIP_TESTS: `false`
   - DEPLOY_TO_K8S: `true`
4. Click **Build**

#### Опция B: Ръчно (за тестване)

```bash
# За всеки service:
cd services/auth-service
mvn clean package
docker build -t localhost:5000/auth-service:latest .
docker push localhost:5000/auth-service:latest

# Същото за payment-service и balance-service

# Deploy to Kubernetes
kubectl apply -f k8s/auth-service/deployment.yaml
kubectl apply -f k8s/auth-service/service.yaml
kubectl apply -f k8s/auth-service/ingress.yaml

# Същото за payment-service и balance-service

# Проверка
kubectl get pods
kubectl get services
```

### Стъпка 7: Проверка и Тестване

```bash
# Получаване на Minikube IP
MINIKUBE_IP=$(minikube ip)
echo "Minikube IP: $MINIKUBE_IP"

# Тестване на health endpoints
curl http://$MINIKUBE_IP:30081/health  # Auth Service
curl http://$MINIKUBE_IP:30082/health  # Payment Service
curl http://$MINIKUBE_IP:30083/health  # Balance Service

# Проверка на pods
kubectl get pods -o wide

# Проверка на services
kubectl get services
```

## 📱 Микросървиси

### Auth Service (Port 8081 / NodePort 30081)

**Endpoints:**
```bash
# Health check
GET http://{minikube-ip}:30081/health

# Login
POST http://{minikube-ip}:30081/login
Content-Type: application/json
{
  "username": "testuser",
  "password": "password123"
}
```

### Payment Service (Port 8082 / NodePort 30082)

**Endpoints:**
```bash
# Health check
GET http://{minikube-ip}:30082/health

# Process payment
POST http://{minikube-ip}:30082/process
Content-Type: application/json
{
  "userId": "user123",
  "amount": 100.50,
  "currency": "USD"
}
```

### Balance Service (Port 8083 / NodePort 30083)

**Endpoints:**
```bash
# Health check
GET http://{minikube-ip}:30083/health

# Get balance
GET http://{minikube-ip}:30083/balance/{userId}

# Update balance
POST http://{minikube-ip}:30083/balance/{userId}
Content-Type: application/json
{
  "amount": 50.0
}
```

## 🔄 CI/CD Pipeline

Jenkins pipeline автоматизира:

1. **Checkout** - Изтегляне на код от Git
2. **Build** - `mvn clean package` за всички services (паралелно)
3. **Test** - Изпълнение на JUnit тестове (паралелно)
4. **Docker Build** - Създаване на Docker images (паралелно)
5. **Push** - Push към localhost:5000 registry (паралелно)
6. **Deploy** - Deploy в Minikube с `kubectl apply`
7. **Verify** - Проверка на deployment status

### Pipeline Параметри

- **SERVICE**: `all` | `auth-service` | `payment-service` | `balance-service`
- **SKIP_TESTS**: `true` | `false` - Skip unit tests
- **DEPLOY_TO_K8S**: `true` | `false` - Deploy to Kubernetes

## 🐛 Troubleshooting

### Jenkins не може да достъпи Docker

**Проблем**: `Cannot connect to the Docker daemon`

**Решение**:
```bash
docker-compose -f jenkins/docker-compose.yml restart jenkins
```

### Minikube не може да достъпи localhost:5000 registry

**Проблем**: `Failed to pull image "localhost:5000/..."`

**Решение**:
```bash
# Опция 1: Конфигуриране на insecure registry
minikube ssh
sudo vi /etc/docker/daemon.json
# Добавете: {"insecure-registries": ["host.minikube.internal:5000"]}
sudo systemctl restart docker
exit

# Опция 2: Използвайте Minikube's Docker daemon
eval $(minikube docker-env)
# След това build-вайте images директно
```

### Pods са в ImagePullBackOff

**Решение**:
```bash
# Проверка на image в registry
curl http://localhost:5000/v2/_catalog

# Re-build и push
cd services/auth-service
docker build -t localhost:5000/auth-service:latest .
docker push localhost:5000/auth-service:latest

# Restart deployment
kubectl rollout restart deployment/auth-service
```

### Maven build fails

**Решение**:
```bash
# Изчистване на Maven cache
cd services/auth-service
mvn clean
rm -rf ~/.m2/repository

# Re-build
mvn clean install -U
```

## 📊 Мониторинг

### Kubernetes Resources

```bash
# Всички resources
kubectl get all

# Pods с детайли
kubectl get pods -o wide

# Services
kubectl get services

# Ingress
kubectl get ingress

# Logs от pod
kubectl logs -f <pod-name>

# Describe pod
kubectl describe pod <pod-name>

# Events
kubectl get events --sort-by='.lastTimestamp'
```

### Docker Registry

```bash
# Списък на images в registry
curl http://localhost:5000/v2/_catalog

# Tags за конкретен image
curl http://localhost:5000/v2/auth-service/tags/list

# Или използвайте Registry UI
# http://localhost:8081
```

### Jenkins Logs

```bash
docker logs -f jenkins
```

## 🔧 Актуализация на Services

### Модифициране на service

1. Направете промени в кода (`services/<service-name>/src/`)
2. Commit промените в Git
3. Стартирайте Jenkins pipeline
4. Или ръчно:
   ```bash
   cd services/auth-service
   mvn clean package
   docker build -t localhost:5000/auth-service:v2 .
   docker push localhost:5000/auth-service:v2
   kubectl set image deployment/auth-service auth-service=localhost:5000/auth-service:v2
   kubectl rollout status deployment/auth-service
   ```

### Rollback

```bash
# Rollback към предишна версия
kubectl rollout undo deployment/auth-service

# Rollback към специфична revision
kubectl rollout history deployment/auth-service
kubectl rollout undo deployment/auth-service --to-revision=2
```

## 🧹 Cleanup

### Спиране на Kubernetes deployments

```bash
kubectl delete -f k8s/auth-service/
kubectl delete -f k8s/payment-service/
kubectl delete -f k8s/balance-service/
```

### Спиране на Jenkins и Registry

```bash
cd jenkins
docker-compose down

# С изтриване на volumes
docker-compose down -v
```

### Спиране на Minikube

```bash
minikube stop

# Пълно изтриване
minikube delete
```

## 📚 Допълнителна Информация

### Достъп до услугите

| Услуга | URL | Описание |
|--------|-----|----------|
| Jenkins | http://localhost:8080 | CI/CD server |
| Docker Registry UI | http://localhost:8081 | Registry web interface |
| SonarQube | http://localhost:9000 | Code quality (admin/admin) |
| Auth Service | http://{minikube-ip}:30081 | Authentication API |
| Payment Service | http://{minikube-ip}:30082 | Payment API |
| Balance Service | http://{minikube-ip}:30083 | Balance API |

### Технологичен Stack

| Компонент | Технология | Версия |
|-----------|-----------|---------|
| Language | Java | 17 |
| Framework | Spring Boot | 3.1.5 |
| Build Tool | Maven | 3.9+ |
| Testing | JUnit | 5 |
| Container | Docker | 20.10+ |
| CI/CD | Jenkins | LTS |
| Orchestration | Kubernetes | 1.27+ |
| Local K8s | Minikube | 1.30+ |

### Полезни команди

```bash
# Docker
docker ps                           # Running containers
docker images                       # Local images
docker system prune -a             # Cleanup

# Kubernetes
kubectl get all                     # All resources
kubectl top nodes                   # Node metrics
kubectl top pods                    # Pod metrics
kubectl exec -it <pod> -- bash     # Enter pod

# Minikube
minikube status                     # Status
minikube ip                         # Get IP
minikube service list               # List services
minikube dashboard                  # Open dashboard

# Maven
mvn clean package                   # Build JAR
mvn test                           # Run tests
mvn dependency:tree                # Show dependencies
```

## 🎯 Следващи Стъпки

1. **Добавяне на persistent storage** (PostgreSQL/MySQL)
2. **Имплементиране на service mesh** (Istio)
3. **Добавяне на monitoring** (Prometheus + Grafana)
4. **Distributed tracing** (Jaeger)
5. **API Gateway** (Spring Cloud Gateway)
6. **Configuration server** (Spring Cloud Config)
7. **Message broker** (RabbitMQ/Kafka)

## 🤝 Contributing

Contributions са welcome! Моля, създайте issue или pull request.

## 📝 License

Този проект е с MIT License - вижте [LICENSE](LICENSE) файл за детайли.

## 🙏 Благодарности

- Spring Boot Team
- Jenkins Community
- Kubernetes Community
- Docker Team

---

**За детайлна Jenkins конфигурация вижте [jenkins/README.md](jenkins/README.md)**

**Забележка**: Този проект е за образователни цели. За production среда имплементирайте допълнителни security мерки.
