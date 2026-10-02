# Отчёт — Jenkins REST API

## 1. Цель
Настроить авторизацию Jenkins по API token, выполнить REST API POST-запрос
с параметрами и подтвердить его обработку на стороне Jenkins.

## 2. API token
В профиле Jenkins создан API token пользователя. Токен используется вместо
пароля при обращении к REST API.

**Скриншот 1:** создание API token (сам токен скрыть).

## 3. Параметрическая задача
Создан Pipeline `jenkins-rest-api`.

Параметры:
- `MESSAGE` — String;
- `ENVIRONMENT` — Choice: test/stage/prod;
- `DEBUG` — Boolean.

**Скриншот 2:** настройки параметров.

## 4. REST API
Используется:
```text
POST /job/jenkins-rest-api/buildWithParameters
```
В запрос передаются `MESSAGE`, `ENVIRONMENT`, `DEBUG`.
Для POST сначала получается CSRF crumb:
```text
GET /crumbIssuer/api/json
```

**Скриншот 3:** PowerShell с успешным запросом.

## 5. Проверка на стороне Jenkins
В Console Output:
```text
MESSAGE=REST API test
ENVIRONMENT=test
DEBUG=true
```

**Скриншот 4:** Console Output.

## 6. Pipeline
Pipeline получает значения через:
```groovy
params.MESSAGE
params.ENVIRONMENT
params.DEBUG
```

**Скриншот 5:** успешный Pipeline.

## 7. Вывод
REST API Jenkins настроен: пользователь авторизуется по API token, POST-запрос
передаёт параметры в параметрическую задачу, Jenkins создаёт сборку и
обрабатывает переданные значения.

API token не публикуется в репозитории.
