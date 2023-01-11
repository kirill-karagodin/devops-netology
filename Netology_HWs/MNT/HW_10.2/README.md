# devops-netology
### performed by Kirill Karagodin
#### HW 10.2 Системы мониторинга

#### Обязательные задания

1. Опишите основные плюсы и минусы pull и push систем мониторинга.

- Push системы удобно использовать когда собирается большое количество метрик и неустойчивый канал связи между агентами 
и системой мониторинга. Можно переключать передачу данных между udp и tcp, тем самым выбирая между экономией трафика
или гарантией доставки. Гибкая настройка частоты и объёма передаваемых метрик. К плюсам данной модели можно отнести её
использование в динамически меняющемся окружении, т.к. метрики с агентов сами будут поступать в систему мониторинга без
её дополнительной настройки.
- Pull системы мониторинга позволяют контролировать источники откуда принимать метрики. Можно защитить канал связи между
агентами и системой мониторинга шифрованием. Упрощённая отладка получения метрик с агентов. К минусам можно отнести 
сложность мониторинга динамически изменяющегося окружения

2. Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?

- **Prometheus** - Pull. Можно отправлять метрики по Push модели при помощи push gateway, но Prometheus будет из забирать 
как pull
- **TICK** Push. Агент Telegraf отправляет данные в БД InfluxDB. Telegraf при этом можно настроить на работу по Pull 
модели
- **Zabbix** - Push и Pull
- **VictoriaMetrics** - Push
- **Nagios** - Pull

3. Склонируйте себе репозиторий и запустите TICK-стэк, используя технологии docker и docker-compose.(по инструкции 
./sandbox up )
В виде решения на это упражнение приведите выводы команд с вашего компьютера (виртуальной машины):
````bash
- curl http://localhost:8086/ping
- curl http://localhost:8888
- curl http://localhost:9092/kapacitor/v1/ping
````
А также скриншот веб-интерфейса ПО chronograf (http://localhost:8888).
P.S.: если при запуске некоторые контейнеры будут падать с ошибкой - проставьте им режим `Z`, например `./data:/var/lib:Z`

**Ответ** 

- Склонировал репозиторий
````bash
mojnovse@mojno-vseMacBook HW_10.2 % git clone https://github.com/influxdata/sandbox.git
Cloning into 'sandbox'...
remote: Enumerating objects: 1718, done.
remote: Counting objects: 100% (32/32), done.
remote: Compressing objects: 100% (22/22), done.
remote: Total 1718 (delta 13), reused 25 (delta 10), pack-reused 1686
Receiving objects: 100% (1718/1718), 7.17 MiB | 5.42 MiB/s, done.
Resolving deltas: 100% (946/946), done.
mojnovse@mojno-vseMacBook HW_10.2 % ls -la
total 0
drwxr-xr-x   3 mojnovse  staff   96 Jan 11 13:46 .
drwxr-xr-x   7 mojnovse  staff  224 Jan 11 13:36 ..
drwxr-xr-x  17 mojnovse  staff  544 Jan 11 13:46 sandbox
mojnovse@mojno-vseMacBook HW_10.2 % cd sandbox
mojnovse@mojno-vseMacBook sandbox % ls -la
total 88
drwxr-xr-x  17 mojnovse  staff   544 Jan 11 13:46 .
drwxr-xr-x   3 mojnovse  staff    96 Jan 11 13:46 ..
-rw-r--r--   1 mojnovse  staff   120 Jan 11 13:46 .env
-rw-r--r--   1 mojnovse  staff   127 Jan 11 13:46 .env-latest
-rw-r--r--   1 mojnovse  staff   133 Jan 11 13:46 .env-nightlies
drwxr-xr-x  13 mojnovse  staff   416 Jan 11 13:46 .git
-rw-r--r--   1 mojnovse  staff    47 Jan 11 13:46 .gitignore
-rw-r--r--   1 mojnovse  staff  1081 Jan 11 13:46 LICENSE
-rw-r--r--   1 mojnovse  staff  3260 Jan 11 13:46 README.md
-rw-r--r--   1 mojnovse  staff  2547 Jan 11 13:46 docker-compose.yml
drwxr-xr-x   8 mojnovse  staff   256 Jan 11 13:46 documentation
drwxr-xr-x   6 mojnovse  staff   192 Jan 11 13:46 images
drwxr-xr-x   3 mojnovse  staff    96 Jan 11 13:46 influxdb
drwxr-xr-x   3 mojnovse  staff    96 Jan 11 13:46 kapacitor
-rwxr-xr-x   1 mojnovse  staff  5210 Jan 11 13:46 sandbox
-rw-r--r--   1 mojnovse  staff  4798 Jan 11 13:46 sandbox.bat
drwxr-xr-x   3 mojnovse  staff    96 Jan 11 13:46 telegraf
mojnovse@mojno-vseMacBook sandbox %
````
- Запустил стек
````bash

[+] Running 6/6
 ⠿ Network sandbox_default            Created                              0.1s
 ⠿ Container sandbox-influxdb-1       St...                                7.5s
 ⠿ Container sandbox-documentation-1  Started                              7.3s
 ⠿ Container sandbox-kapacitor-1      S...                                 6.7s
 ⠿ Container sandbox-telegraf-1       St...                                6.6s
 ⠿ Container sandbox-chronograf-1     Started                              9.3s
Opening tabs in browser...
mojnovse@mojno-vseMacBook sandbox %
````
- Вывод команды `curl http://localhost:8086/ping -v`
````bash
mojnovse@mojno-vseMacBook sandbox % curl http://localhost:8086/ping -v
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8086 (#0)
> GET /ping HTTP/1.1
> Host: localhost:8086
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 204 No Content
< Content-Type: application/json
< Request-Id: db356dbd-919d-11ed-8017-0242ac120003
< X-Influxdb-Build: OSS
< X-Influxdb-Version: 1.8.10
< X-Request-Id: db356dbd-919d-11ed-8017-0242ac120003
< Date: Wed, 11 Jan 2023 10:51:09 GMT
<
* Connection #0 to host localhost left intact
* Closing connection 0
mojnovse@mojno-vseMacBook sandbox %
````
- Вывод команды curl `http://localhost:8888 -v`
````bash
mojnovse@mojno-vseMacBook sandbox % curl http://localhost:8888 -v
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8888 (#0)
> GET / HTTP/1.1
> Host: localhost:8888
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 200 OK
< Accept-Ranges: bytes
< Cache-Control: public, max-age=3600
< Content-Length: 414
< Content-Security-Policy: script-src 'self'; object-src 'self'
< Content-Type: text/html; charset=utf-8
< Etag: ubyGAbz3Tc69bqd3w45d4WQtqoI=
< Vary: Accept-Encoding
< X-Chronograf-Version: 1.10.0
< X-Content-Type-Options: nosniff
< X-Frame-Options: SAMEORIGIN
< X-Xss-Protection: 1; mode=block
< Date: Wed, 11 Jan 2023 10:51:49 GMT
<
* Connection #0 to host localhost left intact
<!DOCTYPE html><html><head><link rel="stylesheet" href="/index.c708214f.css"><meta http-equiv="Content-type" content="text/html; charset=utf-8"><title>Chronograf</title><link rel="icon shortcut" href="/favicon.70d63073.ico"></head><body> <div id="react-root" data-basepath=""></div> <script type="module" src="/index.e81b88ee.js"></script><script src="/index.a6955a67.js" nomodule="" defer></script> </body></html>* Closing connection 0
mojnovse@mojno-vseMacBook sandbox %
````
- Вывод команды curl `http://localhost:9092/kapacitor/v1/ping -v`
````bash
mojnovse@mojno-vseMacBook sandbox % curl http://localhost:9092/kapacitor/v1/ping -v
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 9092 (#0)
> GET /kapacitor/v1/ping HTTP/1.1
> Host: localhost:9092
> User-Agent: curl/7.64.1
> Accept: */*
>
< HTTP/1.1 204 No Content
< Content-Type: application/json; charset=utf-8
< Request-Id: a21e2468-919e-11ed-806f-0242ac120004
< X-Kapacitor-Version: 1.6.5
< Date: Wed, 11 Jan 2023 10:56:42 GMT
<
* Connection #0 to host localhost left intact
* Closing connection 0
mojnovse@mojno-vseMacBook sandbox %
````
- Скриншот интерфейса
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.2/img/status.JPG)

4. Изучите список `telegraf inputs`.
- Добавьте в конфигурацию `telegraf` плагин - `disk`:
````bash
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
````
- Так же добавьте в конфигурацию `telegraf` плагин - `mem`:
````bash
[[inputs.mem]]
````
- После настройки перезапустите telegraf. 
- Перейдите в веб-интерфейс Chronograf (http://localhost:8888) и откройте вкладку Data explorer. 
- Нажмите на кнопку Add a query 
- Изучите вывод интерфейса и выберите БД telegraf.autogen 
- В measurments выберите mem->host->telegraf_container_id , а в fields выберите used_percent. Внизу появится график 
утилизации оперативной памяти в контейнере telegraf. 
- Вверху вы можете увидеть запрос, аналогичный SQL-синтаксису. Поэкспериментируйте с запросом, попробуйте изменить
группировку и интервал наблюдений. 
- Приведите скриншот с отображением метрик утилизации места на диске (disk->host->telegraf_container_id) 
из веб-интерфейса.

**Ответ** 

Для того что бы выполнить задание предварительно в telegraf.conf добавляем инпуты по диску и памяти
````bash
mojnovse@mojno-vseMacBook sandbox % cat telegraf/telegraf.conf
[agent]
  interval = "5s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "5s"
  flush_jitter = "0s"
  precision = ""
  debug = false
  quiet = false
  logfile = ""
  hostname = "$HOSTNAME"
  omit_hostname = false

[[outputs.influxdb]]
  urls = ["http://influxdb:8086"]
  database = "telegraf"
  username = ""
  password = ""
  retention_policy = ""
  write_consistency = "any"
  timeout = "5s"

[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
  container_names = []
  timeout = "5s"
  perdevice = true
  total = false

[[inputs.cpu]]
[[inputs.system]]
[[inputs.influxdb]]
  urls = ["http://influxdb:8086/debug/vars"]
[[inputs.syslog]]
#   ## Specify an ip or hostname with port - eg., tcp://localhost:6514, tcp://10.0.0.1:6514
#   ## Protocol, address and port to host the syslog receiver.
#   ## If no host is specified, then localhost is used.
#   ## If no port is specified, 6514 is used (RFC5425#section-4.1).
  server = "tcp://localhost:6514"
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

[[inputs.mem]]
mojnovse@mojno-vseMacBook sandbox %
````
Метрика mem->host->telegraf_container_id->used_percent
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.2/img/mem.JPG)

Метрика disk->host->telegraf_container_id->used_percent
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.2/img/disk.JPG)

5. Добавьте в конфигурацию telegraf следующий плагин - docker:
````bash
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
````
Дополнительно вам может потребоваться донастройка контейнера telegraf в docker-compose.yml дополнительного volume и 
режима privileged:
````bash
  telegraf:
    image: telegraf:1.4.0
    privileged: true
    volumes:
      - ./etc/telegraf.conf:/etc/telegraf/telegraf.conf:Z
      - /var/run/docker.sock:/var/run/docker.sock:Z
    links:
      - influxdb
    ports:
      - "8092:8092/udp"
      - "8094:8094"
      - "8125:8125/udp"
````
После настройки перезапустите telegraf, обновите веб интерфейс и приведите скриншотом список measurments в 
веб-интерфейсе базы telegraf.autogen. Там должны появиться метрики, связанные с docker.

**Ответ** 

В конфигурационном файле `telegraf.conf` уже был добавлен плагин `docker`
Добавил в `docker-compose.yml` `privileged: true` и `ports:`

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.2/img/docker.JPG)

