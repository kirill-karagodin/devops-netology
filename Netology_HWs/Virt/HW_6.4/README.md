# devops-netology
### performed by Kirill Karagodin
#### HW6.4 PostgreSQL.

1. Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
Подключитесь к БД PostgreSQL используя psql.

Создаем том для связи с БД, запускаем контейнер с postgres:13, подключаемся к БД используя psql
````bash
root@vb-micrapc:/# docker volume create vol_pg_hw6_4
vol_pg_hw6_4
root@vb-micrapc:/# docker volume ls
DRIVER    VOLUME NAME
local     vol_pg_hw6_4
root@vb-micrapc:/# docker run -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=test -p 5432:5432 -v /var/lib/docker/volumes/vol_pg_hw6_4:/var/lib/pgsql/data postgres:13
root@vb-micrapc:/# docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
973a03ec2dd5   postgres:13   "docker-entrypoint.s…"   42 seconds ago   Up 41 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   unruffled_chatterjee
root@vb-micrapc:/# psql -h 127.0.0.1 -U test
Password for user test:
psql (14.3 (Ubuntu 14.3-0ubuntu0.22.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

test=#
````
Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.
Найдите и приведите управляющие команды для:
- вывода списка БД 
````bash
test=# \l
                             List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    | Access privileges
-----------+-------+----------+------------+------------+-------------------
 postgres  | test  | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
           |       |          |            |            | test=CTc/test
 template1 | test  | UTF8     | en_US.utf8 | en_US.utf8 | =c/test          +
           |       |          |            |            | test=CTc/test
 test      | test  | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

````
- подключения к БД
````bash
test=# \c test
psql (14.3 (Ubuntu 14.3-0ubuntu0.22.04.1), server 13.7 (Debian 13.7-1.pgdg110+1))
You are now connected to database "test" as user "test".
````
- вывода списка таблиц
````bash
test=# \dtS+
                                               List of relations
   Schema   |          Name           | Type  | Owner | Persistence | Access method |    Size    | Description
------------+-------------------------+-------+-------+-------------+---------------+------------+-------------
 pg_catalog | pg_aggregate            | table | test  | permanent   | heap          | 56 kB      |
 pg_catalog | pg_am                   | table | test  | permanent   | heap          | 40 kB      |
 pg_catalog | pg_amop                 | table | test  | permanent   | heap          | 80 kB      |
 pg_catalog | pg_amproc               | table | test  | permanent   | heap          | 64 kB      |
....
 pg_catalog | pg_user_mapping         | table | test  | permanent   | heap          | 8192 bytes |
(62 rows)
````
- вывода описания содержимого таблиц ( \d[S+] NAME )
````bash
test=# \dS+  pg_aggregate
                                   Table "pg_catalog.pg_aggregate"
      Column      |   Type   | Collation | Nullable | Default | Storage  | Stats target | Description
------------------+----------+-----------+----------+---------+----------+--------------+-------------
 aggfnoid         | regproc  |           | not null |         | plain    |              |
 aggkind          | "char"   |           | not null |         | plain    |              |
 aggnumdirectargs | smallint |           | not null |         | plain    |              |
 aggtransfn       | regproc  |           | not null |         | plain    |              |
 aggfinalfn       | regproc  |           | not null |         | plain    |              |
 aggcombinefn     | regproc  |           | not null |         | plain    |              |
 aggserialfn      | regproc  |           | not null |         | plain    |              |
 aggdeserialfn    | regproc  |           | not null |         | plain    |              |
 aggmtransfn      | regproc  |           | not null |         | plain    |              |
 aggminvtransfn   | regproc  |           | not null |         | plain    |              |
 aggmfinalfn      | regproc  |           | not null |         | plain    |              |
 aggfinalextra    | boolean  |           | not null |         | plain    |              |
 aggmfinalextra   | boolean  |           | not null |         | plain    |              |
 aggfinalmodify   | "char"   |           | not null |         | plain    |              |
 aggmfinalmodify  | "char"   |           | not null |         | plain    |              |
 aggsortop        | oid      |           | not null |         | plain    |              |
 aggtranstype     | oid      |           | not null |         | plain    |              |
 aggtransspace    | integer  |           | not null |         | plain    |              |
 aggmtranstype    | oid      |           | not null |         | plain    |              |
 aggmtransspace   | integer  |           | not null |         | plain    |              |
 agginitval       | text     | C         |          |         | extended |              |
 aggminitval      | text     | C         |          |         | extended |              |
Indexes:
    "pg_aggregate_fnoid_index" UNIQUE, btree (aggfnoid)
Access method: heap

test=#
````
- выхода из psql 
````bash
test=# \q
````
2. Используя psql создайте БД test_database.
Изучите бэкап БД.
Восстановите бэкап БД в test_database.
Перейдите в управляющую консоль psql внутри контейнера.
Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.
Приведите в ответе команду, которую вы использовали для вычисления и полученный результат.

Проверим, что в контейнере действительно есть test_dump.sql. Создадим базу данных test_database
````bash
root@vb-micrapc:/# docker exec -it 973a03ec2dd5 bash
root@973a03ec2dd5:/# ls /var/lib/pgsql/data/_data/backup/
test_dump.sql
root@973a03ec2dd5:/# psql -h localhost -p 5432 -U test
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

test=# CREATE DATABASE test_database;
CREATE DATABASE
test=# \q
````
Перенаправляем бэкап в базу данных
````bash
root@973a03ec2dd5:/# psql test_database < /var/lib/pgsql/data/_data/backup/test_dump.sql -U test
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
ERROR:  role "postgres" does not exist
CREATE SEQUENCE
ERROR:  role "postgres" does not exist
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval
--------
      8
(1 row)

ALTER TABLE
root@973a03ec2dd5:/#
````
Подключаемся к postgres, проверим восстановление БД из бекапа
````bash
root@973a03ec2dd5:/# psql -h localhost -p 5432 -U test
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

test=# \c test_database
You are now connected to database "test_database" as user "test".
test_database=# \dt
        List of relations
 Schema |  Name  | Type  | Owner
--------+--------+-------+-------
 public | orders | table | test
(1 row)

test_database=#
````
Проводим операцию ANALYZE для сбора статистики по таблице.
````bash
test_database=# ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
````
Используя таблицу pg_stats, находим столбец таблицы orders с наибольшим средним значением размера элементов в байтах. 
Т.к. avg_width столбец типа integer показывает срений размер элементов в столбце, байты, то команда будет выглядеть 
следующим образом:
````bash
test_database=# select max(avg_width) from pg_stats where tablename='orders';
 max
-----
  16
(1 row)

test_database=#
````
3. Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней 
занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили провести разбиение таблицы 
на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).
- Предложите SQL-транзакцию для проведения данной операции.
- Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
Ручное разбиение возможно исключить если предусматриваются какие-то шаблнные правила по сбору таблицы (например 
CREATE RULE, CONSTRAINT CHECK)
````bash
test_database=# \dt
        List of relations
 Schema |  Name  | Type  | Owner
--------+--------+-------+-------
 public | orders | table | test
(1 row)

test_database=# CREATE TABLE orders_1 (CHECK (price>499)) INHERITS (orders);
CREATE TABLE
test_database=# CREATE TABLE orders_2 (CHECK (price<=499)) INHERITS (orders);
CREATE TABLE
test_database=# \dt
         List of relations
 Schema |   Name   | Type  | Owner
--------+----------+-------+-------
 public | orders   | table | test
 public | orders_1 | table | test
 public | orders_2 | table | test
(3 rows)

test_database=#
````
4. Используя утилиту pg_dump создайте бекап БД test_database.
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

Создаем бэкап БД test_database
````bash
root@973a03ec2dd5:/# pg_dump -U test test_database > /var/lib/pgsql/data/_data/backup/test_db_dump.sql
root@973a03ec2dd5:/var/lib/pgsql/data/_data/backup# ls
test_db_dump.sql  test_dump.sql
root@973a03ec2dd5:/var/lib/pgsql/data/_data/backup#
````
Для уникальности можно добавить индекс CREATE INDEX ON orders (lower(title))
````bash
root@973a03ec2dd5:/var/lib/pgsql/data/_data/backup# tail test_db_dump.sql
...
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);
...
````