#!/bin/bash

function ask_for_repo {
    read -p "Введите URL репозитория проекта: " repo_url
}

# Функция для выбора версии релиза
function select_release {
    # Получение списка доступных версий
    releases=$(curl -s "${repo_url}/releases" | grep -o '"tag_name": "[^"]*' | grep -o '[^"]*$')
    
    # Вывод списка версий
    echo "Доступные версии релиза:"
    select version in $releases "Выбрать другую версию"; do
        if [ "$version" == "Выбрать другую версию" ]; then
            return 1
        elif [ -n "$version" ]; then
            selected_version="$version"
            return 0
        else
            echo "Пожалуйста, выберите версию из списка."
        fi
    done
}

# Запрос репозитория проекта
ask_for_repo

# Запрос пользователя о версии релиза
while true; do
    select_release
    if [ $? -eq 0 ]; then
        break
    fi
done

echo "Выбранная версия: $selected_version"
read -p "Установить эту версию? (y/n): " install_version

if [[ "$install_version" == "y" || "$install_version" == "Y" ]]; then
    # Здесь можно добавить код для установки выбранной версии проекта
    echo "Установка проекта с версией $selected_version..."
else
    echo "Вы отказались от установки."
fi
