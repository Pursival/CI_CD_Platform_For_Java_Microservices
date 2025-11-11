# Jenkins CI/CD Setup

This directory contains the Jenkins configuration and Docker Compose setup for the CI/CD platform.

## Components

### 1. Jenkins Server
- **Port**: 8080
- **Purpose**: CI/CD automation server
- **Access**: http://localhost:8080

### 2. Docker Registry
- **Port**: 5000
- **Purpose**: Local Docker image storage
- **URL**: localhost:5000

### 3. Registry UI
- **Port**: 8081
- **Purpose**: Web interface for Docker registry
- **Access**: http://localhost:8081

### 4. SonarQube (Optional)
- **Port**: 9000
- **Purpose**: Code quality analysis
- **Access**: http://localhost:9000
- **Credentials**: admin/admin (first login)

## Quick Start

### 1. Start Infrastructure

```bash
cd jenkins
docker-compose up -d
```

### 2. Get Jenkins Initial Password

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### 3. Setup Jenkins

1. Open http://localhost:8080
2. Enter the initial admin password
3. Install suggested plugins
4. Create admin user

### 4. Install Required Jenkins Plugins

Go to **Manage Jenkins → Manage Plugins → Available** and install:
- Docker Pipeline
- Kubernetes CLI
- Pipeline
- Git
- Maven Integration

### 5. Configure Jenkins Tools

Go to **Manage Jenkins → Global Tool Configuration**:

**Maven:**
- Name: `Maven 3.9`
- Install automatically: ✓
- Version: 3.9.5

**JDK:**
- Name: `JDK17`
- Install automatically: ✓
- Or set JAVA_HOME to `/opt/java/openjdk`

**Docker:**
- Name: `Docker`
- Install automatically: ✓

### 6. Create Jenkins Pipeline

1. Click **New Item**
2. Name: `Microservices-CI-CD-Pipeline`
3. Type: **Pipeline**
4. Pipeline Definition: **Pipeline script from SCM**
5. SCM: **Git**
6. Repository URL: (your Git repository URL or local path)
7. Script Path: `jenkins/Jenkinsfile`
8. Save

### 7. Configure Kubernetes Access

**Option 1: Using kubeconfig**
```bash
# Copy your kubeconfig
cat ~/.kube/config

# In Jenkins: Manage Jenkins → Manage Credentials → Add Credentials
# Kind: Secret file
# File: Upload your kubeconfig
# ID: kubeconfig
```

**Option 2: Direct kubectl access** (Jenkins already has access if running on same machine)

## Jenkins Pipeline

The `Jenkinsfile` automates:

1. **Checkout**: Pull code from Git
2. **Build**: Run `mvn clean package` for all services
3. **Test**: Execute JUnit tests
4. **Docker Build**: Create Docker images
5. **Push**: Push images to local registry (localhost:5000)
6. **Deploy**: Deploy to Minikube using `kubectl apply`
7. **Verify**: Check deployment status

### Pipeline Parameters

- **SERVICE**: Select which service to build (`all`, `auth-service`, `payment-service`, `balance-service`)
- **SKIP_TESTS**: Skip unit tests for faster builds
- **DEPLOY_TO_K8S**: Deploy to Kubernetes after build

## Running the Pipeline

### Manual Trigger

1. Open Jenkins dashboard
2. Click on your pipeline job
3. Click **Build with Parameters**
4. Select options:
   - SERVICE: `all`
   - SKIP_TESTS: `false`
   - DEPLOY_TO_K8S: `true`
5. Click **Build**

### Automatic Trigger (Optional)

Configure webhook or polling:
- **Build Triggers** → Poll SCM: `H/5 * * * *` (every 5 minutes)

## Monitoring

### Jenkins Logs
```bash
docker logs -f jenkins
```

### Registry Images
```bash
# List images in local registry
curl http://localhost:5000/v2/_catalog

# Or use Registry UI
# Open http://localhost:8081
```

### SonarQube Analysis
1. Open http://localhost:9000
2. Login: admin/admin
3. Create project
4. Add SonarQube stage to Jenkinsfile

## Troubleshooting

### Jenkins can't access Docker

**Problem**: `Cannot connect to the Docker daemon`

**Solution**:
```bash
# Check Docker socket is mounted
docker exec jenkins ls -l /var/run/docker.sock

# If not accessible, restart Jenkins
docker-compose restart jenkins
```

### Can't push to local registry

**Problem**: `connection refused` to localhost:5000

**Solution**:
```bash
# Check registry is running
docker ps | grep registry

# Restart registry
docker-compose restart registry
```

### Minikube can't pull from localhost:5000

**Problem**: `Failed to pull image`

**Solution**:
```bash
# Configure insecure registry in Minikube
minikube ssh
sudo vi /etc/docker/daemon.json
# Add: {"insecure-registries": ["host.minikube.internal:5000"]}
sudo systemctl restart docker
exit

# Or use Minikube's Docker daemon
eval $(minikube docker-env)
```

## Stopping Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes
docker-compose down -v
```

## Configuration Files

- `Jenkinsfile` - Pipeline definition
- `docker-compose.yml` - Infrastructure setup
- `registry/` - Registry configuration (if needed)

## Next Steps

1. Configure Jenkins credentials
2. Setup Git repository
3. Run first pipeline build
4. Monitor in Jenkins UI
5. Access services in Minikube

## Useful Commands

```bash
# View Jenkins logs
docker logs jenkins

# View Registry logs
docker logs docker-registry

# List images in registry
curl http://localhost:5000/v2/_catalog

# Check Jenkins home
docker exec jenkins ls /var/jenkins_home

# Restart Jenkins
docker-compose restart jenkins
```

## Accessing Services After Deployment

Once the pipeline successfully deploys to Minikube:

```bash
# Get Minikube IP
minikube ip

# Test services
curl http://$(minikube ip):30081/health  # Auth Service
curl http://$(minikube ip):30082/health  # Payment Service
curl http://$(minikube ip):30083/health  # Balance Service
```

---

For more information, see the main [README.md](../README.md) in the project root.

