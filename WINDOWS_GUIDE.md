# 🪟 Windows Специфично Ръководство

Това ръководство е специално за Windows потребители и съдържа специфични инструкции за Windows среда.

## 📋 Предварителни изисквания за Windows

### 1. Windows Version
- Windows 10 Pro/Enterprise/Education (Build 19041 или по-нова)
- Windows 11 (всички версии)
- **Забележка**: Windows 10 Home изисква WSL2

### 2. Инсталация на софтуер

#### Docker Desktop за Windows

```powershell
# С Chocolatey
choco install docker-desktop

# Или изтеглете от:
# https://docs.docker.com/desktop/install/windows-install/
```

**След инсталация:**
1. Стартирайте Docker Desktop
2. Изчакайте Docker да стартира напълно
3. Проверка: `docker --version`

#### Minikube

```powershell
# С Chocolatey
choco install minikube

# Или изтеглете от:
# https://minikube.sigs.k8s.io/docs/start/
```

#### kubectl

```powershell
# С Chocolatey
choco install kubernetes-cli

# Или изтеглете от:
# https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
```

#### Java 17

```powershell
# С Chocolatey
choco install openjdk17

# Или изтеглете от:
# https://adoptium.net/
```

#### Maven

```powershell
# С Chocolatey
choco install maven

# Или изтеглете от:
# https://maven.apache.org/download.cgi
```

#### Git

```powershell
# С Chocolatey
choco install git

# Или изтеглете от:
# https://git-scm.com/download/win
```

### 3. Конфигурация на PowerShell

**Разрешаване на PowerShell скриптове:**

```powershell
# Стартирайте PowerShell като Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Проверка
Get-ExecutionPolicy
```

### 4. Проверка на инсталацията

```powershell
# Проверка на всички инструменти
docker --version
docker-compose --version
minikube version
kubectl version --client
java -version
mvn --version
git --version
```

## 🚀 Стартиране на платформата (Windows)

### Стъпка 1: Клониране на проекта

```powershell
# PowerShell
git clone <repository-url>
cd CI_CD_Platform_For_Java_Microservices
```

### Стъпка 2: Стартиране на Docker Desktop

1. Отворете Docker Desktop от Start Menu
2. Изчакайте да се покаже "Docker Desktop is running"
3. Проверка:

```powershell
docker ps
```

### Стъпка 3: Стартиране на Minikube

```powershell
# Използване на PowerShell скрипт
.\scripts\setup-minikube.ps1

# Или ръчно:
minikube start --driver=docker --cpus=4 --memory=8192
minikube addons enable ingress
```

**Конфигуриране на insecure registry:**

```powershell
minikube ssh "echo '{`"insecure-registries`": [`"localhost:5000`", `"host.minikube.internal:5000`"]}' | sudo tee /etc/docker/daemon.json"
minikube ssh "sudo systemctl restart docker"
```

### Стъпка 4: Стартиране на Jenkins и Registry

```powershell
# PowerShell
docker-compose up -d

# Проверка
docker-compose ps

# Получаване на Jenkins initial password
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Стъпка 5: Build и Deploy

```powershell
# Използване на PowerShell скрипт
.\scripts\deploy-all.ps1

# Или ръчно - вижте секция "Ръчен Deploy"
```

### Стъпка 6: Тестване

```powershell
# Автоматично тестване
.\scripts\test-services.ps1

# Проверка на статус
.\scripts\check-status.ps1

# Получаване на Minikube IP
$MINIKUBE_IP = minikube ip
Write-Host "Minikube IP: $MINIKUBE_IP"

# Тестване на endpoints
curl "http://${MINIKUBE_IP}:30081/api/auth/health"
curl "http://${MINIKUBE_IP}:30082/api/payment/health"
curl "http://${MINIKUBE_IP}:30083/api/balance/health"
```

## 🔧 Ръчен Deploy (Windows)

Ако PowerShell скриптовете не работят:

```powershell
# Auth Service
cd microservices\auth-service
mvn clean package -DskipTests
docker build -t localhost:5000/auth-service:latest .
docker push localhost:5000/auth-service:latest
cd ..\..

# Payment Service
cd microservices\payment-service
mvn clean package -DskipTests
docker build -t localhost:5000/payment-service:latest .
docker push localhost:5000/payment-service:latest
cd ..\..

# Balance Service
cd microservices\balance-service
mvn clean package -DskipTests
docker build -t localhost:5000/balance-service:latest .
docker push localhost:5000/balance-service:latest
cd ..\..

# Deploy to Kubernetes
kubectl apply -f kubernetes\namespace.yaml
kubectl apply -f kubernetes\auth-service-deployment.yaml
kubectl apply -f kubernetes\auth-service-service.yaml
kubectl apply -f kubernetes\payment-service-deployment.yaml
kubectl apply -f kubernetes\payment-service-service.yaml
kubectl apply -f kubernetes\balance-service-deployment.yaml
kubectl apply -f kubernetes\balance-service-service.yaml
kubectl apply -f kubernetes\ingress.yaml

# Wait for deployment
kubectl rollout status deployment/auth-service --timeout=300s
kubectl rollout status deployment/payment-service --timeout=300s
kubectl rollout status deployment/balance-service --timeout=300s
```

## 🐛 Windows-Specific Troubleshooting

### Проблем 1: PowerShell скриптове не се изпълняват

**Грешка**: `cannot be loaded because running scripts is disabled`

**Решение**:
```powershell
# Като Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Проблем 2: Docker Desktop не стартира

**Решение**:
1. Проверете дали WSL2 е инсталиран:
   ```powershell
   wsl --list --verbose
   ```
2. Ако не е инсталиран:
   ```powershell
   wsl --install
   ```
3. Рестартирайте компютъра
4. Стартирайте Docker Desktop отново

### Проблем 3: Minikube не може да стартира

**Грешка**: `Exiting due to DRV_NOT_HEALTHY`

**Решение**:
```powershell
# Изтриване и рестартиране
minikube delete
minikube start --driver=docker --cpus=4 --memory=8192

# Ако не работи, опитайте Hyper-V driver (изисква Windows Pro/Enterprise)
minikube start --driver=hyperv --cpus=4 --memory=8192
```

### Проблем 4: Path проблеми с Maven/Java

**Решение**:
```powershell
# Добавяне на Maven към PATH (като Administrator)
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Apache\maven\bin", "Machine")

# Задаване на JAVA_HOME
[Environment]::SetEnvironmentVariable("JAVA_HOME", "C:\Program Files\Eclipse Adoptium\jdk-17.0.x", "Machine")

# Рестартирайте PowerShell
```

### Проблем 5: curl не работи

**Решение 1**: Използвайте Invoke-WebRequest:
```powershell
Invoke-WebRequest -Uri "http://$(minikube ip):30081/api/auth/health"
```

**Решение 2**: Инсталирайте curl за Windows:
```powershell
choco install curl
```

### Проблем 6: Line endings проблеми

**Решение**:
```powershell
# Конфигурация на Git
git config --global core.autocrlf true
```

### Проблем 7: Port конфликти

**Често срещани портове, които може да са заети:**
- 8080 (Jenkins) - проверете дали не работи друг сървър
- 5000 (Registry) - проверете за други приложения
- 9000 (SonarQube) - проверете за други приложения

**Проверка на портове**:
```powershell
# Проверка кой процес използва порт
netstat -ano | findstr :8080

# Спиране на процес (замнете PID)
taskkill /PID <PID> /F
```

### Проблем 8: Hyper-V конфликти

Ако използвате VirtualBox или VMware:

```powershell
# Деактивиране на Hyper-V (изисква рестарт)
bcdedit /set hypervisorlaunchtype off

# Активиране на Hyper-V (изисква рестарт)
bcdedit /set hypervisorlaunchtype auto
```

### Проблем 9: Docker network проблеми

**Решение**:
```powershell
# Рестартиране на Docker network
docker network prune
docker-compose down
docker-compose up -d
```

### Проблем 10: Jenkins permissions

**Грешка**: Jenkins не може да достъпи Docker

**Решение**: Docker Desktop трябва да споделя Docker daemon:
1. Docker Desktop → Settings
2. General → "Expose daemon on tcp://localhost:2375 without TLS"
3. Apply & Restart

## 💡 Windows Tips

### 1. Използване на Windows Terminal

Windows Terminal предоставя по-добро изживяване:

```powershell
# Инсталация
choco install microsoft-windows-terminal

# Или от Microsoft Store
```

### 2. Alias за често използвани команди

Добавете в PowerShell profile:

```powershell
# Отваряне на profile
notepad $PROFILE

# Добавяне на aliases
New-Alias -Name k -Value kubectl
New-Alias -Name m -Value minikube
New-Alias -Name dc -Value docker-compose

# Reload profile
. $PROFILE
```

### 3. Path скратки

```powershell
# Навигация до проекта
function goto-project { Set-Location "D:\CI_CD_Platform_For_Java_Microservices\CI_CD_Platform_For_Java_Microservices" }
Set-Alias -Name cdp -Value goto-project
```

### 4. Docker Desktop Memory

За по-добра производителност:
1. Docker Desktop → Settings → Resources
2. Memory: 8GB (минимум)
3. CPUs: 4 (минимум)
4. Apply & Restart

### 5. WSL2 интеграция

Ако използвате WSL2:

```powershell
# Enable WSL2 backend в Docker Desktop
# Settings → General → "Use the WSL 2 based engine"

# Можете да работите и от WSL2:
wsl
cd /mnt/d/CI_CD_Platform_For_Java_Microservices/CI_CD_Platform_For_Java_Microservices
```

## 📝 Windows-Specific Commands

### PowerShell еквиваленти на Bash команди

| Bash | PowerShell |
|------|------------|
| `ls` | `Get-ChildItem` или `dir` |
| `cd` | `Set-Location` или `cd` |
| `cat` | `Get-Content` или `type` |
| `grep` | `Select-String` |
| `rm` | `Remove-Item` или `del` |
| `cp` | `Copy-Item` или `copy` |
| `mv` | `Move-Item` или `move` |
| `echo` | `Write-Host` |
| `export VAR=value` | `$env:VAR = "value"` |
| `chmod +x` | Не е нужно във Windows |

### Полезни PowerShell команди

```powershell
# Показване на променливи на средата
Get-ChildItem Env:

# Задаване на променлива
$env:MINIKUBE_IP = minikube ip

# Показване на Docker networks
docker network ls

# Показване на Docker volumes
docker volume ls

# Почистване на Docker
docker system prune -a

# Показване на Kubernetes contexts
kubectl config get-contexts

# Превключване на context
kubectl config use-context minikube
```

## 🔄 Daily Workflow (Windows)

### Стартиране на работен ден

```powershell
# 1. Стартиране на Docker Desktop (ако не е стартиран)
# Кликнете на иконата от System Tray

# 2. Стартиране на Minikube
minikube start

# 3. Проверка на статус
.\scripts\check-status.ps1

# 4. Ако services не работят
docker-compose up -d
```

### Край на работен ден

```powershell
# 1. Спиране на Docker Compose services
docker-compose down

# 2. Спиране на Minikube
minikube stop

# 3. (Опционално) Спиране на Docker Desktop
# Десен бутон на иконата → Quit Docker Desktop
```

## 📚 Допълнителни ресурси за Windows

- [Docker Desktop для Windows](https://docs.docker.com/desktop/install/windows-install/)
- [Minikube на Windows](https://minikube.sigs.k8s.io/docs/drivers/docker/)
- [PowerShell Documentation](https://docs.microsoft.com/en-us/powershell/)
- [WSL2 Setup](https://docs.microsoft.com/en-us/windows/wsl/install)

---

**За общи инструкции вижте [README.md](README.md)**

**За бърз старт вижте [QUICKSTART.md](QUICKSTART.md)**

