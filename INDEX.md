# 📚 Навигация на документацията

Добре дошли в CI/CD Platform за Java Микросървиси! Изберете документ според вашите нужди:

## 🎯 За начинаещи

### [QUICKSTART.md](QUICKSTART.md) - Започнете от тук!
Бърз старт гид с 5 стъпки за стартиране на платформата.

**Идеално за**: Първо стартиране, бързо тестване  
**Време за четене**: 5 минути  
**Време за изпълнение**: 20-30 минути

---

## 📖 Основна документация

### [README.md](README.md) - Пълно ръководство
Подробна документация с всички инструкции, команди и обяснения.

**Идеално за**: Разбиране на всички аспекти на проекта  
**Време за четене**: 30-45 минути  
**Съдържание**:
- Подробни инсталационни инструкции
- Стъпка-по-стъпка setup
- Troubleshooting секция
- Monitoring и logging
- Update и rollback процедури

---

## 🪟 За Windows потребители

### [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md) - Windows специфично ръководство
Специални инструкции и PowerShell скриптове за Windows среда.

**Идеално за**: Windows 10/11 потребители  
**Време за четене**: 15-20 минути  
**Съдържание**:
- Windows-специфични инструкции
- PowerShell скриптове
- Docker Desktop конфигурация
- WSL2 интеграция
- Windows troubleshooting
- PowerShell команди

---

## 🏗️ Техническа документация

### [ARCHITECTURE.md](ARCHITECTURE.md) - Архитектура на системата
Детайлна архитектурна документация, data flows и best practices.

**Идеално за**: Разработчици, архитекти, DevOps инженери  
**Време за четене**: 20-30 минути  
**Съдържание**:
- Система overview
- Компоненти и взаимовръзки
- CI/CD pipeline детайли
- Network архитектура
- Security considerations
- Scalability patterns
- Production recommendations

---

## 📁 Структура на проекта

### [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) - Файлова структура
Подробно описание на всички файлове и директории в проекта.

**Идеално за**: Навигация в кода, разбиране на организацията  
**Време за четене**: 10-15 минути  
**Съдържание**:
- Дърво на директориите
- Описание на всеки файл
- Naming conventions
- Dependencies между файлове
- Локации на artifacts

---

## 📊 Преглед на проекта

### [SUMMARY.md](SUMMARY.md) - Executive Summary
Кратък преглед на това какво е създадено и какви са възможностите.

**Идеално за**: Management, презентации, portfolio  
**Време за четене**: 5-10 минути  
**Съдържание**:
- Списък на компонентите
- Статистика на проекта
- Функционалности
- Technology stack
- Success criteria

---

## 📜 Лиценз

### [LICENSE](LICENSE) - MIT License
Open source лиценз за свободна употреба.

---

## 🗂️ Бърза навигация по теми

### По компоненти

| Компонент | Документация | Код |
|-----------|--------------|-----|
| **Auth Service** | [README.md#auth-service](README.md#auth-service-port-8081--nodeport-30081) | `microservices/auth-service/` |
| **Payment Service** | [README.md#payment-service](README.md#payment-service-port-8082--nodeport-30082) | `microservices/payment-service/` |
| **Balance Service** | [README.md#balance-service](README.md#balance-service-port-8083--nodeport-30083) | `microservices/balance-service/` |
| **Jenkins Pipeline** | [README.md#jenkins-pipeline](README.md#опция-2-използване-на-jenkins-pipeline) | `Jenkinsfile` |
| **Kubernetes** | [README.md#kubernetes-deployment](README.md#kubernetes-deployment) | `kubernetes/` |
| **Docker Compose** | [README.md#docker-compose](README.md#стъпка-2-стартиране-на-jenkins-и-docker-registry) | `docker-compose.yml` |

### По задачи

| Искам да... | Вижте |
|-------------|-------|
| Стартирам всичко бързо | [QUICKSTART.md](QUICKSTART.md) |
| Стартирам на Windows | [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md) |
| Разбера архитектурата | [ARCHITECTURE.md](ARCHITECTURE.md) |
| Намеря конкретен файл | [PROJECT_STRUCTURE.md](PROJECT_STRUCTURE.md) |
| Решавам проблем | [README.md#troubleshooting](README.md#-troubleshooting) |
| Тествам services | [README.md#тестване](README.md#-тестване) |
| Актуализирам service | [README.md#актуализация-на-services](README.md#-актуализация-на-services) |
| Мониторирам системата | [README.md#мониторинг-и-логове](README.md#-мониторинг-и-логове) |
| Cleanup на ресурси | [README.md#cleanup](README.md#-cleanup) |

---

## 🛠️ Scripts и инструменти

### Bash Scripts (Linux/macOS)

| Script | Цел | Документация |
|--------|-----|--------------|
| `setup-minikube.sh` | Инициализация на Minikube | [README.md](README.md#стъпка-1-стартиране-на-minikube) |
| `setup-jenkins.sh` | Jenkins setup помощник | [README.md](README.md#стъпка-3-конфигуриране-на-jenkins) |
| `deploy-all.sh` | Build и deploy всички services | [README.md](README.md#опция-1-ръчен-build-и-deploy-за-тестване) |
| `test-services.sh` | Тестване на endpoints | [README.md](README.md#integration-тестове) |
| `check-status.sh` | Проверка на статус | [README.md](README.md#проверка-на-статус) |
| `cleanup.sh` | Изчистване на deployments | [README.md](README.md#изтриване-на-kubernetes-deployments) |

### PowerShell Scripts (Windows)

| Script | Цел | Документация |
|--------|-----|--------------|
| `setup-minikube.ps1` | Инициализация на Minikube | [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md#стъпка-3-стартиране-на-minikube) |
| `deploy-all.ps1` | Build и deploy всички services | [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md#стъпка-5-build-и-deploy) |
| `test-services.ps1` | Тестване на endpoints | [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md#стъпка-6-тестване) |
| `check-status.ps1` | Проверка на статус | [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md#стъпка-6-тестване) |
| `cleanup.ps1` | Изчистване на deployments | [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md#daily-workflow-windows) |

---

## 🎓 Learning Path

### Ниво 1: Beginner
1. Прочетете [QUICKSTART.md](QUICKSTART.md)
2. Стартирайте платформата
3. Тествайте endpoints
4. Разгледайте Jenkins UI

### Ниво 2: Intermediate
1. Прочетете [README.md](README.md)
2. Стартирайте Jenkins pipeline
3. Модифицирайте един service
4. Направете deploy на промените

### Ниво 3: Advanced
1. Прочетете [ARCHITECTURE.md](ARCHITECTURE.md)
2. Добавете нов микросървис
3. Имплементирайте нов feature
4. Оптимизирайте pipeline

---

## 🔗 Външни ресурси

### Official Documentation
- [Spring Boot Documentation](https://spring.io/projects/spring-boot)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Maven Documentation](https://maven.apache.org/guides/)

### Tutorials
- [Spring Boot Microservices Tutorial](https://spring.io/guides/gs/microservice/)
- [Jenkins Pipeline Tutorial](https://www.jenkins.io/doc/book/pipeline/)
- [Kubernetes Tutorial](https://kubernetes.io/docs/tutorials/)

### Tools
- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [kubectl Cheat Sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- [Docker Compose](https://docs.docker.com/compose/)

---

## ❓ FAQ - Често задавани въпроси

### Къде да започна?
Започнете с [QUICKSTART.md](QUICKSTART.md) за бърз старт.

### Работи ли на Windows?
Да! Вижте [WINDOWS_GUIDE.md](WINDOWS_GUIDE.md) за Windows-специфични инструкции.

### Нужни ли са облачни услуги?
Не! Всичко работи локално без облачни зависимости.

### Колко RAM е нужен?
Минимум 8GB, препоръчително 16GB.

### Може ли да се използва за production?
Проектът е готов за production patterns, но изисква допълнителна конфигурация (security, persistence, monitoring). Вижте [ARCHITECTURE.md#production-recommendations](ARCHITECTURE.md#production-recommendations).

### Как да добавя нов микросървис?
Вижте [PROJECT_STRUCTURE.md#to-add-a-new-microservice](PROJECT_STRUCTURE.md#to-add-a-new-microservice).

### Как да решавам проблеми?
Вижте [README.md#troubleshooting](README.md#-troubleshooting) или [WINDOWS_GUIDE.md#windows-specific-troubleshooting](WINDOWS_GUIDE.md#-windows-specific-troubleshooting) за Windows.

---

## 📞 Support

### Имате въпрос?
1. Проверете [README.md#troubleshooting](README.md#-troubleshooting)
2. Прегледайте FAQ секцията по-горе
3. Създайте GitHub Issue

### Искате да допринесете?
1. Fork на проекта
2. Създайте branch за вашия feature
3. Commit промените
4. Създайте Pull Request

---

## 🎯 Quick Links

### Start Here
- 🚀 [Quick Start](QUICKSTART.md)
- 🪟 [Windows Guide](WINDOWS_GUIDE.md)

### Main Documentation
- 📖 [Full README](README.md)
- 🏗️ [Architecture](ARCHITECTURE.md)

### Reference
- 📁 [Project Structure](PROJECT_STRUCTURE.md)
- 📊 [Summary](SUMMARY.md)
- 📜 [License](LICENSE)

---

## 📌 Version Info

- **Project Version**: 1.0.0
- **Java**: 17
- **Spring Boot**: 3.1.5
- **Kubernetes**: 1.27+
- **Docker**: 20.10+
- **Last Updated**: 2024

---

**Готови ли сте да започнете? Отидете на [QUICKSTART.md](QUICKSTART.md)! 🚀**

