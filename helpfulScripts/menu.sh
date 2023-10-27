#!/bin/bash

while true; do
    clear
    echo "Выберите действие:"
    echo "1) Добавить пользователей"
    echo "2) Установить Go"
    echo "3) Выход"
    read -p "Введите номер опции: " choice

    case $choice in
        1) . <(wget -qO- https://raw.githubusercontent.com/romanv1812/NodeTools/main/helpfulScripts/add_user.sh) ;;
        2) bash install_go.sh ;;
        3) echo "Выход..."; return 0 ;;
        *) echo "Неверный выбор!" ;;
    esac

    read -p "Нажмите [Enter], чтобы вернуться в меню..."
done
