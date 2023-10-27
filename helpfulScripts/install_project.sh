#!/bin/bash

# Функция для определения последнего релиза по URL репозитория
function get_latest_release {
    repo_url="$1"
    latest_release=$(curl -s "https://api.github.com/repos${repo_url}/releases/latest" | grep -o '"tag_name": "[^"]*' | grep -o '[^"]*$')
    echo "$latest_release"
}

# Функция для предложения выбора действия (собрать из исходного кода или скачать бинарник)
function select_action {
    echo "Выберите действие:"
    select action in "Собрать из исходного кода" "Скачать готовый бинарник"; do
        case $action in
            "Собрать из исходного кода")
                # Здесь можно добавить код для сборки из исходного кода (пример: go build)
                echo "Сборка из исходного кода..."
                break
                ;;
            "Скачать готовый бинарник")
                # Здесь можно добавить код для скачивания готового бинарника
                echo "Скачивание готового бинарника..."
                break
                ;;
            *)
                echo "Выберите вариант 1 или 2."
                ;;
        esac
    done
}

# Получение URL репозитория от пользователя
read -p "Введите URL репозитория проекта (например, https://github.com/umee-network/umee.git): " repo_url

# Определение последнего релиза
latest_release=$(get_latest_release "$repo_url")

# Вывод версии последнего релиза и запрос пользователя о продолжении
echo "Последний релиз: $latest_release"
read -p "Согласны продолжить с этой версией? (y/n): " continue_with_release

if [[ "$continue_with_release" == "y" || "$continue_with_release" == "Y" ]]; then
    # Выбор действия (собрать из исходного кода или скачать бинарник)
    select_action
else
    echo "Вы отказались продолжать с этой версией."
fi
