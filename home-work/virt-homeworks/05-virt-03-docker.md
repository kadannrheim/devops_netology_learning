
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

# Решение задачи №1
```
vagrant@vagrant:~$ sudo docker pull nginx
Using default tag: latest
latest: Pulling from library/nginx
ae13dd578326: Pull complete
6c0ee9353e13: Pull complete
dca7733b187e: Pull complete
352e5a6cac26: Pull complete
9eaf108767c7: Pull complete
be0c016df0be: Pull complete
Digest: sha256:4ed64c2e0857ad21c38b98345ebb5edb01791a0a10b0e9e3d9ddde185cdbd31a
Status: Downloaded newer image for nginx:latest
docker.io/library/nginx:latest
vagrant@vagrant:~$ sudo docker images
REPOSITORY                               TAG       IMAGE ID       CREATED       SIZE
nginx                                    latest    f2f70adc5d89   9 days ago    142MB
```
### Создал Dockerfile

```
vagrant@vagrant:~/docker$ cat Dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/
LABEL version="1"
CMD [ "nginx" ]
```
### Cобрал образ
```
vagrant@vagrant:~/docker$ docker build -t kadannr/nginxnetology:1 .
Sending build context to Docker daemon  3.072kB
Step 1/4 : FROM nginx
 ---> f2f70adc5d89
Step 2/4 : COPY index.html /usr/share/nginx/html/
 ---> 08de5d14c1e4
Step 3/4 : LABEL version="1"
 ---> Running in 549084241e81
Removing intermediate container 549084241e81
 ---> ac3c3b546441
Step 4/4 : CMD [ "nginx" ]
 ---> Running in cb40efc9800e
Removing intermediate container cb40efc9800e
 ---> 69c1056c81ce
Successfully built 69c1056c81ce
Successfully tagged kadannr/nginxnetology:1
```
### Отобразим образы
```
vagrant@vagrant:~/docker$ docker image ls
REPOSITORY              TAG       IMAGE ID       CREATED         SIZE
kadannr/nginxnetology   1         69c1056c81ce   9 minutes ago   142MB
nginx                   latest    f2f70adc5d89   11 days ago     142MB
```
### Отправим в Docker hub
```
vagrant@vagrant:~/docker$ docker login -u kadannr
Password:
WARNING! Your password will be stored unencrypted in /home/vagrant/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
vagrant@vagrant:~/docker$ docker push kadannr/nginxnetology:1
The push refers to repository [docker.io/kadannr/nginxnetology]
e4f4d16b663c: Pushed
24037b645d66: Mounted from library/nginx
d00147ef6763: Mounted from library/nginx
2793e885dc34: Mounted from library/nginx
8b8ecda1d12d: Mounted from library/nginx
30c00b5281a1: Mounted from library/nginx
3a626bb08c24: Mounted from library/nginx
1: digest: sha256:c0607dda03dea89db898a5695267ea6c4cf01df5f77c184e11a09e8d6a4339bc size: 1777
```
### Ссылка

**https://hub.docker.com/repository/docker/kadannr/nginxnetology**

## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- 1 Высоконагруженное монолитное java веб-приложение;
- 2 Nodejs веб-приложение;
- 3 Мобильное приложение c версиями для Android и iOS;
- 4 Шина данных на базе Apache Kafka;
- 5 Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
- 6 Мониторинг-стек на базе Prometheus и Grafana;
- 7 MongoDB, как основное хранилище данных для java-приложения;
- 8 Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

# Решение задачи №2

* 1 Высоконагруженнй тяжелый сервис целесобразней использовать на физической машине. Наверное возможно в Docker, но не имеет большого смысла, так как тогда его преимещуство в ввиде заимствования части пакетов основной ОС для контейнеров нивелируется и ресурсы поглощает один большой сервис.
* 2 Однозначно Docker и паравиртуалихация. Для большой команды разработки первое, для продакшена первое и второе в зависимости от задач.
* 3 Docker позволяет создавать контейнеры с android, но на сколько я понял IOS невозможно запустить по аппаратным причинам. Поэтому дополнять или заменять будет виртуализация.
* 4 Apache Kafka насколько я понял создаётся в кластерах и выполняет роль распределённой системы, которая хранит и обрабатывает информацию. Поэтому физическое железо или аппаратная виртуализация.
* 5 Виртуализация, при кластеризации я бы спользовал полную виртуализацию.
* 6 Здесь подойдет Docker и паравиртуализация, так как сами сервисы весят не много, но возможно данные хранить будут большие. Это уже можно выполнить в другом исполнении.
* 7 Физическая машина подходит для баз данных лучше всего. Конечно всё зависит от нагрузки и целей.
* 8 Так как сервисов два можно использовать аппаратную или паравиртуализаци. Докер тоже возможно, если вынести разделы с репозиториями вне контейнеров, так как они будут раздуваться от хранения информации, а плюс докера в минимизации размера и быстроразвертываемости.

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

## Рещение задачи №3
### Скачиваю образы
```
vagrant@vagrant:~/docker$ docker pull centos
Using default tag: latest
latest: Pulling from library/centos
a1d0c7532777: Pull complete
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
docker.io/library/centos:latest
vagrant@vagrant:~/docker$ docker pull debian
Using default tag: latest
latest: Pulling from library/debian
dbba69284b27: Pull complete
Digest: sha256:87eefc7c15610cca61db5c0fd280911c6a737c0680d807432c0bd80cd0cca39b
Status: Downloaded newer image for debian:latest
docker.io/library/debian:latest
vagrant@vagrant:~/docker$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```
### Запускаю контейнеры в директориями
```
vagrant@vagrant:~/docker$ docker run -v /data:/data -dt --name centos centos
556fb06cd1bc4aedbb5ef79f6bdb8500a9e92e01e1e39c9f29fd79716faefbdd
vagrant@vagrant:~/docker$ docker run -v /data:/data -dt --name debian debian
affc31302041249217b688f24da94ef80ee2121459472f9e6ebe1d86ac74a446
vagrant@vagrant:~/docker$ docker exec -it centos bash
```
### Создаю файл и отключаюсь от centos
```
[root@556fb06cd1bc /]# echo 'From centos'>/data/from-centos
[root@556fb06cd1bc /]# exit
exit
```
### Проверяю файл в debian
```
vagrant@vagrant:~/docker$ docker exec -it debian bash
root@affc31302041:/# cat /data/from-centos
From centos
root@affc31302041:/# ls -lha /data/from-centos
-rw-r--r-- 1 root root 12 Mar 29 20:21 /data/from-centos
```
