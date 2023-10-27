#!/bin/bash

create_user() {
    export DEBIAN_FRONTEND=noninteractive
    adduser --quiet --disabled-password --gecos "" $username

    echo "$username:$password" | sudo chpasswd
    usermod -aG sudo $username
    echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

    mkdir -p /home/$username/.ssh
    cp /root/.ssh/authorized_keys /home/$username/.ssh/
    chown -R $username:$username /home/$username/.ssh
    chmod 700 /home/$username
    chmod 600 /home/$username/.ssh/authorized_keys

    echo -e "\033[1m\033[32mПользователь $username создан и добавлен в группу sudo.\033[0m"
    return 0
}

should_continue=true

while $should_continue; do
    echo -ne "\033[1m\033[34mВведите название проекта: \033[0m"
    read project

    echo -ne "\033[1m\033[34mУстановите пароль для пользователя $project: \033[0m"
    read password

    echo -e "\033[1m\033[34mВыберите тип проекта:\033[0m\n1. Testnet\n2. Mainnet"
    echo -ne "\033[1m\033[34mВведите номер варианта (1 или 2): \033[0m"
    read choice

    case $choice in
        1) project_type="testnet" ;;
        2) project_type="mainnet" ;;
        *) echo -e "\033[1m\033[31mНеправильный выбор\033[0m"; continue ;;
    esac

    username="$project-$project_type"

    if id "$username" &>/dev/null; then
        echo -e "\033[1m\033[31mПользователь $username уже существует.\033[0m"
        echo -ne "\033[1m\033[34mХотите создать другого? (yes/no): \033[0m"
        read resp
        
        if [[ "$resp" == "no" ]]; then
            echo -e "\033[1m\033[31mВыход из скрипта\033[0m"
            should_continue=false
        fi
    else
        create_user
        should_continue=false
    fi
done
