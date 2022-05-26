# Домашнее задание к занятию "09.03 Jenkins"

## Подготовка к выполнению

1. Установить jenkins по любой из [инструкций](https://www.jenkins.io/download/)
```
docker pull jenkins/jenkins
```
```
cat docker-compose.yaml
version: '3.0'
services:
  jenkins:
    image: jenkins/jenkins:latest-jdk11
    privileged: true
    user: root
    ports:
      - 8080:8080
      - 50000:50000
    container_name: jenkins
    volumes:
      - $HOME/jenkins_compose/jenkins_configuration:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
   
```
2. Запустить и проверить работоспособность
    ```
    docker-compose up -d
    docker-compose ps

```
sudo docker-compose ps
 Name                Command               State                                           Ports
-----------------------------------------------------------------------------------------------------------------------------------------
jenkins   /sbin/tini -- /usr/local/b ...   Up      0.0.0.0:50000->50000/tcp,:::50000->50000/tcp, 0.0.0.0:8080->8080/tcp,:::8080->8080/tcp
```
1. Сделать первоначальную настройку
2. Настроить под свои нужды
3. Поднять отдельный cloud
```
 sudo docker pull docker:dind
 https://www.jenkins.io/doc/book/installing/docker/
```   
```
kadannr @ wcrow ~
└─ $ ▶ sudo docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS
   NAMES
42ea2bceb95e   docker:dind   "dockerd-entrypoint.…"   31 seconds ago   Up 30 seconds   2375/tcp, 0.0.0.0:2376->2376/tcp, :::2376->2376/tcp   jenkins-docker
```
4. Для динамических агентов можно использовать [образ](https://hub.docker.com/repository/docker/aragast/agent)
5. Обязательный параметр: поставить label для динамических агентов: `ansible_docker`
6.  Сделать форк репозитория с [playbook](https://github.com/aragastmatb/example-playbook)
```
kadannr @ wcrow ~/docker/jenkins (master)
└─ $ ▶ sudo git clone https://github.com/aragastmatb/example-playbook.git
Клонирование в «example-playbook»…
remote: Enumerating objects: 60, done.
remote: Counting objects: 100% (24/24), done.
remote: Compressing objects: 100% (14/14), done.
remote: Total 60 (delta 17), reused 10 (delta 10), pack-reused 36
Распаковка объектов: 100% (60/60), 12.42 КиБ | 553.00 КиБ/с, готово.
```
## Основная часть

1. Сделать Freestyle Job, который будет запускать `ansible-playbook` из форка репозитория
2. Сделать Declarative Pipeline, который будет выкачивать репозиторий с плейбукой и запускать её
3. Перенести Declarative Pipeline в репозиторий в файл `Jenkinsfile`
4. Перенастроить Job на использование `Jenkinsfile` из репозитория
5. Создать Scripted Pipeline, наполнить его скриптом из [pipeline](./pipeline)
6. Заменить credentialsId на свой собственный
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозитрий в файл `ScriptedJenkinsfile`
8. Отправить ссылку на репозиторий в ответе

## Необязательная часть

1. Создать скрипт на groovy, который будет собирать все Job, которые завершились хотя бы раз неуспешно. Добавить скрипт в репозиторий с решеним с названием `AllJobFailure.groovy`
2. Установить customtools plugin
3. Поднять инстанс с локальным nexus, выложить туда в анонимный доступ  .tar.gz с `ansible`  версии 2.9.x
4. Создать джобу, которая будет использовать `ansible` из `customtool`
5. Джоба должна просто исполнять команду `ansible --version`, в ответ прислать лог исполнения джобы 

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
