#!/bin/bash

# Функция для определения версий релизов
function get_latest_releases {
    repo_url="$1"
    
    # Извлекаем версии релизов, удаляем повторяющиеся версии
    releases=$(git ls-remote --tags "$repo_url" | awk -F/ '{print $NF}' | grep -Eo "v[0-9]+\.[0-9]+\.[0-9]+" | sort -V | uniq | tail -n 3)
    
    echo "$releases"
}

# Получение URL репозитория от пользователя
read -p "Введите URL репозитория проекта (например, https://github.com/umee-network/umee.git): " repo_url

# Определение версий релизов
latest_releases=$(get_latest_releases "$repo_url")

if [ -n "$latest_releases" ]; then
    echo "Последние 3 версии релизов:"
    echo "$latest_releases"
else
    echo "Не удалось определить версии релизов. Проверьте URL репозитория и доступность тегов."
fi
