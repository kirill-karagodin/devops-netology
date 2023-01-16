# devops-netology
### performed by Kirill Karagodin
#### HW 10.3 ELK

#### Задание 1

Вам необходимо поднять в докере:
- elasticsearch(hot и warm ноды)
- logstash 
- kibana 
- filebeat

и связать их между собой.

1. `Logstash` следует сконфигурировать для приёма по tcp json сообщений.
2. `Filebeat` следует сконфигурировать для отправки логов `docker` вашей системы в `logstash`. 
3. В директории `help` находится манифест docker-compose и конфигурации `filebeat/logstash` для быстрого выполнения 
данного задания.
Результатом выполнения данного задания должны быть:
- скриншот `docker ps` через 5 минут после старта всех контейнеров (их должно быть 5)
- скриншот интерфейса `kibana` 

#### Ответ

Для корректной работы были добавлены следующие правки:

1. В `docker-compose.yml`
   - изменены версии контейнеров
````
elasticsearch:7.16.2
kibana:7.16.2
logstash:7.16.2
filebeat:7.16.2
````
   - в секцию `filebeat` добавлено 
````bash
filebeat:
    networks:
      - elastic
````
2. В файл `logstash.conf`
````bash
input {
  beats {
    port => 5046
    codec => json
  }
}
-------------------
elasticsearch {
  hosts => ["es-hot:9200"]
  index => "logstash-%{+YYYY.MM.dd}"
}
````
Поднял `ELK`
````bash
mojnovse@mojno-vseMacBook help % docker-compose up -d
[+] Running 1/2
[+] Running 3/4_elastic  Created                                                                                                            0.1s
[+] Running 8/8_elastic  Created                                                                                                            0.1s
 ⠿ Network help_elastic  Created                                                                                                            0.1s
 ⠿ Network help_default  Created                                                                                                            0.6s
 ⠿ Container es-warm     Started                                                                                                            2.4s
 ⠿ Container some_app    Started                                                                                                            2.4s
 ⠿ Container es-hot      Started                                                                                                            6.8s
 ⠿ Container logstash    Started                                                                                                           12.0s
 ⠿ Container kibana      Started                                                                                                           12.0s
 ⠿ Container filebeat    Started                                                                                                           14.8s
mojnovse@mojno-vseMacBook help %

````
Вывод команды `docker ps`
````bash
mojnovse@mojno-vseMacBook help % docker ps
CONTAINER ID   IMAGE                                                  COMMAND                  CREATED          STATUS          PORTS                                        NAMES
74a084dfe63b   docker.elastic.co/beats/filebeat:7.2.0                 "/usr/local/bin/dock…"   23 minutes ago   Up 23 minutes                                                filebeat
b5b14d9e0e02   docker.elastic.co/logstash/logstash:6.3.2              "/usr/local/bin/dock…"   23 minutes ago   Up 23 minutes   5044/tcp, 9600/tcp, 0.0.0.0:5046->5046/tcp   logstash
e6088abd3bc3   docker.elastic.co/kibana/kibana:7.11.0                 "/bin/tini -- /usr/l…"   23 minutes ago   Up 23 minutes   0.0.0.0:5601->5601/tcp                       kibana
bc47d751cf2a   docker.elastic.co/elasticsearch/elasticsearch:7.11.0   "/bin/tini -- /usr/l…"   23 minutes ago   Up 23 minutes   0.0.0.0:9200->9200/tcp, 9300/tcp             es-hot
94b4a6078c72   python:3.9-alpine                                      "python3 /opt/run.py"    23 minutes ago   Up 23 minutes                                                some_app
c3ff67064722   docker.elastic.co/elasticsearch/elasticsearch:7.11.0   "/bin/tini -- /usr/l…"   23 minutes ago   Up 23 minutes   9200/tcp, 9300/tcp                           es-warm
````
Интерфейса `kibana`
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.4/img/elastic.JPG)

#### Задание 2

Перейдите в меню создания index-patterns в kibana и создайте несколько index-patterns из имеющихся.
Перейдите в меню просмотра логов в kibana (Discover) и самостоятельно изучите как отображаются логи и как производить 
поиск по логам.
В манифесте директории help также приведенно dummy приложение, которое генерирует рандомные события в stdout контейнера.
Данные логи должны порождать индекс logstash-* в elasticsearch. Если данного индекса нет - воспользуйтесь советами и
источниками из раздела "Дополнительные ссылки" данного ДЗ.

#### Ответ

- index-patterns в kibana
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.4/img/patterns.JPG)

- В меню просмотра логов
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.4/img/logs.JPG)