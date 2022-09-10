# Дипломный практикум в YandexCloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
      * [Регистрация доменного имени](#регистрация-доменного-имени)
      * [Создание инфраструктуры](#создание-инфраструктуры)
          * [Установка Nginx и LetsEncrypt](#установка-nginx)
          * [Установка кластера MySQL](#установка-mysql)
          * [Установка WordPress](#установка-wordpress)
          * [Установка Gitlab CE, Gitlab Runner и настройка CI/CD](#установка-gitlab)
          * [Установка Prometheus, Alert Manager, Node Exporter и Grafana](#установка-prometheus)


---
## Цели:

1. Зарегистрировать доменное имя (любое на ваш выбор в любой доменной зоне).
2. Подготовить инфраструктуру с помощью Terraform на базе облачного провайдера YandexCloud.
3. Настроить внешний Reverse Proxy на основе Nginx и LetsEncrypt.
4. Настроить кластер MySQL.
5. Установить WordPress.
6. Развернуть Gitlab CE и Gitlab Runner.
7. Настроить CI/CD для автоматического развёртывания приложения.
8. Настроить мониторинг инфраструктуры с помощью стека: Prometheus, Alert Manager и Grafana.

---
## Этапы выполнения:

### 1. Регистрация доменного имени
sc1

### 2. Создание инфраструктуры
#### 2.1 Подготовка yc
```
https://cloud.yandex.ru/docs/cli/quickstart
или 
* Скрипт установит CLI и добавит путь до исполняемого файла в переменную окружения PATH:
```
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
* yc --version - проверка версии, нужно пеерлогиниться после установки.
```
kadannr @ wcrow ~
└─ $ ▶ yc --version
Yandex Cloud CLI 0.89.0 linux/amd64
```
kadannr @ wcrow ~
└─ $ ▶ (main)yc init
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'netology' with new settings
 [2] Create a new profile
 [3] Switch to and re-initialize existing profile: 'default'
Please enter your numeric choice: 1
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb in order to obtain OAuth token.

Please enter OAuth token: [AQAAAAAhN*********************BFmg_1gzs] AQAA##############dNufpU9enUBFmg_1gzs
You have one cloud available: 'cloud-alifanovea' (id = b1gsgr4keg8cp3dtm059). It is going to be used by default.
Please choose folder to use:
 [1] default (id = b1gnobiebevf7he8kdau)
 [2] Create a new folder
Please enter your numeric choice: 2
Please enter a folder name: netology
Your current folder has been set to 'netology' (id = b1germtpul6t5a784q42).
Do you want to configure a default Compute zone? [Y/n] 1
Please enter 'yes' or 'no': yes
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-c
 [4] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.
```
#### 2.3 Создвние сети и подсети для packer
```
kadannr @ wcrow ~
└─ $ ▶ yc vpc network create \
> --name net \
> --labels my-label=netology \
> --description "my network via yc"
id: enphcsq7cdh7su20a0gu
folder_id: b1germtpul6t5a784q42
created_at: "2022-09-10T04:15:31Z"
name: net
description: my network via yc
labels:
  my-label: netology

kadannr @ wcrow ~
└─ $ ▶ yc vpc subnet create \
> --name my-subnet-a \
> --zone ru-central1-a \
> --range 10.1.2.0/24 \
> --network-name net \
> --description "my subnet via yc"
id: e9b9ouoqgqn7vi9amqjq
folder_id: b1germtpul6t5a784q42
created_at: "2022-09-10T04:18:52Z"
name: my-subnet-a
description: my subnet via yc
network_id: enphcsq7cdh7su20a0gu
zone_id: ru-central1-a
v4_cidr_blocks:
- 10.1.2.0/24

kadannr @ wcrow ~
└─ $ ▶ yc config list
service-account-key:
  id: ajekf68rjm2msv30d112
  service_account_id: ajel2fuobpf4jf8l98jl
  created_at: "2022-04-17T15:53:47.747252807Z"
  key_algorithm: RSA_2048
cloud-id: b1gsgr4keg8cp3dtm059
folder-id: b1germtpul6t5a784q42
compute-default-zone: ru-central1-a
```
#### 2.4 Редактирование файла centos-7-base.json
{
  "builders": [
    {
      "disk_type": "network-nvme",
      "folder_id": "b1germtpul6t5a784q42",
      "image_description": "by packer",
      "image_family": "centos",
      "image_name": "centos-7-base",
      "source_image_family": "centos-7",
      "ssh_username": "centos",
      "subnet_id": "e9b9ouoqgqn7vi9amqjq",
      "token": "",
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
#### 2.2 Подготовка образа packer на yc




### 3. Установка Nginx и LetsEncrypt



### 4. Установка кластера MySQL



### 5. Установка WordPress



### 6. Установка Gitlab CE и Gitlab Runner



### 7. Установка Prometheus, Alert Manager, Node Exporter и Grafana



