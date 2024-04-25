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

    # Добавление пути к Go в ~/.bash_profile пользователя
    echo "export PATH=$PATH:/usr/local/go/bin" >> /home/$username/.bash_profile
    chown $username:$username /home/$username/.bash_profile 

    echo -e "\033[1m\033[32mПользователь $username создан и добавлен в группу sudo.\033[0m"
    return 0
}

should_continue=true

while $should_continue; do
    echo -ne "\033[1m\033[34mВведите название проекта: \033[0m"
    read project

    echo -ne "\033[1m\033[34mУстановите пароль для пользователя $project: \033[0m"
    read password

    esac

    username="$project"

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
