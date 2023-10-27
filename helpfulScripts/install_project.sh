#!/bin/bash

# Функция для определения версий релизов
function get_latest_releases {
    repo_url="$1"
    
    # Клонируем репозиторий во временную директорию
    temp_dir=$(mktemp -d)
    git clone "$repo_url" "$temp_dir"
    
    # Переходим в директорию репозитория
    cd "$temp_dir"
    
    # Получаем список тегов
    git fetch --tags
    
    # Извлекаем версии релизов из тегов
    latest_releases=$(git tag -l | grep -Eo "v[0-9]*\.[0-9]*\.[0-9]*" | sort -V | tail -n 5)
    
    # Удаляем временную директорию
    rm -rf "$temp_dir"
    
    echo "$latest_releases"
}

# Получение URL репозитория от пользователя
read -p "Введите URL репозитория проекта (например, https://github.com/umee-network/umee.git): " repo_url

# Определение версий релизов
latest_releases=$(get_latest_releases "$repo_url")

if [ -n "$latest_releases" ]; then
    echo "Последние версии релизов:"
    echo "$latest_releases"
else
    echo "Не удалось определить версии релизов. Проверьте URL репозитория и доступность тегов."
fi
