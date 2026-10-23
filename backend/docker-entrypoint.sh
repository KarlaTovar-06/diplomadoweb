#!/bin/sh
set -e

echo "[backend] Esperando a MariaDB en ${DB_HOST}:${DB_PORT}..."
until php -r 'new PDO("mysql:host=".getenv("DB_HOST").";port=".getenv("DB_PORT").";dbname=".getenv("DB_DATABASE"), getenv("DB_USERNAME"), getenv("DB_PASSWORD"));' 2>/dev/null; do
    sleep 2
done
echo "[backend] Base de datos disponible."

php artisan config:clear

echo "[backend] Ejecutando migraciones..."
php artisan migrate --force

if [ "${SEED_DATABASE:-true}" = "true" ]; then
    PROYECTOS=$(php artisan tinker --execute='echo \App\Models\Proyecto::count();' 2>/dev/null | tr -dc '0-9')
    if [ -z "${PROYECTOS}" ] || [ "${PROYECTOS}" = "0" ]; then
        echo "[backend] Cargando datos de ejemplo..."
        php artisan db:seed --force
    else
        echo "[backend] La base ya tiene datos, no se vuelve a sembrar."
    fi
fi

exec "$@"
