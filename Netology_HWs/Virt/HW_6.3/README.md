# devops-netology
### performed by Kirill Karagodin
#### HW6.3 MySQL.

1. Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.
 - Изучите бэкап БД и восстановитесь из него. 
 - Перейдите в управляющую консоль mysql внутри контейнера. 
 - Используя команду \h получите список управляющих команд. 
 - Найдите команду для выдачи статуса БД и приведите в ответе из ее вывода версию сервера БД. 
 - Подключитесь к восстановленной БД и получите список таблиц из этой БД. 
 - Приведите в ответе количество записей с price > 300.
В следующих заданиях мы будем продолжать работу с данным контейнером.

Скачиваем контейнер, создаем том vol_mysql, копируем в созданный том дамп БД test_damp.sql
````bash
root@vb-micrapc:/# docker pull mysql:8.0
8.0: Pulling from library/mysql
c1ad9731b2c7: Pull complete
54f6eb0ee84d: Pull complete
cffcf8691bc5: Pull complete
89a783b5ac8a: Pull complete
6a8393c7be5f: Pull complete
af768d0b181e: Pull complete
810d6aaaf54a: Pull complete
2e014a8ae4c9: Pull complete
a821425a3341: Pull complete
3a10c2652132: Pull complete
4419638feac4: Pull complete
681aeed97dfe: Pull complete
Digest: sha256:548da4c67fd8a71908f17c308b8ddb098acf5191d3d7694e56801c6a8b2072cc
Status: Downloaded newer image for mysql:8.0
docker.io/library/mysql:8.0
root@vb-micrapc:/# docker volume create vol_mysql
vol_mysql
root@vb-micrapc:/# cp /opt/src_6.3/test_dump.sql /var/lib/docker/volumes/vol_mysql/_data/backup
root@vb-micrapc:/#
````
Запускаем контейнер со скачнным образом mysql 8.0, c окружением дефолтного юзера, задаем пароль, порт и подключаем папку
vol_mysql(с дампом БД) к контейнеру (в такой путь /etc/mysql/), указываем образ контейнера.
````bash
root@vb-micrapc:/# docker run --name mysql -it -e MYSQL_ROOT_PASSWORD=mysql -p 3306:3306 -v vol_mysql:/etc/mysql/ mysql:8.0
root@vb-micrapc:/#  docker ps
CONTAINER ID   IMAGE       COMMAND                  CREATED          STATUS          PORTS                                                  NAMES
1c33e87a6b68   mysql:8.0   "docker-entrypoint.s…"   12 minutes ago   Up 12 minutes   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql
root@vb-micrapc:/# 
````
Заходим внутрь контейнера и убеждаемся что в нашем контейнере действительно лежит dump базы данных
````bash
root@vb-micrapc:/# docker exec -it 1c33e87a6b68 bash
root@1c33e87a6b68:/# ls -l /etc/mysql/backup/
total 4
-rwxr-xr-x 1 root root 2073 Jun  7 18:14 test_dump.sql
root@1c33e87a6b68:/#
````
Создаем пустую базу данных test_db внутри контейнера
````bash
root@1c33e87a6b68:/# mysql -u root -p
Enter password:
mysql> create database test_db;
Query OK, 1 row affected (0.02 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)

mysql>
````
Перенаправляем бэкап в созданную базу данных
````bash
root@1c33e87a6b68:/# mysql -u root -p  < /etc/mysql/backup/test_dump.sql test_db
Enter password:
root@1c33e87a6b68:/# 
````
Просмотр восстановленных таблиц "orders"
````bash
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> select * from orders;
+----+-----------------------+-------+
| id | title                 | price |
+----+-----------------------+-------+
|  1 | War and Peace         |   100 |
|  2 | My little pony        |   500 |
|  3 | Adventure mysql times |   300 |
|  4 | Server gravity falls  |   300 |
|  5 | Log gossips           |   123 |
+----+-----------------------+-------+
5 rows in set (0.00 sec)

mysql>
````
Команда для выдачи статуса БД.
````bash
mysql> \s
--------------
mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          11
Current database:       test_db
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.29 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 32 min 8 sec

Threads: 2  Questions: 46  Slow queries: 0  Opens: 178  Flush tables: 3  Open tables: 96  Queries per second avg: 0.023
--------------

mysql>
````
Количество записей с price > 300;
````bash
mysql> select count(*) from orders where price >300;
+----------+
| count(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

mysql>
````
2. Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password 
- срок истечения пароля - 180 дней 
- количество попыток авторизации
- максимальное количество запросов в час - 100 
- аттрибуты пользователя:
Фамилия "Pretty" Имя "James"
Предоставьте привелегии пользователю test на операции SELECT базы test_db.
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю test и приведите в ответе к задаче.
````bash
mysql> CREATE USER test@localhost IDENTIFIED WITH mysql_native_password BY 'test';
Query OK, 0 rows affected (0.02 sec)

mysql> ALTER USER 'test'@'localhost' WITH MAX_QUERIES_PER_HOUR 100 PASSWORD EXPIRE INTERVAL 180 DAY FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 2;
Query OK, 0 rows affected (0.02 sec)

mysql> ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
Query OK, 0 rows affected (0.01 sec)

mysql> GRANT Select ON test_db.* TO 'test'@'localhost';
Query OK, 0 rows affected, 1 warning (0.02 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.01 sec)

mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.01 sec)

mysql>
````
3. Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
- на MyISAM 
- на InnoDB

Установливаем профилирование SET profiling = 1.
При выводе профилирования команд SHOW PROFILES наблюдаем скорость обработки запроса (duration);.
В таблице БД test_db используется Eengine InnoDB.
````bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> SHOW PROFILES;
Empty set, 1 warning (0.00 sec)

mysql> SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)

mysql> SHOW PROFILES;
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                             |
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
|        1 | 0.00102825 | SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db' |
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
2 rows in set, 1 warning (0.00 sec)

mysql>
````
Меняем движок ENGINE c InnoDB на MyISAM и обратно.
````bash
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> ALTER TABLE orders ENGINE = MyISAM;
Query OK, 5 rows affected (0.05 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE = InnoDB;
Query OK, 5 rows affected (0.07 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                             |
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
|        1 | 0.00102825 | SELECT TABLE_NAME,ENGINE FROM information_schema.TABLES WHERE table_name = 'orders' and  TABLE_SCHEMA = 'test_db' |
|        2 | 0.00011000 | SET profiling = 1                                                                                                 |
|        3 | 0.05267875 | ALTER TABLE orders ENGINE = MyISAM                                                                                |
|        4 | 0.07662025 | ALTER TABLE orders ENGINE = InnoDB                                                                                |
+----------+------------+-------------------------------------------------------------------------------------------------------------------+
6 rows in set, 1 warning (0.00 sec)

mysql>
````
4. Изучите файл my.cnf в директории /etc/mysql.
Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных 
- Нужна компрессия таблиц для экономии места на диске 
- Размер буффера с незакомиченными транзакциями 1 Мб 
- Буффер кеширования 30% от ОЗУ 
- Размер файла логов операций 100 Мб
Приведите в ответе измененный файл my.cnf.

Для редактирования my.cnf выходим из контейнера и редактируем файл на хостовой машине в директории 
/var/lib/docker/volumes/vol_mysql/_data/
Так как данная директория смонтирована в контейнер по пути /et c/mysql, то все изменения, внесенные на хостовой машине,
будут синхронизированы с контейнером
````bash
root@1c33e87a6b68:/# exit
exit
root@vb-micrapc:/# nano /var/lib/docker/volumes/vol_mysql/_data/my.cnf
````
Просмотр my.cnf из запущенного контейнера
````bash
root@1c33e87a6b68:/# cat /etc/mysql/my.cnf
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

#Скорость IO важнее сохранности данных
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DSYNC

#Размер файла логов операций 100 Мб(Обычно innodb_log_file_size 25% от innodb_buffer_pool_size)
innodb_log_file_size = 104857600

# движок базы данных InnoDB поддерживает несколько форматов файлов. По умолчанию в InnoDB используется «старый» формат Antelope
# Формат файлов Barracuda — самый «новый» и поддерживает компрессию
innodb_file_format=Barracuda

#Буффер кеширования 30% от ОЗУ. ОЗУ = 4ГБ.
innodb_buffer_pool_size  = 1228M

#Размер буффера с незакомиченными транзакциями 1 Мб
innodb_log_buffer_size = 1М

# Custom config should go here
!includedir /etc/mysql/conf.d/
root@1c33e87a6b68:/#
````
