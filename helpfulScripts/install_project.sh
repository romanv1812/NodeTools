#!/bin/bash

# Функция для определения последней версии релиза
function get_latest_release {
    repo_url="$1"
    repo_name=$(echo "$repo_url" | awk -F/ '{print $4"/"$5}' | sed 's/.git$//')
    
    # Извлекаем последнюю версию релиза
    release=$(curl -s "https://api.github.com/repos/$repo_name/releases/latest" | jq -r .tag_name)
    
    echo "$release"
}

# Функция для получения списка ассетов последнего релиза
function get_release_assets {
    repo_url="$1"
    release_version="$2"
    repo_name=$(echo "$repo_url" | awk -F/ '{print $4"/"$5}' | sed 's/.git$//')

    # Извлекаем список ассетов
    assets=$(curl -s "https://api.github.com/repos/$repo_name/releases/tags/$release_version" | jq -r '.assets[] | .browser_download_url')
    
    echo "$assets"
}

# Функция для скачивания и установки бинарника
function install_binary {
    binary_url="$1"
    
    wget "$binary_url" -O /tmp/release.zip
    unzip /tmp/release.zip -d /tmp/
    # Предположим, что имя файла бинарника находится в имени URL
    binary_name=$(basename "$binary_url")
    mv "/tmp/$binary_name" $HOME/go/bin/
    chmod +x "$HOME/go/bin/$binary_name"
}

# Получение URL репозитория от пользователя
read -p "Введите URL репозитория проекта (например, https://github.com/umee-network/umee.git): " repo_url

# Определение последней версии релиза
latest_release=$(get_latest_release "$repo_url")

if [ -n "$latest_release" ]; then
    echo "Последняя версия релиза: $latest_release"
    assets=$(get_release_assets "$repo_url" "$latest_release")
    echo "Доступные файлы для скачивания:"
    select asset in $assets; do
        if [ -n "$asset" ]; then
            install_binary "$asset"
            break
        fi
    done
else
    echo "Не удалось определить версию релиза. Проверьте URL репозитория и доступность тегов."
fi
