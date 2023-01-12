# devops-netology
### performed by Kirill Karagodin
#### HW 10.3 Grafana

#### Задание 1

Используя директорию help внутри данного домашнего задания - запустите связку prometheus-grafana.
Зайдите в веб-интерфейс графана, используя авторизационные данные, указанные в манифесте docker-compose.
Подключите поднятый вами prometheus как источник данных.
Решение домашнего задания - скриншот веб-интерфейса grafana со списком подключенных Datasource.

#### Ответ

- Запустил связку
````bash
mojnovse@mojno-vseMacBook help % docker-compose -f docker-compose.yml up -d
[+] Running 0/3
 ⠼ grafana Pulling 
....

[+] Running 5/5
 ⠿ Network help_monitor-net    Created                                     0.2s
 ⠿ Volume "help_grafana_data"  Created                                     0.0s
 ⠿ Container nodeexporter      Started                                     3.2s
 ⠿ Container prometheus        Started                                     3.4s
 ⠿ Container grafana           Started                                     5.0s
mojnovse@mojno-vseMacBook help % docker-compose ps
NAME                COMMAND                  SERVICE             STATUS              PORTS
grafana             "/run.sh"                grafana             running             0.0.0.0:3000->3000/tcp
nodeexporter        "/bin/node_exporter …"   nodeexporter        running             9100/tcp
prometheus          "/bin/prometheus --c…"   prometheus          running             9090/tcp
mojnovse@mojno-vseMacBook help %
````
- Подключил поднятый prometheus как источник данных
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.3/img/prometheus.JPG)

#### Задание 2

Изучите самостоятельно ресурсы: 
- PromQL query to find CPU and memory 
- PromQL tutorial 
- Understanding Prometheus CPU metrics

Создайте Dashboard и в ней создайте следующие Panels:
- Утилизация CPU для nodeexporter (в процентах, 100-idle)
- CPULA 1/5/15 
- Количество свободной оперативной памяти 
- Количество места на файловой системе

Для решения данного ДЗ приведите promql запросы для выдачи этих метрик, а также скриншот получившейся Dashboard.

#### Ответ
- Утилизация CPU
````bash
100 - (avg by (instance) (rate(node_cpu_seconds_total{job="nodeexporter",mode="idle"}[1m])) * 100)
````
- CPULA 1/5/15
````bash
node_load1{job="nodeexporter"}
node_load5{job="nodeexporter"}
node_load15{job="nodeexporter"}
````
- Количество свободной оперативной памяти (Mb)
````bash
node_memory_MemFree_bytes / (1024 * 1024)
````
- Количество свободной оперативной памяти (%)
````bash
(node_memory_MemFree_bytes / node_memory_MemTotal_bytes) * 100
````
- Количество места на файловой системе
````bash
node_filesystem_free_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs|vfat"} / (1024 * 1024 *1024)
````
- Количество места на файловой системе
````bash
(node_filesystem_free_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs|vfat"} / node_filesystem_size_bytes{fstype!~"tmpfs|fuse.lxcfs|squashfs|vfat"}) * 100
````
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.3/img/dashboard.JPG)

#### Задание 3

Создайте для каждой Dashboard подходящее правило alert (можно обратиться к первой лекции в блоке "Мониторинг").
Для решения ДЗ - приведите скриншот вашей итоговой Dashboard.

#### Ответ
- Настроил отправку в Telegram
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.3/img/notification.JPG)
- Создал для каждой панели подходящее правило alert 
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.3/img/alerts.JPG)
- Стресс тест не проводил, но тестовая отправка прошла успешно
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.3/img/telega.JPG)
#### Задание 4

Сохраните ваш Dashboard.
Для этого перейдите в настройки Dashboard, выберите в боковом меню "JSON MODEL".
Далее скопируйте отображаемое json-содержимое в отдельный файл и сохраните его.
В решении задания - приведите листинг этого файла.

#### Ответ

[Ссылка на json](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_10.3/src/My First Dashboard.json)