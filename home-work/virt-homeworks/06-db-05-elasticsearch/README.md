# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib` 
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста
- ссылку на образ в репозитории dockerhub
- ответ `elasticsearch` на запрос пути `/` в json виде

Подсказки:
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- обратите внимание на настройки безопасности такие как `xpack.security.enabled` 
- если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
- при настройке `path` возможно потребуется настройка прав доступа на директорию

Далее мы будем работать с данным экземпляром elasticsearch.

## Решение 1:
Dockerfile:
```
#7 Elasticsearch
FROM centos:7

EXPOSE 9200 9300

USER 0

RUN export ES_HOME="/var/lib/elasticsearch" && \
    yum -y install wget --nogpgcheck && \
    wget https://mirror.yandex.ru/mirrors/elastic/8/dists/stable/main/binary-amd64/Packages.gz && \
    #wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.11.1-linux-x86_64.tar.gz.sha512 && \
    #shasum -a 512 -c elasticsearch-7.1.1-linux-x86_64.tar.gz.sha512 && \
    gunzip Packages.gz && \
    mv Packages els8ya && \
    rm -f Packages.gz && \
    mv els8ya ${ES_HOME} && \
    useradd -m -u 1000 elasticsearch && \
    chown elasticsearch:elasticsearch -R ${ES_HOME} && \
    yum -y remove wget && \
    yum clean all

COPY --chown=elasticsearch:elasticsearch config/* /var/lib/elasticsearch/config/

USER 1000

ENV ES_HOME="/var/lib/elasticsearch" \
    ES_PATH_CONF="/var/lib/elasticsearch/config"
WORKDIR ${ES_HOME}

CMD ["sh", "-c", "${ES_HOME}/bin/elasticsearch"]
```
```
docker build . -t kadannr/devops-elasticsearch:7.1.1
docker login -u "kadannr"  --password-stdin "yIpa$n7A04S2Bt%Iek" docker.io
docker push devops-elasticsearch:7.1.1
```
```
kadannr @ wcrow ~
└─ $ ▶ docker login -u "kadannr" docker.io
Password:
WARNING! Your password will be stored unencrypted in /home/kadannr/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
```
kadannr @ wcrow ~
└─ $ ▶ docker images
REPOSITORY                     TAG             IMAGE ID       CREATED         SIZE
kadannr/devops-elasticsearch   7.1.1           1c4b59f28fd7   36 hours ago    229MB
...
kadannr @ wcrow ~
└─ $ ▶ docker push kadannr/devops-elasticsearch:7.1.1
The push refers to repository [docker.io/kadannr/devops-elasticsearch]
c89fa5712626: Pushed
174f56854903: Pushed
7.1.1: digest: sha256:3930fdc3b88ebc19de7eeec5c6a66b231a2702add70b7c40e1e1e239f84d1f4f size: 740
```
Ссылка на dockerhub: <code>[kadannr/
devops-elasticsearch](https://hub.docker.com/layers/265394865/kadannr/devops-elasticsearch/7.1.1/images/sha256-3930fdc3b88ebc19de7eeec5c6a66b231a2702add70b7c40e1e1e239f84d1f4f?context=repo) </code>

Ответ els:
docker run --rm -d --name els -p 9200:9200 -p 9300:9300 kadannr/devops-elasticsearch:7.1.1
```
kadannr @ wcrow ~
└─ $ ▶ docker run --rm -d --name els -p 9200:9200 -p 9300:9300 kadannr/devops-elasticsearch:7.1.1
9e999ff980943aaae5f7116e2a880b76638447483772d675ece01a1243627b8a
```
## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
