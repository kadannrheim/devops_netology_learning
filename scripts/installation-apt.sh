#!/bin/bash
#installation soft fot linux? my work station

#update
apt update

# tools
apt install mc
apt install htop
apt install gvim

# docker
#установите несколько необходимых пакетов, которые позволяют apt использовать пакеты через HTTPS.
apt install apt-transport-https ca-certificates curl software-properties-common
#Добавьте ключ GPG для официального репозитория Docker в вашу систему.
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#Добавьте репозиторий Docker в источники APT
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#update
apt update
#Убедитесь, что установка будет выполняться из репозитория Docker, а не из репозитория Ubuntu по умолчанию
apt-cache policy docker-ce
sleep 10
apt install docker-ce

#вывод версий и статуса установленных приложений
systemctl status docker
packer
terraform
ansible
yc