# 🚀 Бърз Старт

Това е кратко ръководство за стартиране на CI/CD платформата в 5 стъпки.

## ✅ Предварителни изисквания

Уверете се, че имате инсталирани:
- Docker Desktop (или Docker Engine + Docker Compose)
- Minikube
- kubectl
- Java 17
- Maven 3.9+

## 📋 5 Стъпки до Работеща Система

### 1️⃣ Клониране на проекта

```bash
git clone <repository-url>
cd CI_CD_Platform_For_Java_Microservices
```

### 2️⃣ Стартиране на Minikube

```bash
# Стартиране
minikube start --driver=docker --cpus=4 --memory=8192

# Активиране на Ingress
minikube addons enable ingress

# Конфигуриране на insecure registry
minikube ssh "echo '{\"insecure-registries\": [\"localhost:5000\", \"host.minikube.internal:5000\"]}' | sudo tee /etc/docker/daemon.json"
minikube ssh "sudo systemctl restart docker"

# Проверка
kubectl cluster-info
```

### 3️⃣ Стартиране на Jenkins и Docker Registry

```bash
cd jenkins
docker-compose up -d

# Получаване на Jenkins password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

**Отворете**: http://localhost:8080
- Въведете password
- Изберете "Install suggested plugins"
- Създайте admin акаунт
- Инсталирайте plugins: Docker Pipeline, Kubernetes CLI, Maven Integration

### 4️⃣ Създаване на Jenkins Pipeline

1. **New Item** → Име: `Microservices-Pipeline` → **Pipeline**
2. **Pipeline**:
   - Definition: `Pipeline script from SCM`
   - SCM: `Git`
   - Repository URL: `<your-repo-url>`
   - Script Path: `jenkins/Jenkinsfile`
3. **Save**

### 5️⃣ Build и Deploy

**В Jenkins:**
1. Click на pipeline
2. **Build with Parameters**
3. Изберете:
   - SERVICE: `all`
   - SKIP_TESTS: `false`
   - DEPLOY_TO_K8S: `true`
4. **Build**

**Или ръчно (за бързо тестване):**

```bash
# Build и deploy всички services
cd services/auth-service
mvn clean package -DskipTests
docker build -t localhost:5000/auth-service:latest .
docker push localhost:5000/auth-service:latest

cd ../payment-service
mvn clean package -DskipTests
docker build -t localhost:5000/payment-service:latest .
docker push localhost:5000/payment-service:latest

cd ../balance-service
mvn clean package -DskipTests
docker build -t localhost:5000/balance-service:latest .
docker push localhost:5000/balance-service:latest

# Deploy to Kubernetes
cd ../..
kubectl apply -f k8s/auth-service/
kubectl apply -f k8s/payment-service/
kubectl apply -f k8s/balance-service/

# Проверка
kubectl get pods
kubectl get services
```

## ✅ Проверка

```bash
# Получаване на Minikube IP
MINIKUBE_IP=$(minikube ip)

# Тестване на services
curl http://$MINIKUBE_IP:30081/health  # Auth Service
curl http://$MINIKUBE_IP:30082/health  # Payment Service
curl http://$MINIKUBE_IP:30083/health  # Balance Service

# Проверка на deployments
kubectl get pods
kubectl get services
kubectl get ingress
```

## 🎯 Достъп до услугите

| Услуга | URL |
|--------|-----|
| Jenkins | http://localhost:8080 |
| Docker Registry UI | http://localhost:8081 |
| SonarQube | http://localhost:9000 (admin/admin) |
| Auth Service | http://MINIKUBE_IP:30081 |
| Payment Service | http://MINIKUBE_IP:30082 |
| Balance Service | http://MINIKUBE_IP:30083 |

## 📝 Примерни заявки

### Auth Service

```bash
# Login
curl -X POST http://$(minikube ip):30081/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"pass123"}'
```

### Payment Service

```bash
# Process payment
curl -X POST http://$(minikube ip):30082/process \
  -H "Content-Type: application/json" \
  -d '{"userId":"user1","amount":100.50,"currency":"USD"}'
```

### Balance Service

```bash
# Get balance
curl http://$(minikube ip):30083/balance/user1

# Update balance
curl -X POST http://$(minikube ip):30083/balance/user1 \
  -H "Content-Type: application/json" \
  -d '{"amount":50.0}'
```

## 🐛 Чести Проблеми

### Jenkins не може да достъпи Docker

```bash
docker-compose -f jenkins/docker-compose.yml restart jenkins
```

### Minikube не може да pull images

```bash
# Конфигурирайте insecure registry
minikube ssh
sudo vi /etc/docker/daemon.json
# Добавете: {"insecure-registries": ["host.minikube.internal:5000"]}
sudo systemctl restart docker
exit
```

### Pods са в ImagePullBackOff

```bash
# Re-build и push
cd services/auth-service
docker build -t localhost:5000/auth-service:latest .
docker push localhost:5000/auth-service:latest

# Restart deployment
kubectl rollout restart deployment/auth-service
```

## 🛑 Спиране

```bash
# Спиране на Kubernetes deployments
kubectl delete -f k8s/auth-service/
kubectl delete -f k8s/payment-service/
kubectl delete -f k8s/balance-service/

# Спиране на Jenkins
cd jenkins
docker-compose down

# Спиране на Minikube
minikube stop
```

## 📚 Следващи Стъпки

1. Прочетете пълното [README.md](README.md)
2. Разгледайте [jenkins/README.md](jenkins/README.md) за Jenkins детайли
3. Експериментирайте с модификация на services
4. Добавете нови features

---

**За пълна документация вижте [README.md](README.md)**

**За Windows потребители вижте [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md)**

