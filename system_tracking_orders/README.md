# 📋 Промт проекта: "Система трекинга заказов СДЭК"

```markdown
# 📦 Система трекинга заказов СДЭК

[![Python](https://img.shields.io/badge/Python-3.10-blue.svg)](https://python.org)
[![Django](https://img.shields.io/badge/Django-5.2-green.svg)](https://djangoproject.com)
[![Docker](https://img.shields.io/badge/Docker-enabled-blue.svg)](https://docker.com)
[![License](https://img.shields.io/badge/License-Private-gray.svg)]()

> Готовая система отслеживания посылок СДЭК с веб-интерфейсом и REST API. 
> Парсинг статусов без API-ключей, адаптивный дизайн, интеграция через API.

---

## 🎯 Назначение проекта

Система позволяет:
- 🔍 Отслеживать посылки СДЭК по трек-номеру
- 📊 Просматривать историю перемещений и текущий статус
- 🔌 Интегрироваться с внешними системами через REST API
- 👨‍💼 Управлять заказами через админ-панель Django
- 📱 Использовать на мобильных устройствах (адаптивный дизайн)

---

## 🛠 Технологический стек

### Backend
| Компонент | Версия | Назначение |
|-----------|--------|------------|
| Python | 3.10 | Язык программирования |
| Django | 5.2 | Web-фреймворк |
| Django REST Framework | 3.14+ | API endpoints |
| PostgreSQL | 15 | База данных |
| Gunicorn | 21.2+ | WSGI-сервер |
| python-dotenv | 1.0+ | Управление переменными окружения |

### Frontend
| Компонент | Назначение |
|-----------|------------|
| HTML5 + CSS3 | Шаблоны и стили |
| Ванильный JS | Интерактивность без зависимостей |
| Адаптивная вёрстка | Поддержка мобильных устройств |

### Инфраструктура
| Компонент | Назначение |
|-----------|------------|
| Docker + Compose | Контейнеризация и оркестрация |
| Nginx | Reverse proxy, статика, Basic Auth |
| Ubuntu 22.04 LTS | Операционная система |
| systemd | Управление сервисами |

### Зависимости
```txt
# requirements.txt
Django>=5.2,<5.3
djangorestframework>=3.14,<3.15
psycopg2-binary>=2.9,<2.10
python-dotenv>=1.0,<1.1
beautifulsoup4>=4.12,<4.13
requests>=2.31,<2.32
gunicorn>=21.2,<22.0
whitenoise>=6.6,<6.7
```

---

## 📁 Структура проекта

```
/var/www/system_tracking_orders/
├── 📁 docker/                    # Docker-конфигурации
│   ├── Dockerfile                # Образ приложения
│   ├── docker-compose.yml        # Оркестрация сервисов
│   ├── entrypoint.sh            # Скрипт инициализации
│   ├── .dockerignore            # Исключения для сборки
│   └── 📁 nginx/
│       ├── nginx.conf           # Конфигурация Nginx
│       └── .htpasswd.example    # Шаблон Basic Auth
│
├── 📁 config/                    # Настройки Django
│   ├── __init__.py
│   ├── settings.py              # Основные настройки (PostgreSQL, DRF)
│   ├── urls.py                  # Корневые маршруты
│   └── wsgi.py                  # WSGI entrypoint
│
├── 📁 tracking/                  # Основное приложение
│   ├── 📁 services/
│   │   ├── __init__.py
│   │   └── simple_tracker.py    # Парсер сайта СДЭК
│   ├── 📁 templates/tracking/
│   │   ├── base.html            # Базовый шаблон
│   │   └── track.html           # Страница отслеживания
│   ├── 📁 migrations/           # Миграции БД
│   ├── admin.py                 # Настройки админки
│   ├── apps.py                  # Конфигурация приложения
│   ├── models.py                # Модели данных
│   ├── urls.py                  # Маршруты приложения
│   ├── views.py                 # Контроллеры
│   └── tests.py                 # Тесты
│
├── 📁 static/                    # Статические файлы (collectstatic)
├── 📁 media/                     # Пользовательские файлы
├── 📁 logs/nginx/                # Логи Nginx
│
├── .env                          # Переменные окружения (НЕ в Git!)
├── .env.example                  # Шаблон переменных (в Git)
├── .gitignore                    # Исключения для Git
├── manage.py                     # Django management script
├── requirements.txt              # Python-зависимости
└── README.md                     # Этот файл
```

---

## ⚙️ Функционал

### 🔍 Отслеживание посылок
- Форма поиска на главной странице
- Валидация трек-номера (мин. 8 символов)
- Отображение текущего статуса с цветовой индикацией
- История перемещений с датами и локациями
- Индикатор "Доставлено" для завершённых заказов

### 🔌 REST API
```http
GET /api/track/?track={TRACK_NUMBER}
```

**Ответ (успех):**
```json
{
  "track_number": "1234567890",
  "status": "Доставлен",
  "delivered": true,
  "history": [
    {
      "timestamp": "2024-03-10T14:30:00",
      "status": "Прибыло в сортировочный центр",
      "location": "Москва"
    }
  ]
}
```

**Ответ (ошибка):**
```json
{
  "error": "Посылка не найдена"
}
```

### 👨‍💼 Админ-панель Django
- CRUD для заказов (трек-номер, статус, дата)
- Просмотр истории статусов каждой посылки
- Массовые действия: отметить доставленным, обновить статус
- Фильтрация и поиск по трек-номерам
- Экспорт данных (через django-import-export при необходимости)

### 🔧 Системные endpoints
| Endpoint | Метод | Описание |
|----------|-------|----------|
| `/test/` | GET | Проверка работоспособности (health check) |
| `/debug/` | GET | Отладка URL-маршрутов (разработка) |
| `/admin/` | GET | Админ-панель (защищено Basic Auth) |
| `/static/` | GET | Статические файлы (кеширование 30 дней) |

---

## 🗄️ Модели данных

### Order (Заказ)
```python
class Order(models.Model):
    track_number = CharField(max_length=50, unique=True)  # Трек-номер
    status = CharField(max_length=100, blank=True)         # Текущий статус
    delivered = BooleanField(default=False)                # Доставлен ли
    created_at = DateTimeField(auto_now_add=True)          # Дата создания
    updated_at = DateTimeField(auto_now=True)              # Дата обновления
```

### StatusHistory (История статусов)
```python
class StatusHistory(models.Model):
    order = ForeignKey(Order, on_delete=CASCADE)           # Связь с заказом
    status = CharField(max_length=200)                      # Текст статуса
    location = CharField(max_length=200, blank=True)       # Местоположение
    timestamp = DateTimeField()                             # Время события
    created_at = DateTimeField(auto_now_add=True)           # Дата записи
```

---

## 🐳 Развёртывание (Docker)

### Предварительные требования
- ✅ Ubuntu 22.04 LTS
- ✅ Docker Engine 24+
- ✅ Docker Compose Plugin
- ✅ Домен, направленный на сервер (опционально)

### Быстрый старт

```bash
# 1. Клонировать репозиторий
git clone https://github.com/cubinez85/tracking-orders.git
cd tracking-orders

# 2. Настроить окружение
cp .env.example .env
nano .env  # ← заполнить пароли и настройки

# 3. Создать пароль для админки
htpasswd -c docker/nginx/.htpasswd admin

# 4. Запустить контейнеры
docker compose -f docker/docker-compose.yml up -d --build

# 5. Проверить работу
curl http://localhost/test/
```

### Переменные окружения (.env)

```env
# ===== Django =====
SECRET_KEY=your-secret-key-change-in-prod
DEBUG=False
ALLOWED_HOSTS=tracking-orders.cubinez.ru,localhost,127.0.0.1,web

# ===== Database =====
DB_NAME=orders_db
DB_USER=user_orders
DB_PASSWORD=your-secure-password
DB_HOST=db
DB_PORT=5432

# ===== Superuser (опционально) =====
CREATE_SUPERUSER=true
DJANGO_SUPERUSER_USERNAME=admin
DJANGO_SUPERUSER_EMAIL=admin@example.com
DJANGO_SUPERUSER_PASSWORD=change-me

# ===== Gunicorn =====
GUNICORN_WORKERS=3
```

### Управление контейнерами

```bash
# Просмотр статуса
docker compose -f docker/docker-compose.yml ps

# Логи в реальном времени
docker compose -f docker/docker-compose.yml logs -f web
docker compose -f docker/docker-compose.yml logs -f nginx

# Перезапуск сервиса
docker compose -f docker/docker-compose.yml restart web

# Применение миграций вручную
docker compose -f docker/docker-compose.yml exec web python manage.py migrate

# Создание суперпользователя
docker compose -f docker/docker-compose.yml exec web python manage.py createsuperuser

# Бэкап базы данных
docker compose -f docker/docker-compose.yml exec db pg_dump -U $DB_USER $DB_NAME > backup.sql

# Остановка
docker compose -f docker/docker-compose.yml down

# Обновление образа
docker compose -f docker/docker-compose.yml pull
docker compose -f docker/docker-compose.yml up -d --build
```

---

## 🔐 Безопасность

### Обязательные настройки для продакшена
- [ ] `DEBUG=False` в `.env`
- [ ] Уникальный `SECRET_KEY` (мин. 50 символов)
- [ ] `ALLOWED_HOSTS` с конкретными доменами
- [ ] Сложные пароли для БД и суперпользователя
- [ ] Файл `.env` добавлен в `.gitignore`
- [ ] Basic Auth для `/admin/` через Nginx
- [ ] HTTPS через Let's Encrypt (рекомендуется)

### Защита от уязвимостей
- ✅ Валидация входных данных (трек-номер)
- ✅ Защита от CSRF (Django middleware)
- ✅ SQL-инъекции (ORM Django)
- ✅ XSS (авто-экранирование шаблонов)
- ✅ Rate limiting (на уровне Nginx при необходимости)

---

## 🧪 Тестирование

### Проверка работоспособности
```bash
# Health check
curl -s http://localhost/test/ | jq

# Веб-интерфейс
curl -s -o /dev/null -w "%{http_code}\n" http://localhost/

# API с трек-номером
curl -s "http://localhost/api/track/?track=TEST123" | jq

# Админка (должен быть 401 без авторизации)
curl -s -o /dev/null -w "%{http_code}\n" http://localhost/admin/

# Админка с авторизацией
curl -s -u admin:password -o /dev/null -w "%{http_code}\n" http://localhost/admin/
```

### Запуск тестов Django
```bash
docker compose -f docker/docker-compose.yml exec web python manage.py test tracking
```

---

## 🔄 Обновление проекта

```bash
# 1. Получить изменения из репозитория
cd /var/www/system_tracking_orders
git pull

# 2. Пересобрать образ и перезапустить
docker compose -f docker/docker-compose.yml up -d --build

# 3. Применить миграции (если есть)
docker compose -f docker/docker-compose.yml exec web python manage.py migrate

# 4. Проверить логи
docker compose -f docker/docker-compose.yml logs -f --tail=50 web
```

---

## 📊 Мониторинг и логи

### Логи
| Сервис | Путь к логам |
|--------|-------------|
| Nginx access | `/var/www/system_tracking_orders/logs/nginx/access.log` |
| Nginx error | `/var/www/system_tracking_orders/logs/nginx/error.log` |
| Django/Gunicorn | `docker compose logs -f web` |
| PostgreSQL | `docker compose logs -f db` |

### Быстрая диагностика
```bash
# Статус всех сервисов
docker compose -f docker/docker-compose.yml ps

# Проверка подключения к БД
docker compose -f docker/docker-compose.yml exec web python manage.py shell -c "
from django.db import connection
connection.ensure_connection()
print('✅ DB connected')
"

# Проверка миграций
docker compose -f docker/docker-compose.yml exec web python manage.py showmigrations

# Проверка статики
curl -sI http://localhost/static/admin/css/base.css | grep -i cache
```

---

## 🚨 Устранение проблем

| Проблема | Решение |
|----------|---------|
| **Порт 80 занят** | `sudo systemctl stop nginx && sudo systemctl disable nginx` |
| **БД не подключается** | Проверить `DB_HOST=db` в `.env` и healthcheck в compose |
| **Nginx 502 Bad Gateway** | Убедиться, что Gunicorn слушает `0.0.0.0:8000` |
| **Статика не грузится** | Выполнить `collectstatic` и проверить volumes |
| **Basic Auth не работает** | Проверить путь к `.htpasswd` в nginx.conf |
| **Миграции не применяются** | Запустить вручную: `python manage.py migrate` |

### Сброс БД (только для разработки!)
```bash
docker compose -f docker/docker-compose.yml down -v  # ⚠️ Удалит все данные!
docker compose -f docker/docker-compose.yml up -d --build
```

---

## 📈 Масштабирование

### Горизонтальное масштабирование web
```yaml
# В docker-compose.yml
services:
  web:
    deploy:
      replicas: 3  # Количество инстансов
    # ... остальные настройки
```

### Оптимизация Gunicorn
```bash
# В entrypoint.sh или env
GUNICORN_WORKERS=3  # CPU cores × 2 + 1
GUNICORN_TIMEOUT=120  # Таймаут для долгих запросов парсинга
```

### Кеширование
```python
# В settings.py для продакшена
CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.locmem.LocMemCache',
        'LOCATION': 'tracking-cache',
        'TIMEOUT': 300,  # 5 минут кеширования ответов парсинга
    }
}
```

---

## 🤝 Вклад в проект

```bash
# 1. Форкнуть репозиторий
# 2. Создать ветку для фичи
git checkout -b feature/your-feature-name

# 3. Внести изменения и протестировать
# 4. Закоммитить с понятным сообщением
git commit -m "feat: добавить валидацию трек-номера"

# 5. Отправить пул-реквест
git push origin feature/your-feature-name
```

### Стандарты кода
- ✅ PEP 8 для Python
- ✅ Типизация через type hints (Python 3.10+)
- ✅ Докстринги для публичных функций
- ✅ Логи вместо print() в продакшен-коде

---

## 📄 Лицензия

Проект является частной разработкой.  
Использование, копирование или распространение без разрешения запрещено.

---

## 👥 Контакты

- **Разработчик**: Олег Медведев
- **Email**: cubinez85@cubinez.ru
- **Репозиторий**: https://github.com/cubinez85/tracking-orders

---

> 💡 **Совет**: Всегда делайте бэкап БД перед обновлением:
> ```bash
> docker compose exec db pg_dump -U user_orders orders_db > backup_$(date +%Y%m%d).sql
> ```

🚀 *Проект готов к использованию в продакшене!*
```

---

## 🎯 Как использовать этот промт

1. **Для документации**: Сохраните как `README.md` в корне репозитория
2. **Для онбординга**: Отправьте новому разработчику для быстрого старта
3. **Для ТЗ**: Используйте как основу для постановки задач
4. **Для деплоя**: Следуйте разделу "Развёртывание" пошагово
5. **Для поддержки**: Раздел "Устранение проблем" поможет быстро диагностировать ошибки

Нужно добавить разделы по конкретным аспектам (CI/CD, мониторинг, расширенный функционал)? 🛠️
