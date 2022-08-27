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
$ docker login -u "kadannr" docker.io
Password:
WARNING! Your password will be stored unencrypted in /home/kadannr/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
```
$ docker images
REPOSITORY                     TAG             IMAGE ID       CREATED         SIZE
kadannr/devops-elasticsearch   7.1.1           1c4b59f28fd7   36 hours ago    229MB
...
$ docker push kadannr/devops-elasticsearch:7.1.1
The push refers to repository [docker.io/kadannr/devops-elasticsearch]
c89fa5712626: Pushed
174f56854903: Pushed
7.1.1: digest: sha256:3930fdc3b88ebc19de7eeec5c6a66b231a2702add70b7c40e1e1e239f84d1f4f size: 740
```
Ссылка на dockerhub: <code>[kadannr/
devops-elasticsearch](https://hub.docker.com/layers/265394865/kadannr/devops-elasticsearch/7.1.1/images/sha256-3930fdc3b88ebc19de7eeec5c6a66b231a2702add70b7c40e1e1e239f84d1f4f?context=repo) </code>

```
$ docker run --rm -d --name els -p 9200:9200 -p 9300:9300 kadannr/devops-elasticsearch:7.1.1
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

### Решение 2:
```
$ curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
$ curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
$ curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}' 
$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases o6XkMLRbB6YwAnS9XPfw2d   1   0         45            0     43.1mb         43.1mb
green  open   ind-1            WGQBnU-79DpTx7LyEHRzph   1   0          0            0       231b           231b
yellow open   ind-3            tgLikAPndVthKzYI4gFMV0   4   2          0            0       736b           736b
yellow open   ind-2            cMtNfljBipz6TGLjv4oLa5   2   1          0            0       279b           279b
$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}

$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty' 
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}

$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty' 
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
$ curl -XGET localhost:9200/_cluster/health/?pretty=true
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
  $ curl -X DELETE 'http://localhost:9200/ind-1?pretty' 
{
  "acknowledged" : true
}
$ curl -X DELETE 'http://localhost:9200/ind-2?pretty' 
{
  "acknowledged" : true
}
$ curl -X DELETE 'http://localhost:9200/ind-3?pretty' 
{
  "acknowledged" : true
}
$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases o6XkMLRbB6YwAnS9XPfw2d   1   0         45            0     43.1mb         43.1mb
```

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


## Решение 3:
```
$ curl -XPOST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/var/lib/elasticsearch/config/snapshot" }}'
{
  "acknowledged" : true
}
$ curl http://localhost:9200/_snapshot/netology_backup?pretty
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/var/lib/elasticsearch/config/snapshot"
    }
  }
}
$ curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
curl http://localhost:9200/test?pretty
{
  "test" : {
    "aliases" : { },
    "mappings" : { },
    "settings" : {
      "index" : {
        "routing" : {
          "allocation" : {
            "include" : {
              "_tier_preference" : "data_content"
            }
          }
        },
        "number_of_shards" : "1",
        "provided_name" : "test",
        "creation_date" : "1346283847827",
        "number_of_replicas" : "0",
        "uuid" : "_fDtbPiz1ivgv5uyxoYN6I",
        "version" : {
          "created" : "8360275"
        }
      }
    }
  }
}
$ docker exec centos-es ls -l /var/lib/elasticsearch/config/snapshot/
total 62
-rw-r--r-- 1 elasticsearch elasticsearch  1621 июл 29 21:15 index-1
-rw-r--r-- 1 elasticsearch elasticsearch     8 июл 29 21:15 index.latest
drwxr-xr-x 6 elasticsearch elasticsearch  4096 июл 29 21:15 indices
-rw-r--r-- 1 elasticsearch elasticsearch 29131 июл 29 21:15 meta-YWahmJ1fMI2Y4VOVSo6wWS.dat
-rw-r--r-- 1 elasticsearch elasticsearch 27648 июл 29 21:15 meta-UOP35EazvCtwPhNzz7xHLw.dat
-rw-r--r-- 1 elasticsearch elasticsearch   726 июл 29 21:15 snap-YWahmJ1fMI2Y4VOVSo6wWS.dat
-rw-r--r-- 1 elasticsearch elasticsearch   707 июл 29 21:15 snap-UOP35EazvCtwPhNzz7xHLw.dat
$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
$ curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
$ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'
$ curl -X GET http://localhost:9200/_cat/indices?v
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   .geoip_databases aObgQy1EdKVXBdLk9bH8QJ   1   0         45            0     43.1mb         43.1mb
green  open   test-2           hJaMUlHmxJ67XOA2K3CWjE   1   0          0            0       231b           231b
```

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
