# 📘 Jenkins Pipeline Guide

Този документ описва как работи Jenkins pipeline-ът и как да го използвате.

## 🎯 Pipeline Overview

Pipeline-ът автоматизира целия lifecycle на микросървисите:
1. **Build** - Компилиране с Maven
2. **Test** - JUnit unit tests
3. **Dockerize** - Създаване на Docker images
4. **Push** - Качване в локален registry
5. **Deploy** - Deployment в Minikube
6. **Verify** - Проверка на deployments

## 📊 Pipeline Stages

### 1. 🔍 Initialization
- Показва build информация
- Проверява наличието на необходими tools (Maven, Docker, kubectl)

### 2. 📥 Checkout Code
- Изтегля кода от Git repository
- Показва последния commit

### 3. 🧹 Clean Workspace (Optional)
- Изпълнява се само ако `CLEAN_BUILD = true`
- Изчиства Maven cache и build artifacts

### 4. 🔨 Build & Test Services (Parallel)
Паралелно за всеки service:
- **Build**: `mvn clean package`
- **Test**: `mvn test` (ако `SKIP_TESTS = false`)

Executed in parallel:
```
Auth Service    Payment Service    Balance Service
     ↓                  ↓                  ↓
   Build             Build              Build
     ↓                  ↓                  ↓
   Test              Test               Test
```

### 5. 🐳 Build Docker Images (Parallel)
Паралелно build на Docker images за всички services:
```bash
docker build -t <service>:<tag> .
docker tag <service>:<tag> localhost:5000/<service>:<tag>
docker tag <service>:<tag> localhost:5000/<service>:latest
```

### 6. 📤 Push to Local Registry (Parallel)
Паралелно push към localhost:5000:
```bash
docker push localhost:5000/<service>:<tag>
docker push localhost:5000/<service>:latest
```

### 7. 🚀 Deploy to Minikube (Sequential)
**ВАЖНО**: Services се deploy-ват последователно за да се спазят зависимостите:

```
1. Pre-deployment Check
   ↓
2. Auth Service
   ↓ (wait for rollout)
3. Payment Service
   ↓ (wait for rollout)
4. Balance Service
```

За всеки service:
```bash
kubectl apply -f k8s/<service>/deployment.yaml
kubectl apply -f k8s/<service>/service.yaml
kubectl apply -f k8s/<service>/ingress.yaml
kubectl rollout status deployment/<service> --timeout=300s
```

### 8. ✅ Verify Deployment
- Показва pods status
- Показва services
- Показва deployments
- Показва ingress
- Показва access endpoints
- Извършва health checks

### 9. 📊 Generate Report
- Build summary
- Docker images list
- Registry images verification

## 🎛️ Pipeline Parameters

### DEPLOY_ENV
- **Type**: Choice
- **Options**: `minikube`, `all`
- **Default**: `minikube`
- **Description**: Target deployment environment

### SKIP_TESTS
- **Type**: Boolean
- **Default**: `false`
- **Description**: Skip unit tests for faster builds
- **Use case**: За бързи iterations по време на development

### CLEAN_BUILD
- **Type**: Boolean
- **Default**: `false`
- **Description**: Clean Maven cache before build
- **Use case**: При проблеми с dependencies или corrupted cache

### FORCE_REDEPLOY
- **Type**: Boolean
- **Default**: `false`
- **Description**: Force redeployment even if no changes
- **Use case**: За рестартиране на services в Kubernetes

## 🔧 Environment Variables

```groovy
// Docker Registry
DOCKER_REGISTRY = 'localhost:5000'
REGISTRY_URL = 'http://localhost:5000'

// Service Names
AUTH_SERVICE = 'auth-service'
PAYMENT_SERVICE = 'payment-service'
BALANCE_SERVICE = 'balance-service'

// Image Tags
IMAGE_TAG = "${BUILD_NUMBER}"
LATEST_TAG = 'latest'

// Paths
SERVICES_DIR = 'services'
K8S_DIR = 'k8s'

// Maven Options
MAVEN_OPTS = '-Dmaven.repo.local=.m2/repository'
```

## 🚀 How to Use

### Method 1: Via Jenkins UI

1. **Open Jenkins**: http://localhost:8080

2. **Create Pipeline Job**:
   - New Item → "Microservices-Pipeline" → Pipeline
   - Pipeline Definition: "Pipeline script from SCM"
   - SCM: Git
   - Repository URL: Your Git repo
   - Script Path: `jenkins/Jenkinsfile`

3. **Run Pipeline**:
   - Click "Build with Parameters"
   - Select parameters:
     - DEPLOY_ENV: `minikube`
     - SKIP_TESTS: `false` (or `true` for faster builds)
     - CLEAN_BUILD: `false`
     - FORCE_REDEPLOY: `false`
   - Click "Build"

4. **Monitor**:
   - View console output
   - See visual pipeline stages
   - Check logs for each stage

### Method 2: Via Jenkins CLI (Advanced)

```bash
# Trigger build with default parameters
curl -X POST http://localhost:8080/job/Microservices-Pipeline/build \
  --user admin:admin

# Trigger with parameters
curl -X POST http://localhost:8080/job/Microservices-Pipeline/buildWithParameters \
  --user admin:admin \
  --data DEPLOY_ENV=minikube \
  --data SKIP_TESTS=false
```

## 📖 Reading Pipeline Output

Pipeline output използва visual separators за по-добра четимост:

```
═══════════════════════════════════════════════════════════════
🚀 CI/CD Pipeline Started
═══════════════════════════════════════════════════════════════

───────────────────────────────────────────────────────
🔨 Building auth-service
───────────────────────────────────────────────────────
```

### Status Indicators:
- ✅ Success
- ❌ Failure
- ⚠️ Warning
- 🔍 Information
- 🔨 Building
- 🧪 Testing
- 🐳 Docker operation
- 📤 Push operation
- 🚀 Deployment
- 🧹 Cleanup

## 🔍 Troubleshooting

### Build Stage Fails

**Problem**: Maven build fails

**Check**:
```bash
# In Jenkins workspace
cd services/auth-service
mvn clean package -X  # Debug mode
```

**Common causes**:
- Missing dependencies
- Java version mismatch
- Corrupted Maven cache → Try `CLEAN_BUILD = true`

### Docker Build Fails

**Problem**: Docker build fails

**Check**:
```bash
# Build manually to see error
cd services/auth-service
docker build -t test .
```

**Common causes**:
- Docker daemon not running
- Dockerfile syntax error
- Base image not available

### Push to Registry Fails

**Problem**: Cannot push to localhost:5000

**Check**:
```bash
# Check registry is running
docker ps | grep registry

# Test registry
curl http://localhost:5000/v2/_catalog
```

**Solution**:
```bash
# Restart registry
cd jenkins
docker-compose restart registry
```

### Deployment Fails

**Problem**: kubectl apply fails

**Check**:
```bash
# Check Minikube is running
minikube status

# Check kubectl connectivity
kubectl cluster-info

# Check current context
kubectl config current-context
```

**Solution**:
```bash
# Restart Minikube
minikube stop
minikube start

# Or recreate
minikube delete
minikube start --driver=docker --cpus=4 --memory=8192
```

### Rollout Timeout

**Problem**: `kubectl rollout status` times out

**Check**:
```bash
# Check pod status
kubectl get pods -l app=auth-service

# Check pod events
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

**Common causes**:
- Image pull error (ImagePullBackOff)
- Application crash (CrashLoopBackOff)
- Resource limits too low
- Health probes failing

## 📊 Post-Build Actions

### Success (`post.success`)
- Displays success message
- Shows service endpoints
- Provides next steps

### Failure (`post.failure`)
- Displays failure message
- Shows troubleshooting steps
- Lists common issues
- (Optional) Sends email notification

### Unstable (`post.unstable`)
- Indicates some tests failed
- Pipeline continued anyway

### Always (`post.always`)
- Cleans up Docker images
- Archives test results (if tests were run)
- Displays final summary

## 🎯 Best Practices

### 1. Regular Builds
- Run with `SKIP_TESTS = false` for production
- Use `SKIP_TESTS = true` only for quick iterations

### 2. Clean Builds
- Run with `CLEAN_BUILD = true` weekly
- Or when dependency issues occur

### 3. Monitor Logs
- Always check console output
- Look for warning messages
- Monitor resource usage

### 4. Health Checks
- Verify endpoints after deployment
- Check pod logs for errors
- Monitor Kubernetes events

### 5. Rollback Strategy
```bash
# If deployment fails, rollback
kubectl rollout undo deployment/auth-service
```

## 📈 Performance Optimization

### Parallel Stages
Pipeline използва parallel execution за:
- Build & Test (3 services in parallel)
- Docker Build (3 images in parallel)
- Push to Registry (3 images in parallel)

**Time saved**: ~60-70% compared to sequential execution

### Maven Cache
- Uses `.m2/repository` for caching
- Speeds up dependency downloads
- Clean with `CLEAN_BUILD = true` if needed

### Docker Layer Caching
- Multi-stage builds cache dependencies
- Only rebuilds changed layers
- Use `docker build --no-cache` if issues occur

## 🔐 Security Considerations

### Credentials
- Store sensitive data in Jenkins Credentials
- Use environment variables, not hardcoded values
- Never commit passwords to Git

### Registry Access
- Local registry has no auth (development only)
- For production, enable authentication

### Kubernetes Access
- Use kubeconfig file
- Store as Jenkins Secret File credential
- Limit permissions (RBAC)

## 📚 Additional Resources

- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Kubernetes Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Maven Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)

## 🎓 Next Steps

1. **Customize Pipeline**:
   - Add SonarQube scanning stage
   - Add security scanning (Trivy, Snyk)
   - Add performance tests
   - Add integration tests

2. **Notifications**:
   - Configure email notifications
   - Add Slack integration
   - Send metrics to monitoring system

3. **Advanced Features**:
   - Implement blue-green deployments
   - Add canary deployments
   - Implement automatic rollback
   - Add approval gates

---

**For more information, see**: [jenkins/README.md](README.md)

**For full documentation, see**: [../README.md](../README.md)

