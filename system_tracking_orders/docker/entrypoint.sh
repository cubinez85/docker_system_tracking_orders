#!/bin/bash
set -e

echo "🔄 Ожидание PostgreSQL..."
until python manage.py inspectdb --database default > /dev/null 2>&1; do
    echo "⏳ PostgreSQL пока недоступен, повтор через 2 сек..."
    sleep 2
done

echo "🗄️ Применение миграций..."
python manage.py migrate --noinput

echo "📦 Сбор статических файлов..."
python manage.py collectstatic --noinput --clear

if [ "$CREATE_SUPERUSER" = "true" ] && [ -n "$DJANGO_SUPERUSER_USERNAME" ]; then
    echo "👤 Создание суперпользователя..."
    python manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='$DJANGO_SUPERUSER_USERNAME').exists():
    User.objects.create_superuser(
        username='$DJANGO_SUPERUSER_USERNAME',
        email='$DJANGO_SUPERUSER_EMAIL',
        password='$DJANGO_SUPERUSER_PASSWORD'
    )
"
fi

echo "🚀 Запуск Gunicorn..."
exec gunicorn config.wsgi:application \
    --workers 3 \
    --bind 0.0.0.0:8000 \
    --access-logfile - \
    --error-logfile -
