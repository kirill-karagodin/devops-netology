# devops-netology
### performed by Kirill Karagodin
#### HW6.5 Elasticsearch.

1. Используя докер образ centos:7 как базовый и документацию по установке и запуску Elasticsearch:

В связи с ограничениями на скачивания архивов на прямую (403 ошибка при прямом подключении) файлы elasticsearch,
необходимые для выполнения задания были скачены отдельно по средствам VPN, и расположенны на хостовой машине рядом с 
файлом dokerfile
````bash
root@vb-micrapc:/opt/elasticsearch# ls -l
total 513796
-rw-r--r-- 1 root root       796 июн 18 17:11 dockerfile
-rwxr-xr-x 1 root root 526111529 июн 18 15:51 elasticsearch-8.2.3-linux-x86_64.tar.gz
-rwxr-xr-x 1 root root       170 июн 18 16:31 elasticsearch-8.2.3-linux-x86_64.tar.gz.sha512
root@vb-micrapc:/opt/elasticsearch#
````
dockerfile
````bash
root@vb-micrapc:/opt/elasticsearch# cat dockerfile
FROM centos:7

EXPOSE 9200

USER 0

COPY elasticsearch-8.2.3-linux-x86_64.tar.gz /opt
COPY elasticsearch-8.2.3-linux-x86_64.tar.gz.sha512 /opt

RUN cd  /opt && \
mkdir elasticsearch-8.2.3 && \
sha512sum -c elasticsearch-8.2.3-linux-x86_64.tar.gz.sha512 && \
tar -xzf elasticsearch-8.2.3-linux-x86_64.tar.gz -C elasticsearch-8.2.3  && \
rm -f elasticsearch-8.2.3-linux-x86_64.tar.gz* && \
mv elasticsearch-8.2.3 /var/lib/elasticsearch && \
adduser -m -u 1000 elastic && \
chown elastic:elastic -R /var/lib/elasticsearch && \
cd /var/lib/elasticsearch && \
cd elasticsearch-8.2.3/ && \
echo "node.name: netology_test" >> config/elasticsearch.yml && \
echo "network.host: 127.0.0.1" >> config/elasticsearch.yml && \
echo "path.data: /var/lib/elasticsearch" >> config/elasticsearch.yml

USER elastic

CMD /var/lib/elasticsearch/elasticsearch-8.2.3/bin/elasticsearch
root@vb-micrapc:/opt/elasticsearch#

````
Создание docker контейнера
````bash
root@vb-micrapc:/opt/elasticsearch# docker build . -t kirillkaragodin/devops-elasticsearch:8.2.3
Sending build context to Docker daemon  526.1MB
Step 1/8 : FROM centos:7
 ---> eeb6ee3f44bd
Step 2/8 : EXPOSE 9200
 ---> Running in c0a179f7fd44
Removing intermediate container c0a179f7fd44
 ---> 27c455c74271
Step 3/8 : USER 0
 ---> Running in 474840f714bd
Removing intermediate container 474840f714bd
 ---> 8321ded2d0e5
Step 4/8 : COPY elasticsearch-8.2.3-linux-x86_64.tar.gz /opt
 ---> 4885e8223f62
Step 5/8 : COPY elasticsearch-8.2.3-linux-x86_64.tar.gz.sha512 /opt
 ---> 85b9e54fc4ff
Step 6/8 : RUN cd  /opt && mkdir elasticsearch-8.2.3 && sha512sum -c elasticsearch-8.2.3-linux-x86_64.tar.gz.sha512 && tar -xzf elasticsearch-8.2.3-linux-x86_64.tar.gz -C elasticsearch-8.2.3  && rm -f elasticsearch-8.2.3-linux-x86_64.tar.gz* && mv elasticsearch-8.2.3 /var/lib/elasticsearch && adduser -m -u 1000 elastic && chown elastic:elastic -R /var/lib/elasticsearch && cd /var/lib/elasticsearch && cd elasticsearch-8.2.3/ && echo "node.name: netology_test" >> config/elasticsearch.yml && echo "network.host: 127.0.0.1" >> config/elasticsearch.yml && echo "path.data: /var/lib/elasticsearch" >> config/elasticsearch.yml
 ---> Running in 657c4cf01569
elasticsearch-8.2.3-linux-x86_64.tar.gz: OK
Removing intermediate container 657c4cf01569
 ---> 1e57c1fc8840
Step 7/8 : USER elastic
 ---> Running in 79673ce8cb25
Removing intermediate container 79673ce8cb25
 ---> d3a1db2a705c
Step 8/8 : CMD /var/lib/elasticsearch/elasticsearch-8.2.3/bin/elasticsearch
 ---> Running in 6daa19488776
Removing intermediate container 6daa19488776
 ---> 27b1a79d03df
Successfully built 27b1a79d03df
Successfully tagged kirillkaragodin/devops-elasticsearch:8.2.3
root@vb-micrapc:/opt/elasticsearch#

````
Cделайте push в ваш docker.io репозиторий
````bash
root@vb-micrapc:/opt/elasticsearch# docker push kirillkaragodin/devops-elasticsearch:8.2.3
The push refers to repository [docker.io/kirillkaragodin/devops-elasticsearch]
0231f3abcc5a: Pushed
2c7bf4eefd21: Pushed
00530db99b05: Pushed
174f56854903: Mounted from library/centos
8.2.3: digest: sha256:6415e20f688e5fb81d442823a7a9270af5becebbe2e3b5aef54b7b0f52b1d3e4 size: 1162
root@vb-micrapc:/opt/elasticsearch#
````
Ссылка на репозиторий
* [Ссылка на репозиторий](https://hub.docker.com/repository/docker/kirillkaragodin/devops-elasticsearch)

Запуск контейнера и просмотр его статуса
````bash
root@vb-micrapc:/opt/elasticsearch# docker run --rm -d --name elastic -p 9200:9200 kirillkaragodin/devops-elasticsearch:8.2.3
ef4b4f77973201f980afb9f42ca1b6e7126c10dee12e1004485e0ad37b966a21
root@vb-micrapc:/opt/elasticsearch# docker ps -a
CONTAINER ID   IMAGE                                        COMMAND                  CREATED          STATUS         PORTS                                       NAMES
ef4b4f779732   kirillkaragodin/devops-elasticsearch:8.2.3   "/bin/sh -c /var/lib…"   10 seconds ago   Up 8 seconds   0.0.0.0:9200->9200/tcp, :::9200->9200/tcp   elastic
root@vb-micrapc:/opt/elasticsearch#

````
Смена пароля
````bash
root@vb-micrapc:/opt/elasticsearch# docker exec -it elastic /var/lib/elasticsearch/elasticsearch-8.2.3/bin/elasticsearch-reset-password -u elastic
This tool will reset the password of the [elastic] user to an autogenerated value.
The password will be printed in the console.
Please confirm that you would like to continue [y/N]y


Password for the [elastic] user successfully reset.
New value: jVYj1FjNVVgYLH8T8Kfd
````
Проверка подключения
````bash
root@vb-micrapc:/opt/elasticsearch# docker exec -it elastic  curl -ku elastic http://localhost:9200
Enter host password for user 'elastic':
{
  "name" : "netology_test",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "MATRSKpvSt-Wqlh0nEsv8A",
  "version" : {
    "number" : "8.2.3",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "9905bfb62a3f0b044948376b4f607f70a8a151b4",
    "build_date" : "2022-06-08T22:21:36.455508792Z",
    "build_snapshot" : false,
    "lucene_version" : "9.1.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
root@vb-micrapc:/opt/elasticsearch#

````

2. Ознакомьтесь с документацией и добавьте в elasticsearch 3 индекса, в соответствии с таблицей
````bash
|  Имя  | Количество реплик | Количество шард |
|-------|-------------------|-----------------|
| ind-1 |         0         |        1        |
| ind-2 |         1         |        2        |
| ind-3 |         2         |        4        |
````
ind-1
````bash
$ curl -ku elastic https://localhost:9200
Enter host password for user 'elastic':
curl: (35) SSL received a record that exceeded the maximum permissible length.
[elastic@ef4b4f779732 /]$ curl -ku elastic -X PUT "http://localhost:9200/ind-1" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,
>       "number_of_replicas": 0
>      }
>    }
> }
> '
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}
````
ind-2
````bash
$ curl -ku elastic -X PUT "http://localhost:9200/ind-2" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>        "number_of_shards": 2,
>        "number_of_replicas": 1
>      }
>    }
> }
> '
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}
````
ind-3
````bash
$ curl -ku elastic https://localhost:9200
Enter host password for user 'elastic':
curl: (35) SSL received a record that exceeded the maximum permissible length.
[elastic@ef4b4f779732 /]$ curl -ku elastic -X PUT "http://localhost:9200/ind-1" -H 'Content-Type: application/json' -d'
> {
>   "settings": {
>     "index": {
>       "number_of_shards": 1,
>       "number_of_replicas": 0
>      }
>    }
> }
> '
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}
````
Получите список индексов и их статусов, используя API и приведите в ответе на задание.
````bash
$ curl -ku elastic http://localhost:9200/_cat/indices
Enter host password for user 'elastic':
yellow open ind-2 nHvRpf_rQzyK_5JJlnFrkQ 2 1 0 0 450b 450b
green  open ind-1 ihWpuYEoQj2QLAC6W0REEQ 1 0 0 0 225b 225b
yellow open ind-3 OgTMde8VT_uzU9vYR3MqHQ 4 2 0 0 900b 900b

````
Получите состояние кластера elasticsearch, используя API.
````bash
 curl -ku elastic http://localhost:9200/_cluster/health?pretty
Enter host password for user 'elastic':
{
  "cluster_name" : "elasticsearch",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}

````
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?
````bash
"Yellow" индексы созданы с количеством реплик и шард больше имеющихся. Кластер в состоянии "yellow" потому, 
что количество unassigned_shards > 0.
````
Удалите все индексы.
````bash
$ curl -ku elastic -X DELETE http://localhost:9200/ind-1
Enter host password for user 'elastic':
{"acknowledged":true}
[elastic@ef4b4f779732 /]$ curl -ku elastic -X DELETE http://localhost:9200/ind-2
Enter host password for user 'elastic':
{"acknowledged":true}
[elastic@ef4b4f779732 /]$ curl -ku elastic -X DELETE http://localhost:9200/ind-3
Enter host password for user 'elastic':
{"acknowledged":true}
````
3. Создайте директорию {путь до корневой директории с elasticsearch в образе}/snapshots.
````bash
root@vb-micrapc:/opt/elasticsearch# docker exec -it elastic mkdir /var/lib/elasticsearch/elasticsearch-8.2.3/snapshots
````
Используя API зарегистрируйте данную директорию как snapshot repository c именем netology_backup.
Приведите в ответе запрос API и результат вызова API для создания репозитория.
````bash
root@vb-micrapc:/opt/elasticsearch# docker exec -it elastic echo "path.repo: /var/lib/elasticsearch/snapshots" >> /var/lib/elasticsearch/elasticsearch-8.2.3/config/elasticsearch.yml
root@vb-micrapc:/opt/elasticsearch# docker restart elastic
````
Приведите в ответе запрос API и результат вызова API для создания репозитория.
````bash

$ curl -ku elastic -X PUT "http://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
> {
>   "type": "fs",
>   "settings": {
>     "location": "/var/lib/elasticsearch/snapshots",
>     "compress": true
>   }
> }
> '
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
````
Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.
- Создание индекса test
````bash
$ curl -ku elastic -X PUT http://localhost:9200/test -H 'Content-Type: application/json' -d'
> {
> "settings": {
> "number_of_replicas": 0,
> "number_of_shards": 1
> }
> }
> '
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"test"}
````
- Вывод списка индексов
````bash
$ curl -ku elastic -X GET 'http://localhost:9200/_cat/indices?v'
Enter host password for user 'elastic':
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  H44bu7CFTr63POTO_m5boQ   1   0          0            0       225b           225b
````
- Создайте snapshot состояния кластера elasticsearch.
````bash
$ curl -ku elastic -X PUT http://localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
Enter host password for user 'elastic':
{"snapshot":{"snapshot":"elasticsearch","uuid":"1B7cjn_0RYWnj1CFW7g6fw","repository":"netology_backup","version_id":8020399,"version":"8.2.3","indices":[".geoip_databases","test",".security-7"],"data_streams":[],"include_global_state":true,"state":"SUCCESS","start_time":"2022-06-19T11:59:45.831Z","start_time_in_millis":1655639985831,"end_time":"2022-06-19T11:59:47.042Z","end_time_in_millis":1655639987042,"duration_in_millis":1211,"failures":[],"shards":{"total":3,"failed":0,"successful":3},"feature_states":[{"feature_name":"geoip","indices":[".geoip_databases"]},{"feature_name":"security","indices":[".security-7"]}]}}
````
Приведите в ответе список файлов в директории со snapshot-ами.
````bash
$ ls -la /var/lib/elasticsearch/snapshots/
total 48
drwxr-xr-x 3 elastic elastic  4096 Jun 19 11:59 .
drwxr-xr-x 1 elastic elastic  4096 Jun 19 12:00 ..
-rw-r--r-- 1 elastic elastic  1098 Jun 19 11:59 index-0
-rw-r--r-- 1 elastic elastic     8 Jun 19 11:59 index.latest
drwxr-xr-x 5 elastic elastic  4096 Jun 19 11:59 indices
-rw-r--r-- 1 elastic elastic 18532 Jun 19 11:59 meta-1B7cjn_0RYWnj1CFW7g6fw.dat
-rw-r--r-- 1 elastic elastic   392 Jun 19 11:59 snap-1B7cjn_0RYWnj1CFW7g6fw.dat

````
Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.
- Удаление индекса test
````bash
$ curl -ku elastic -X DELETE 'http://localhost:9200/test?pretty'
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
````
- Создание индекса test-2
````bash
$ curl -ku elastic -X PUT http://localhost:9200/test-2 -H 'Content-Type: application/json' -d' { "settings": { "number_of_replicas": 0, "number_of_shards": 1 } } '
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"}[
````
- Вывод списка индексов
````bash
$ curl -ku elastic -X GET 'http://localhost:9200/_cat/indices?v'
Enter host password for user 'elastic':
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 JSYP3bYwQ7Shxd2Of4xnpQ   1   0          0            0       225b           225b
````
Восстановите состояние кластера elasticsearch из snapshot, созданного ранее.
````bash
$ curl -ku elastic -X POST 'http://localhost:9200/test-2/_close?pretty'
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "indices" : {
    "test-2" : {
      "closed" : true
    }
  }
}
$ curl -ku elastic -X POST 'http://localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?wait_for_completion=true'
Enter host password for user 'elastic':
{"snapshot":{"snapshot":"elasticsearch","indices":["test"],"shards":{"total":1,"failed":0,"successful":1}}}
````
Приведите в ответе запрос к API восстановления и итоговый список индексов.
````bash
$ curl -ku elastic -X GET 'http://localhost:9200/_cat/indices?v'
Enter host password for user 'elastic':
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test   ndeo8rMWT5S0k0gwYPqKmQ   1   0          0            0     225b          225b
green  close  test-2 JSYP3bYwQ7Shxd2Of4xnpQ   1   0

````