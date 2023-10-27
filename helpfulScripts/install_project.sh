#!/bin/bash

# Функция для определения версии последнего релиза из локального репозитория
function get_latest_release {
    repo_url="$1"
    
    # Клонируем репозиторий во временную директорию
    temp_dir=$(mktemp -d)
    git clone "$repo_url" "$temp_dir"
    
    # Переходим в директорию репозитория
    cd "$temp_dir"
    
    # Получаем список тегов
    git fetch --tags
    
    # Извлекаем версию последнего релиза из тегов
    latest_release_version=$(git tag -l | grep -Eo "v[0-9]*\.[0-9]*\.[0-9]*" | sort -V | tail -n 1)
    
    # Удаляем временную директорию
    rm -rf "$temp_dir"
    
    echo "$latest_release_version"
}

# Получение URL репозитория от пользователя
read -p "Введите URL репозитория проекта (например, https://github.com/umee-network/umee.git): " repo_url

# Определение версии последнего релиза
latest_release=$(get_latest_release "$repo_url")

if [ -n "$latest_release" ]; then
    echo "Последний релиз: $latest_release"
else
    echo "Не удалось определить версию последнего релиза. Проверьте URL репозитория и доступность тегов."
fi
