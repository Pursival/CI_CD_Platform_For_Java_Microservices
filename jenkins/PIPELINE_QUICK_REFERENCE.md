# 🚀 Jenkins Pipeline - Quick Reference

## Pipeline Stages (in order)

```
1. 🔍 Initialization          → Check tools (Maven, Docker, kubectl)
2. 📥 Checkout Code           → Pull from Git
3. 🧹 Clean Workspace         → Clean Maven cache (if CLEAN_BUILD=true)
4. 🔨 Build & Test Services   → Maven build + JUnit tests (PARALLEL)
5. 🐳 Build Docker Images     → Docker build (PARALLEL)
6. 📤 Push to Registry        → Push to localhost:5000 (PARALLEL)
7. 🚀 Deploy to Minikube      → kubectl apply (SEQUENTIAL: auth→payment→balance)
8. ✅ Verify Deployment       → Check pods, services, health
9. 📊 Generate Report         → Build summary
```

## Quick Commands

### Start Pipeline
```bash
# Via Jenkins UI
http://localhost:8080 → Build with Parameters

# Via curl
curl -X POST http://localhost:8080/job/Microservices-Pipeline/buildWithParameters \
  --user admin:token \
  --data DEPLOY_ENV=minikube \
  --data SKIP_TESTS=false
```

### Monitor Build
```bash
# Watch Jenkins console
# http://localhost:8080/job/Microservices-Pipeline/<build-number>/console

# Check Kubernetes
kubectl get pods -w
```

### Verify Deployment
```bash
# Get Minikube IP
MINIKUBE_IP=$(minikube ip)

# Test endpoints
curl http://$MINIKUBE_IP:30081/health  # Auth
curl http://$MINIKUBE_IP:30082/health  # Payment
curl http://$MINIKUBE_IP:30083/health  # Balance
```

## Parameters Cheat Sheet

| Parameter | Options | Use When |
|-----------|---------|----------|
| DEPLOY_ENV | `minikube`, `all` | Always use `minikube` for local |
| SKIP_TESTS | `true`, `false` | `true` for quick iterations |
| CLEAN_BUILD | `true`, `false` | `true` if dependency issues |
| FORCE_REDEPLOY | `true`, `false` | `true` to force restart |

## Troubleshooting Quick Fixes

### Build Fails
```bash
cd services/auth-service
mvn clean install -U
```

### Docker Build Fails
```bash
docker system prune -a
docker-compose -f jenkins/docker-compose.yml restart
```

### Registry Push Fails
```bash
docker-compose -f jenkins/docker-compose.yml restart registry
```

### Deployment Fails
```bash
minikube status
kubectl cluster-info
kubectl get pods
kubectl describe pod <pod-name>
```

### Rollback
```bash
kubectl rollout undo deployment/auth-service
kubectl rollout undo deployment/payment-service
kubectl rollout undo deployment/balance-service
```

## Pipeline Output Symbols

| Symbol | Meaning |
|--------|---------|
| ✅ | Success |
| ❌ | Failure |
| ⚠️ | Warning |
| 🔍 | Info |
| 🔨 | Building |
| 🧪 | Testing |
| 🐳 | Docker |
| 📤 | Push |
| 🚀 | Deploy |

## Execution Time (Approximate)

| Configuration | Time |
|--------------|------|
| Full build (with tests) | ~8-12 min |
| Fast build (skip tests) | ~4-6 min |
| Clean build | +2-3 min |

## Common Issues

| Problem | Solution |
|---------|----------|
| Maven build fails | Try `CLEAN_BUILD=true` |
| Docker build fails | Check Docker daemon |
| Push fails | Restart registry |
| Deploy fails | Check Minikube status |
| Pods CrashLoop | Check pod logs |
| ImagePullBackOff | Check registry + Minikube config |

## Access Points After Successful Build

```
Jenkins:       http://localhost:8080
Registry UI:   http://localhost:8081
Auth API:      http://<minikube-ip>:30081
Payment API:   http://<minikube-ip>:30082
Balance API:   http://<minikube-ip>:30083
```

## Pipeline as Code

Location: `jenkins/Jenkinsfile`

Key sections:
- `environment` - Variables
- `parameters` - Build parameters
- `stages` - Pipeline stages
- `post` - Post-build actions

---

**For detailed guide, see**: [PIPELINE_GUIDE.md](PIPELINE_GUIDE.md)

