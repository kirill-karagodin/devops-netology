# devops-netology
### performed by Kirill Karagodin
#### HW5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера.
1. Сценарий выполения задачи:
- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки 
на https://hub.docker.com/username_repo.
Установлен docker, скачен образ с nginx
````bash
root@vb-micrapc:/home/micra# docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
nginx         latest    fa5269854a5e   7 days ago     142MB
hello-world   latest    feb5d9fea6a5   7 months ago   13.3kB
root@vb-micrapc:/home/micra#
````
Запущенный контейнер:
````bash
root@vb-micrapc:/home/micra# docker ps -a
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS              PORTS                                   NAMES
3414857eb9bf   nginx     "/docker-entrypoint.…"   9 minutes ago   Up About a minute   0.0.0.0:8080->80/tcp, :::8080->80/tcp   naughty_moore
````
Внесены изменения в файл index.html
````bash
root@3414857eb9bf:/# cat /usr/share/nginx/html/index.html
<html><head>Hey, Netology</head><body><h1>I am DevOps Engineer!</h1></body></html>
root@3414857eb9bf:/#
````
Мои сетевые интерфейсы:
````bash
root@vb-micrapc:/home/micra# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:40:6a:f4 brd ff:ff:ff:ff:ff:ff
    inet 10.0.62.247/24 metric 100 brd 10.0.62.255 scope global dynamic enp0s3
       valid_lft 433sec preferred_lft 433sec
    inet6 fe80::a00:27ff:fe40:6af4/64 scope link
       valid_lft forever preferred_lft forever
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:42:15:c8:76 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:42ff:fe15:c876/64 scope link
       valid_lft forever preferred_lft forever
13: vethcd64195@if12: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default
    link/ether 0e:2a:d5:43:c1:b2 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::c2a:d5ff:fe43:c1b2/64 scope link
       valid_lft forever preferred_lft forever
root@vb-micrapc:/home/micra#
````
Вывод страницы в браузере ПК
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.3/nginx.jpg)
Создаем свой форк:
````bash
root@vb-micrapc:/home/micra# docker commit -m "Chahge index.html" -a "Karagodin Kirill" 3414857eb9bf kirillkaragodin/nginx-netology
sha256:b1b7d73a0fb37b793f8b55b4ea187bab6fd52d25db59478c50306fde8eea41d1
root@vb-micrapc:/home/micra# docker images
REPOSITORY                       TAG       IMAGE ID       CREATED              SIZE
kirillkaragodin/nginx-netology   latest    b1b7d73a0fb3   About a minute ago   142MB
nginx                            latest    fa5269854a5e   7 days ago           142MB
hello-world                      latest    feb5d9fea6a5   7 months ago         13.3kB
````
Логинимся в docker hub:
````bash
root@vb-micrapc:/home/micra# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: kirillkaragodin
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
root@vb-micrapc:/home/micra#
````
Заливаем свой контейнер:
````bash
root@vb-micrapc:/home/micra# docker push kirillkaragodin/nginx-netology
Using default tag: latest
The push refers to repository [docker.io/kirillkaragodin/nginx-netology]
e8a808d1569d: Pushed
b6812e8d56d6: Pushed
7046505147d7: Mounted from library/nginx
c876aa251c80: Pushed
f5ab86d69014: Mounted from library/nginx
4b7fffa0f0a4: Pushed
9c1b6dd6c1e6: Mounted from library/nginx
latest: digest: sha256:ab01821ab9e6dc0b304089db1a1bbdd7f235e303f47eeb3c30630f76db75f945 size: 1777
root@vb-micrapc:/home/micra#
````
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.3/dockerhub.jpg)
Ссылка на репозиторий в docker hub:
````url
https://hub.docker.com/r/kirillkaragodin/nginx-netology
````

2. Посмотрите на сценарий ниже и ответьте на вопрос: "Подходит ли в этом сценарии использование Docker контейнеров или 
лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"
Детально опишите и обоснуйте свой выбор.
Сценарий:
- Высоконагруженное монолитное java веб-приложение
````
Физический сервер, т.к. монолитное (доставляемое через единую систему развертывания с одной точкой входа), потому в 
микросерверах не реализуемо без изменения кода, и так как высоконагруженное (необходим физический доступ к ресурсам, 
виртуалка не подходит).
````
- Nodejs веб-приложение
````
Docker, и в рамках микропроцессрной архитектуры может быть хорошим решением.
````
- Мобильное приложение c версиями для Android и iOS
````
Виртуальная машина - приложение в докере не имеет графической оболочки
````
- Шина данных на базе Apache Kafka
````
 Виртуальная машина - для продакшена и критичности данных (если потеря данных при потере контейнера не является 
 критичной - можно использовать контейнеры)
````
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash 
и две ноды kibana
````
Виртуальная машина - Elasticsearvh, отказоустойчивость решается на уровне кластера, Docker - logstash и kibana.
````
- Мониторинг-стек на базе Prometheus и Grafana
````
Docker - системы не хранят данных.
````
- MongoDB, как основное хранилище данных для java-приложения
````
Виртуальная машина - посольку это хранилище, не высоконагруженное. физический сервер не подходит под базу данных,
т. к. затратно.
````
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
````
Docker-контейнеризация.
````
3. Задание
- Запустите первый контейнер из образа centos c любым тэгом в фоновом режиме, подключив папку /data из текущей рабочей
директории на хостовой машине в /data контейнера;
- Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на 
хостовой машине в /data контейнера;
- Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data; 
- Добавьте еще один файл в папку /data на хостовой машине; 
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.
Образы в системе
````bash
root@vb-micrapc:/home/micra# docker images
REPOSITORY                       TAG       IMAGE ID       CREATED        SIZE
kirillkaragodin/nginx-netology   latest    b1b7d73a0fb3   2 hours ago    142MB
nginx                            latest    fa5269854a5e   7 days ago     142MB
debian                           latest    a11311205db1   7 days ago     124MB
hello-world                      latest    feb5d9fea6a5   7 months ago   13.3kB
centos                           latest    5d0da3dc9764   7 months ago   231MB
````
Создаем папку /data
````bash
root@vb-micrapc:/home/micra# mkdir /opt/data
root@vb-micrapc:/home/micra#

````
Монтируем папку /data на хостовой машине в создаваемые контенейры из существующих образов
````bash
root@vb-micrapc:/home/micra# docker run -t -d --name Debian -v /opt/data:/opt/data:rw debian
935a5b778a483a6c97c077570f2341d48dcf226a8c2c95d810096c960c33cb4e
root@vb-micrapc:/home/micra# docker run -t -d --name Centos -v /opt/data:/opt/data:rw centos
b79cd370d9b1bb84e44dab1838b847eb77b24f6f7399b2e41da403b7b5735b05
root@vb-micrapc:/home/micra# docker ps -a
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
b79cd370d9b1   centos    "/bin/bash"   3 seconds ago    Up 2 seconds              Centos
935a5b778a48   debian    "bash"        23 seconds ago   Up 22 seconds             Debian
root@vb-micrapc:/home/micra#



````
Подключаемся к контейнеру Debian
````bash
root@vb-micrapc:/home/micra# docker exec -it Debian touch /opt/data/test_file_debian
root@vb-micrapc:/home/micra# docker attach Debian
root@935a5b778a

root@935a5b778a48:/# ls -l /opt/data
root@935a5b778a48:/# cd /opt/data
root@935a5b778a48:/# ls -l /opt/data/
total 0
-rw-r--r-- 1 root root 0 апр 27 18:44 test_file_debian
root@935a5b778a48:/#

````
Добавляем файл в папке /data на хостовой машине
````bash
root@vb-micrapc:/home/micra# touch /opt/data/test_file_host
root@vb-micrapc:/home/micra# ls -l /opt/data/
total 0
-rw-r--r-- 1 root root 0 апр 27 18:44 test_file_debian
-rw-r--r-- 1 root root 0 апр 27 18:50 test_file_host
root@vb-micrapc:/home/micra#
````
Подключаемся в Centos контейнер и смотрим листинг и содержание файлов в /data контейнера.
````bash
root@vb-micrapc:/home/micra# docker attach Centos
root@b79cd370d9b1:/#  ls -l /opt/data
total 0
-rw-r--r-- 1 root root 0 апр 27 18:44 test_file_debian
-rw-r--r-- 1 root root 0 апр 27 18:50 test_file_host
root@b79cd370d9b1:/#
````