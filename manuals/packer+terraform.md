# Установка PACKER
https://www.packer.io/downloads
```
* curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
* sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
* sudo apt-get update && sudo apt-get install packer
```
* packer --version -просмотр версии
* создаём или редактируем файл packer json или прочий:
    * Пример файла:
        > {
  "builders": [
    {
      "disk_type": "network-nvme",
      "folder_id": "ид папки",
      "image_description": "by packer",
      "image_family": "centos",
      "image_name": "centos-7-base",
      "source_image_family": "centos-7",
      "ssh_username": "centos",
      "subnet_id": "ид подсети",
      "token": "полученный токен облака",
      "type": "yandex",
      "use_ipv4_nat": true,
      "zone": "ru-central1-a"
    }
  ],
  "provisioners": [
    {
      "inline": [
        "sudo yum -y update",
        "sudo yum -y install bridge-utils bind-utils iptables curl net-tools tcpdump rsync telnet openssh-server"
      ],
      "type": "shell"
    }
  ]
}

    * packer build [имя файла] -запускаем сборку образа
# Установка TERRAFORM
* [Мануал](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  
 или
* sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
* curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
* sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
* sudo apt-get update && sudo apt-get install terraform
* terraform --version
* terraform init
* terraform plan
* terraform apply