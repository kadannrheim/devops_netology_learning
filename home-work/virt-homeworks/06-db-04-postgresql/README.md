# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
- подключения к БД
- вывода списка таблиц
- вывода описания содержимого таблиц
- выхода из psql

## Решение задачи 1:
```
kadannr @ wcrow ~/docker/postgres14
└─ $ ▶ docker exec -it psql14 bash
root@d02dd17d1577:/# psql -h localhost -p 5432 -U postgres -W
Password:
psql (14.3 (Debian 14.3-1.pgdg110+1))
Type "help" for help.

postgres=# \?
General
  \copyright             show PostgreSQL usage and distribution terms
  \crosstabview [COLUMNS] execute query and display results in crosstab
  \errverbose            show most recent error message at maximum verbosity
...
```
### вывода списка БД
```
postgres=# \l
                                   List of databases
      Name      |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
----------------+----------+----------+------------+------------+-----------------------
 first_database | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres       | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres_db    | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                |          |          |            |            | postgres=CTc/postgres
 template1      | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
                |          |          |            |            | postgres=CTc/postgres
(5 rows)
```
### подключения к БД
```
Connection
  \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
                         connect to new database (currently "postgres")
```
### вывода списка таблиц
```
\d[S+] list tables, views, and sequences
postgres=# \dtS
                    List of relations
   Schema   |          Name           | Type  |  Owner
------------+-------------------------+-------+----------
 pg_catalog | pg_aggregate            | table | postgres
 pg_catalog | pg_am                   | table | postgres
 pg_catalog | pg_amop                 | table | postgres
 pg_catalog | pg_amproc               | table | postgres
...
(62 rows)
```
### вывода описания содержимого таблиц
```
 \d[S+]  NAME  describe table, view, sequence, or index
postgres-# \dS+ pg_index
                                             Table "pg_catalog.pg_index"
     Column     |     Type     | Collation | Nullable | Default | Storage  | Compression |
Stats target | Description
----------------+--------------+-----------+----------+---------+----------+-------------+-
-------------+-------------
 indexrelid     | oid          |           | not null |         | plain    |             |
             |
 indrelid       | oid          |           | not null |         | plain    |             |
             |
 indnatts       | smallint     |           | not null |         | plain    |             |
             |
 indnkeyatts    | smallint     |           | not null |         | plain    |             |

...


...skipping 1 line
    "pg_index_indexrelid_index" PRIMARY KEY, btree (indexrelid)
    "pg_index_indrelid_index" btree (indrelid)
Access method: heap
### выхода из psql
postgres-# \q
root@d02dd17d1577:/#
```
## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
## Решение
```
root@d02dd17d1577:/# psql -h localhost -p 5432 -U postgres -W
Password:
psql (14.3 (Debian 14.3-1.pgdg110+1))
Type "help" for help.
```
### Создаю БД test_database
```
postgres=# CREATE DATABASE test_database;
CREATE DATABASE
```
### Копирую файл
```
sudo cp test_dump.sql /var/lib/docker/volumes/postgres14_data/_data
root@d02dd17d1577:/var/lib/postgresql/data14# ls
test_dump.sql
```
### Восстанавливаю backup
```
root@d02dd17d1577:/var/lib/postgresql/data14# psql -U postgres -f ./test_dump.sql test_database
SET
SET
SET
SET
SET
 set_config
------------

(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
```
### Захожу в posgres и подключаюсь к test_databse
```
root@d02dd17d1577:/var/lib/postgresql/data14# psql -h localhost -p 5432 -U postgres -W
Password:
psql (14.3 (Debian 14.3-1.pgdg110+1))
Type "help" for help.

postgres=# \c test_database
Password:
You are now connected to database "test_database" as user "postgres".
test_database=#
test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)
```
### Операция ANALYZE
```
test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
```
### Используя таблицу [pg_stats], нахожу столбец таблицы `orders`
```
test_database=# SELECT avg_width FROM pg_stats WHERE tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)
```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
## Решение задачи 3
```
test_database=# alter table orders rename to orders_simple;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_1 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=#
test_database=# create table orders_2 partition of orders for values from (499) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_simple;
INSERT 0 8
test_database-# \dt
                   List of relations
 Schema |     Name      |       Type        |  Owner
--------+---------------+-------------------+----------
 public | orders        | partitioned table | postgres
 public | orders_1      | table             | postgres
 public | orders_2      | table             | postgres
 public | orders_simple | table             | postgres
(4 rows)
```
### Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
Можно, если изначально была бы секционированной
```
test_database-# \dS+ orders_1
                                                Table "public.orders_1"
 Column |         Type          | Collation | Nullable | Default | Storage  | Compression | Stats target | Descr
iption
--------+-----------------------+-----------+----------+---------+----------+-------------+--------------+------
-------
 id     | integer               |           |          |         | plain    |             |              |
 title  | character varying(80) |           |          |         | extended |             |              |
 price  | integer               |           |          |         | plain    |             |              |
Partition of: orders FOR VALUES FROM (0) TO (499)
Partition constraint: ((price IS NOT NULL) AND (price >= 0) AND (price < 499))
Access method: heap

test_database-# \dS+ orders_2
                                                Table "public.orders_2"
 Column |         Type          | Collation | Nullable | Default | Storage  | Compression | Stats target | Descr
iption
--------+-----------------------+-----------+----------+---------+----------+-------------+--------------+------
-------
 id     | integer               |           |          |         | plain    |             |              |
 title  | character varying(80) |           |          |         | extended |             |              |
 price  | integer               |           |          |         | plain    |             |              |
Partition of: orders FOR VALUES FROM (499) TO (999999999)
Partition constraint: ((price IS NOT NULL) AND (price >= 499) AND (price < 999999999))
Access method: heap
```
## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---
## Решение задачи 4
```
root@d02dd17d1577:/var/lib/postgresql/data# pg_dump -U postgres -d test_database > test_database_dump.sql
root@d02dd17d1577:/var/lib/postgresql/data# ls
base          pg_ident.conf  pg_serial     pg_tblspc    postgresql.auto.conf
global        pg_logical     pg_snapshots  pg_twophase  postgresql.conf
pg_commit_ts  pg_multixact   pg_stat       PG_VERSION   postmaster.opts
pg_dynshmem   pg_notify      pg_stat_tmp   pg_wal       postmaster.pid
pg_hba.conf   pg_replslot    pg_subtrans   pg_xact      test_database_dump.sql
```
### Для уникальности добавляем индекс
```
test_database=# CREATE UNIQUE INDEX title_idx ON orders_1 (title);
CREATE INDEX
```
### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
