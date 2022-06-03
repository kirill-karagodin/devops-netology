# devops-netology
### performed by Kirill Karagodin
#### HW6.2 SQL.
1. Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и
бэкапы.
Приведите получившуюся команду или docker-compose манифест.
````bash
root@vb-micrapc:/home/micra# docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
root@vb-micrapc:/home/micra# docker run --rm --name postgres -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=test-admin-user -e POSTGRES_DB=test_db -d -p 5432:5432 -v /opt/docker/volumes/backup:/var/lib/postgresql/backup -v /opt/docker/volumes/data:/var/lib/postgresql/data postgres:12
Unable to find image 'postgres:12' locally
12: Pulling from library/postgres
42c077c10790: Pull complete
3c2843bc3122: Pull complete
12e1d6a2dd60: Pull complete
9ae1101c4068: Pull complete
fb05d2fd4701: Pull complete
9785a964a677: Pull complete
16fc798b0e72: Pull complete
f1a0bfa2327a: Pull complete
f1e20d84ae82: Pull complete
8b37d1e969e5: Pull complete
7261decb0bcf: Pull complete
76fd4336668c: Pull complete
50b8a43577a4: Pull complete
Digest: sha256:fe84844ef27aaaa52f6ec68d6b3c225d19eb4f54200a93466aa67798c99aa462
Status: Downloaded newer image for postgres:12
cf55160697855a98bb1607cfb54dbcf56a3bd83a83cc4d43c036dac3685cfb7c
root@vb-micrapc:/home/micra# docker ps -a
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS          PORTS                                       NAMES
cf5516069785   postgres:12   "docker-entrypoint.s…"   25 seconds ago   Up 23 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres
root@vb-micrapc:/home/micra# docker exec -it postgres ls -l /var/lib/postgresql
total 8
drwxr-xr-x  2 root     root 4096 Jun  3 15:27 backup
drwx------ 19 postgres root 4096 Jun  3 15:28 data
root@vb-micrapc:/home/micra#
````
2.В БД из задачи 1:

- создайте пользователя test-admin-user и БД test_db 
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db 
- создайте пользователя test-simple-user 
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Заходим в БД
````bash
root@vb-micrapc:/home/micra# psql -h 127.0.0.1 -U test-admin-user -d postgres
Password for user test-admin-user:
psql (14.3 (Ubuntu 14.3-0ubuntu0.22.04.1), server 12.11 (Debian 12.11-1.pgdg110+1))
Type "help" for help.

postgres=# 
````
Список БД и пользователей в postgres 
````bash
postgres-# \l+
                                                                               List of databases
   Name    |      Owner      | Encoding |  Collate   |   Ctype    |            Access privileges            |  Size   | Tablespace |                Description
-----------+-----------------+----------+------------+------------+-----------------------------------------+---------+------------+--------------------------------------------
 postgres  | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |                                         | 7969 kB | pg_default | default administrative connection database
 template0 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | unmodifiable empty database
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            |
 template1 | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin-user"                   +| 7825 kB | pg_default | default template for new databases
           |                 |          |            |            | "test-admin-user"=CTc/"test-admin-user" |         |            |
 test_db   | test-admin-user | UTF8     | en_US.utf8 | en_US.utf8 |                                         | 7825 kB | pg_default |
(4 rows)

postgres-#
````
Создаем две таблицы в БД
Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)
Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)
````bash
postgres=# \connect test_db
psql (14.3 (Ubuntu 14.3-0ubuntu0.22.04.1), server 12.11 (Debian 12.11-1.pgdg110+1))
You are now connected to database "test_db" as user "test-admin-user".
test_db=# create table orders (id serial primary key, Наименование text, Цена integer);
CREATE TABLE
test_db=# create table clients (id serial primary key, ФИО text, "Страна проживания" text, Заказ integer, foreign key (Заказ) references orders (id));
CREATE TABLE
test_db=# \dt
             List of relations
 Schema |  Name   | Type  |      Owner
--------+---------+-------+-----------------
 public | clients | table | test-admin-user
 public | orders  | table | test-admin-user
(2 rows)

test_db=# \d+ orders
                                                   Table "public.orders"
    Column    |  Type   | Collation | Nullable |              Default               | Storage  | Stats target | Description
--------------+---------+-----------+----------+------------------------------------+----------+--------------+-------------
 id           | integer |           | not null | nextval('orders_id_seq'::regclass) | plain    |              |
 Наименование | text    |           |          |                                    | extended |              |
 Цена         | integer |           |          |                                    | plain    |              |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_Заказ_fkey" FOREIGN KEY ("Заказ") REFERENCES orders(id)
Access method: heap

test_db=# \d+ clients
                                                      Table "public.clients"
      Column       |  Type   | Collation | Nullable |               Default               | Storage  | Stats target | Description
-------------------+---------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id                | integer |           | not null | nextval('clients_id_seq'::regclass) | plain    |              |
 ФИО               | text    |           |          |                                     | extended |              |
 Страна проживания | text    |           |          |                                     | extended |              |
 Заказ             | integer |           |          |                                     | plain    |              |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_Заказ_fkey" FOREIGN KEY ("Заказ") REFERENCES orders(id)
Access method: heap

test_db=#
````
Предоставляем все привелегии на все операции пользователю test-admin-user на таблицы БД test_db
````bash
test_db=# \dgS+ test-admin-user
                                             List of roles
    Role name    |                         Attributes                         | Member of | Description
-----------------+------------------------------------------------------------+-----------+-------------
 test-admin-user | Superuser, Create role, Create DB, Replication, Bypass RLS | {}        |

test_db=#
````
Создаем пользователя test-simple-user и предоставляем ему права на таблицу SELECT/INSERT/UPDATE/DELETE
````bash
test_db=# CREATE USER "test-simple-user" NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT LOGIN;
CREATE ROLE
test_db=# \dgS+ test*
                                              List of roles
    Role name     |                         Attributes                         | Member of | Description
------------------+------------------------------------------------------------+-----------+-------------
 test-admin-user  | Superuser, Create role, Create DB, Replication, Bypass RLS | {}        |
 test-simple-user | No inheritance                                             | {}        |

test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "test-simple-user";
GRANT
test_db=# select * from information_schema.table_privileges where grantee='test-simple-user';
     grantor     |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
-----------------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 test-admin-user | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 test-admin-user | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 test-admin-user | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 test-admin-user | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(8 rows)

test_db=# select * from information_schema.table_privileges where grantee='test-admin-user' LiMIT 14;
     grantor     |     grantee     | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy
-----------------+-----------------+---------------+--------------+------------+----------------+--------------+----------------
 test-admin-user | test-admin-user | test_db       | public       | orders     | INSERT         | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | orders     | SELECT         | YES          | YES
 test-admin-user | test-admin-user | test_db       | public       | orders     | UPDATE         | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | orders     | DELETE         | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | orders     | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | orders     | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | orders     | TRIGGER        | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | clients    | INSERT         | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | clients    | SELECT         | YES          | YES
 test-admin-user | test-admin-user | test_db       | public       | clients    | UPDATE         | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | clients    | DELETE         | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | clients    | TRUNCATE       | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | clients    | REFERENCES     | YES          | NO
 test-admin-user | test-admin-user | test_db       | public       | clients    | TRIGGER        | YES          | NO
(14 rows)
````
3. Используя SQL синтаксис - наполните таблицы следующими тестовыми данными
````bash
test_db=# insert into orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# select * from orders;
 id | Наименование | Цена
----+--------------+------
  1 | Шоколад      |   10
  2 | Принтер      | 3000
  3 | Книга        |  500
  4 | Монитор      | 7000
  5 | Гитара       | 4000
(5 rows)

test_db=# insert into clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# select * from clients;
 id |         ФИО          | Страна проживания | Заказ
----+----------------------+-------------------+-------
  1 | Иванов Иван Иванович | USA               |
  2 | Петров Петр Петрович | Canada            |
  3 | Иоганн Себастьян Бах | Japan             |
  4 | Ронни Джеймс Дио     | Russia            |
  5 | Ritchie Blackmore    | Russia            |
(5 rows)

test_db=#
````
4. Часть пользователей из таблицы clients решили оформить заказы из таблицы orders. Используя foreign keys свяжите 
записи из таблиц, согласно таблице
````bash
test_db=# update  clients set Заказ = 3 where id = 1;
UPDATE 1
test_db=# update  clients set Заказ = 4 where id = 2;
UPDATE 1
test_db=# update  clients set Заказ = 5 where id = 3;
UPDATE 1
test_db=# select * from clients;
 id |         ФИО          | Страна проживания | Заказ
----+----------------------+-------------------+-------
  4 | Ронни Джеймс Дио     | Russia            |
  5 | Ritchie Blackmore    | Russia            |
  1 | Иванов Иван Иванович | USA               |     3
  2 | Петров Петр Петрович | Canada            |     4
  3 | Иоганн Себастьян Бах | Japan             |     5
(5 rows)
````
5. Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 (используя директиву EXPLAIN).
Приведите получившийся результат и объясните что значат полученные значения.
````bash
test_db=# explain select * from clients where Заказ is not null;
                        QUERY PLAN
-----------------------------------------------------------
 Seq Scan on clients  (cost=0.00..18.10 rows=806 width=72)
   Filter: ("Заказ" IS NOT NULL)
(2 rows)

test_db=#
````
- Seq Scan — последовательное, блок за блоком, чтение данных таблицы clients. 
- cost - оценка затратности операции. Первое значение 0.00 — затраты на получение первой строки. 
  Второе — 18.10 — затраты на получение всех строк. 
- rows — приблизительное количество возвращаемых строк при выполнении операции Seq Scan. 
- width — средний размер одной строки в байтах.

6. Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).
- Остановите контейнер с PostgreSQL (но не удаляйте volumes). 
- Поднимите новый пустой контейнер с PostgreSQL. 
- Восстановите БД test_db в новом контейнере. 
- Приведите список операций, который вы применяли для бэкапа данных и восстановления.

Создаём бэкап БД test_db:
````bash
root@vb-micrapc:/home/micra# cd
root@vb-micrapc:~# docker exec -t postgres pg_dump -U test-admin-user test_db -f /var/lib/postgresql/backup/dump_test.sql
root@vb-micrapc:~# docker exec -t postgres ls -l /var/lib/postgresql/backup/
total 8
-rw-r--r-- 1 root root 4330 Jun  3 20:31 dump_test.sql
root@vb-micrapc:~#
````
Проверяем, отработала ли синхронизация подмонтированной папки на хостовой машине:
````bash
root@vb-micrapc:~# ls -l /opt/docker/volumes/backup/
total 8
-rw-r--r-- 1 root root 4330 июн  3 20:31 dump_test.sql
root@vb-micrapc:~#
````
Останавливаем первый контейнер:
````bash
root@vb-micrapc:~# docker stop postgres
postgres
root@vb-micrapc:~# 
````
Запускаем второй контейнер:
````bash
root@vb-micrapc:~#  docker run --rm --name postgres_backup -e POSTGRES_PASSWORD=123 -e POSTGRES_USER=test-admin-user -e POSTGRES_DB=test_db -d -p 5432:5432 -v /opt/docker/volumes/backup:/var/lib/postgresql/backup postgres:12
0d3e7ef720afc0d6f5d7049a55402f43a681cb18b2dc3d7606199e46d4926728
root@vb-micrapc:~# docker ps
CONTAINER ID   IMAGE         COMMAND                  CREATED          STATUS         PORTS                                       NAMES
0d3e7ef720af   postgres:12   "docker-entrypoint.s…"   10 seconds ago   Up 9 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres_backup
root@vb-micrapc:~#
````
Подключаемся к БД в запущенном контейнере, проверяем отсутсвие записей в БД test_db, :
````bash
root@vb-micrapc:~# psql -h 127.0.0.1 -U test-admin-user -d test_db
Password for user test-admin-user:
psql (14.3 (Ubuntu 14.3-0ubuntu0.22.04.1), server 12.11 (Debian 12.11-1.pgdg110+1))
Type "help" for help.

test_db=# \dt
Did not find any relations.
test_db=# \d+
Did not find any relations.
test_db=#
````
Восстанавливаем БД из бэкапа:
````bash
root@vb-micrapc:~# docker exec -i postgres_backup psql -U test-admin-user -d test_db -f /var/lib/postgresql/backup/dump_test.sql
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
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval
--------
      1
(1 row)

 setval
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
````