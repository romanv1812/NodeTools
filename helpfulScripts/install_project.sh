#!/bin/bash

# Функция для определения последних 5 версий релизов
function get_latest_releases {
    repo_url="$1"
    
    # Используем GitHub API для получения информации о релизах
    releases_json=$(curl -s "https://api.github.com/repos${repo_url}/releases")
    
    # Извлекаем версии последних 5 релизов
    latest_releases=$(echo "$releases_json" | jq -r '.[].tag_name' | head -n 5)
    
    echo "$latest_releases"
}

# Получение URL репозитория от пользователя
read -p "Введите URL репозитория проекта (например, https://github.com/umee-network/umee.git): " repo_url

# Определение последних 5 версий релизов
latest_releases=$(get_latest_releases "$repo_url")

if [ -n "$latest_releases" ]; then
    echo "Последние 5 версий релизов:"
    echo "$latest_releases"
else
    echo "Не удалось определить версии последних релизов. Проверьте URL репозитория и доступность релизов."
fi
