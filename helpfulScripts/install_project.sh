#!/bin/bash

# Функция для определения версий релизов
function get_latest_releases {
    repo_url="$1"
    
    # Используем предоставленный код для определения версий
    TAGS=$(wget -qO- "https://api.github.com/repos${repo_url}/releases" | jq '.[] | select(.prerelease==false) | select(.draft==false) | .html_url' | grep -Eo "v[0-9]*\.[0-9]*\.[0-9]*")
    
    echo "$TAGS"
}

# Получение URL репозитория от пользователя
read -p "Введите URL репозитория проекта (например, https://github.com/umee-network/umee.git): " repo_url

# Определение версий релизов
latest_releases=$(get_latest_releases "$repo_url")

if [ -n "$latest_releases" ]; then
    echo "Последние версии релизов:"
    echo "$latest_releases"
else
    echo "Не удалось определить версии релизов. Проверьте URL репозитория и доступность релизов."
fi
