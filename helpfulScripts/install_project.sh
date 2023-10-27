#!/bin/bash

# Функция для определения последнего релиза по URL репозитория
function get_latest_release {
    repo_url="$1"
    
    # Используем GitHub API для получения информации о релизах
    releases_json=$(curl -s "https://api.github.com/repos${repo_url}/releases")
    
    # Извлекаем версию последнего релиза без jq
    latest_release_version=$(echo "$releases_json" | grep -o '"tag_name": "[^"]*' | grep -o '[^"]*$' | head -n 1)
    
    echo "$latest_release_version"
}

# Получение URL репозитория от пользователя
read -p "Введите URL репозитория проекта (например, https://github.com/umee-network/umee.git): " repo_url

# Определение последнего релиза
latest_release=$(get_latest_release "$repo_url")

if [ -n "$latest_release" ]; then
    echo "Последний релиз: $latest_release"
else
    echo "Не удалось определить версию последнего релиза. Проверьте URL репозитория и доступность релизов."
fi
