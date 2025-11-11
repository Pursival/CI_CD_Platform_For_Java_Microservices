# 🚀 Бърз старт

Това е кратко ръководство за бързо стартиране на CI/CD платформата. За пълна документация вижте [README.md](README.md).

## Предварителни изисквания

Уверете се, че имате инсталирани:
- Docker Desktop (или Docker Engine + Docker Compose)
- Minikube
- kubectl
- Java 17
- Maven 3.9+
- Git

## Стартиране в 5 стъпки

### 1️⃣ Клониране на проекта

```bash
git clone <repository-url>
cd CI_CD_Platform_For_Java_Microservices
```

### 2️⃣ Стартиране на Minikube

```bash
# Linux/macOS
chmod +x scripts/*.sh
./scripts/setup-minikube.sh

# Windows
minikube start --driver=docker --cpus=4 --memory=8192
minikube addons enable ingress
minikube ssh "echo '{\"insecure-registries\": [\"localhost:5000\", \"host.minikube.internal:5000\"]}' | sudo tee /etc/docker/daemon.json"
minikube ssh "sudo systemctl restart docker"
```

### 3️⃣ Стартиране на Jenkins и Docker Registry

```bash
docker-compose up -d

# Получаване на Jenkins admin password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Отворете http://localhost:8080 и завършете Jenkins setup.

### 4️⃣ Build и Deploy на микросървисите

```bash
# Linux/macOS
./scripts/deploy-all.sh

# Windows - вижте README.md секция "Build и Deploy"
```

### 5️⃣ Тестване

```bash
# Проверка на статус
kubectl get pods
kubectl get services

# Получаване на Minikube IP
minikube ip

# Тестване на endpoints
curl http://$(minikube ip):30081/api/auth/health
curl http://$(minikube ip):30082/api/payment/health
curl http://$(minikube ip):30083/api/balance/health
```

## 🎯 Достъп до услугите

После стартиране, имате достъп до:

| Услуга | URL | Credentials |
|--------|-----|-------------|
| Jenkins | http://localhost:8080 | Вижте initial password |
| Docker Registry UI | http://localhost:8081 | - |
| SonarQube | http://localhost:9000 | admin/admin |
| Auth Service | http://MINIKUBE_IP:30081 | - |
| Payment Service | http://MINIKUBE_IP:30082 | - |
| Balance Service | http://MINIKUBE_IP:30083 | - |

## 📊 Проверка на статус

```bash
# Автоматична проверка
./scripts/check-status.sh

# Ръчна проверка
docker-compose ps
kubectl get all
minikube status
```

## 🧪 Пълен тестов flow

```bash
# Linux/macOS
./scripts/test-services.sh

# Или ръчно
MINIKUBE_IP=$(minikube ip)

# 1. Login
curl -X POST http://$MINIKUBE_IP:30081/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"user1","password":"pass123"}'

# 2. Create balance
curl -X POST http://$MINIKUBE_IP:30083/api/balance/create?userId=user1

# 3. Process payment
curl -X POST http://$MINIKUBE_IP:30082/api/payment/process \
  -H "Content-Type: application/json" \
  -d '{"userId":"user1","amount":100.0,"currency":"USD","description":"Test"}'

# 4. Check history
curl http://$MINIKUBE_IP:30082/api/payment/history/user1
```

## 🔄 Използване на Jenkins Pipeline

1. Отворете Jenkins: http://localhost:8080
2. New Item → Pipeline → "Microservices-Pipeline"
3. Pipeline → Definition: "Pipeline script from SCM"
4. SCM: Git → Repository URL: (вашият path)
5. Script Path: `Jenkinsfile`
6. Save → Build with Parameters
7. Изберете параметри:
   - SERVICE: `all`
   - SKIP_TESTS: `false`
   - DEPLOY_TO_K8S: `true`
8. Build!

## 🛑 Спиране

```bash
# Спиране на Kubernetes deployments
./scripts/cleanup.sh

# Спиране на Jenkins и Registry
docker-compose down

# Спиране на Minikube
minikube stop
```

## ❓ Проблеми?

### Jenkins не може да достъпи Docker
```bash
docker-compose restart jenkins
```

### Pods са в ImagePullBackOff
```bash
# Проверка
kubectl describe pod <pod-name>

# Build и push отново
cd microservices/auth-service
docker build -t localhost:5000/auth-service:latest .
docker push localhost:5000/auth-service:latest
kubectl rollout restart deployment/auth-service
```

### Minikube няма достатъчно ресурси
```bash
minikube stop
minikube delete
minikube start --driver=docker --cpus=6 --memory=12288
```

## 📚 Следващи стъпки

1. Прочетете пълната документация в [README.md](README.md)
2. Експериментирайте с Jenkins Pipeline
3. Модифицирайте микросървисите
4. Добавете нови features
5. Имплементирайте собствени тестове

## 🆘 Помощ

За подробна информация и troubleshooting вижте [README.md](README.md).

За въпроси и issues: [GitHub Issues](<your-repo-url>)

---

**Успех с вашата CI/CD платформа! 🚀**

