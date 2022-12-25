# devops-netology
### performed by Kirill Karagodin
#### HW 13.3 работа с kubectl

#### Подготовка
- подготовил кластер с помощью [terraform](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.1/terraform) 
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Devkub/HW_13.3/img/ya.JPG)
- Установку кластера произвел с помощью `kubespray`
````bash

PLAY RECAP ****************************************************************************************************************************************************
cp1                        : ok=705  changed=152  unreachable=0    failed=0    skipped=1230 rescued=0    ignored=8
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=484  changed=98   unreachable=0    failed=0    skipped=755  rescued=0    ignored=1
node2                      : ok=484  changed=98   unreachable=0    failed=0    skipped=754  rescued=0    ignored=1


````
- Работа будет выполняться на основе развернутых подов из домашнего задания [13.2](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Devkub/HW_13.2/README.md) в namespace `prod`
````bash
[centos@cp1 ~]$ kubectl get pods --namespace=prod
NAME                        READY   STATUS    RESTARTS   AGE
backend-85dccd89d6-mgh29    1/1     Running   0          29m
db-0                        1/1     Running   0          33m
frontend-5c6bc8c544-7vcpd   1/1     Running   0          29m
[centos@cp1 ~]$ kubectl get svc --namespace=prod -o wide
NAME       TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE   SELECTOR
backend    ClusterIP   10.233.18.211   <none>        9000/TCP   32m   app=backend
frontend   ClusterIP   10.233.5.158    <none>        8000/TCP   32m   app=frontend
postgres   ClusterIP   10.233.3.220    <none>        5432/TCP   33m   app=db
[centos@cp1 ~]$
````
#### Задание 1

Для проверки работы можно использовать 2 способа: port-forward и exec. Используя оба способа, проверьте каждый 
компонент:
- сделайте запросы к бекенду; 
- сделайте запросы к фронту; 
- подключитесь к базе данных.

#### Ответ
1. `exec`
- Запрос от `frontend` к `beckend`
````bash
[centos@cp1 ~]$ kubectl exec frontend-5c6bc8c544-7vcpd --namespace=prod -- curl -s backend.prod.svc.cluster.local:9000/api/news/
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}][centos@cp1 ~]$
[centos@cp1 ~]$
````
- Запрос от `beckend` к `frontend`
````bash
[centos@cp1 ~]$ kubectl exec backend-85dccd89d6-mgh29 --namespace=prod -- curl -s frontend.prod.svc.cluster.local:8000
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>[centos@cp1 ~]$
````
- Запрос к БД
````bash
[centos@cp1 ~]$ kubectl exec db-0 --namespace=prod -- psql -U postgres -d news -c \\dt
        List of relations
 Schema | Name | Type  |  Owner
--------+------+-------+----------
 public | news | table | postgres
(1 row)

[centos@cp1 ~]$
````
2. `port-forward`
  - Фронтенд
  ````bash
  [centos@cp1 ~]$ kubectl port-forward svc/frontend 8080:8000 --namespace=prod
Forwarding from 127.0.0.1:8080 -> 80
Forwarding from [::1]:8080 -> 80
Handling connection for 8080
  ````
  Проверка доступности
  ````bash
  [centos@cp1 ~]$ curl localhost:8080
<!DOCTYPE html>
<html lang="ru">
<head>
    <title>Список</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/build/main.css" rel="stylesheet">
</head>
<body>
    <main class="b-page">
        <h1 class="b-page__title">Список</h1>
        <div class="b-page__content b-items js-list"></div>
    </main>
    <script src="/build/main.js"></script>
</body>
</html>
[centos@cp1 ~]$
  ````
  - Бекенд
  ````bash
  [centos@cp1 ~]$ kubectl port-forward svc/backend 8080:9000 --namespace=prod
Forwarding from 127.0.0.1:8080 -> 9000
Forwarding from [::1]:8080 -> 9000
Handling connection for 8080
Handling connection for 8080
Handling connection for 8080
Handling connection for 8080
  ````
  Проверка доступности
  ````bash
[centos@cp1 ~]$ curl localhost:8080/api/news/
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}][centos@cp1 ~]$

  ````
  - БД
  ````bash
  [centos@cp1 ~]$ kubectl port-forward service/postgres 8081:5432 --namespace=prod
Forwarding from 127.0.0.1:8081 -> 5432
Forwarding from [::1]:8081 -> 5432
Handling connection for 8081
  ````
  Проверка доступности
  ````bash
  [centos@cp1 ~]$ psql -h localhost -p 8081 -U postgres
psql (9.2.24, server 13.9)
WARNING: psql version 9.2, server version 13.0.
         Some psql features might not work.
Type "help" for help.

postgres=# \l
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 news      | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
(4 rows)

postgres=#
  ````
#### Задание 2: ручное масштабирование

При работе с приложением иногда может потребоваться вручную добавить пару копий. Используя команду kubectl scale, 
попробуйте увеличить количество бекенда и фронта до 3. Проверьте, на каких нодах оказались копии после каждого 
действия (kubectl describe, kubectl get pods -o wide). После уменьшите количество копий до 1.

#### Ответ

- Поды до масштабирования
````bash
[centos@cp1 ~]$ kubectl get po --namespace=prod
NAME                        READY   STATUS    RESTARTS   AGE
backend-85dccd89d6-mgh29    1/1     Running   0          9h
db-0                        1/1     Running   0          9h
frontend-5c6bc8c544-7vcpd   1/1     Running   0          9h
[centos@cp1 ~]$
````
- Увеличил реплики фронтенд и бекенд до 3-х
````bash
[centos@cp1 ~]$ kubectl scale --replicas=3 deploy/frontend --namespace=prod
deployment.apps/frontend scaled
[centos@cp1 ~]$ kubectl scale --replicas=3 deploy/backend --namespace=prod
deployment.apps/backend scaled
[centos@cp1 ~]$ kubectl get po --namespace=prod
NAME                        READY   STATUS    RESTARTS   AGE
backend-85dccd89d6-25x25    1/1     Running   0          6s
backend-85dccd89d6-884jp    1/1     Running   0          6s
backend-85dccd89d6-mgh29    1/1     Running   0          9h
db-0                        1/1     Running   0          10h
frontend-5c6bc8c544-7vcpd   1/1     Running   0          9h
frontend-5c6bc8c544-9j8lp   1/1     Running   0          12s
frontend-5c6bc8c544-ll7nf   1/1     Running   0          12s
[centos@cp1 ~]$

````
- Уменьшил реплики фронтенд и бекенд до 1-й
````bash
[centos@cp1 ~]$ kubectl scale --replicas=1 deploy/frontend --namespace=prod
deployment.apps/frontend scaled
[centos@cp1 ~]$ kubectl scale --replicas=1 deploy/backend --namespace=prod
deployment.apps/backend scaled
[centos@cp1 ~]$ kubectl get po --namespace=prod
NAME                        READY   STATUS    RESTARTS   AGE
backend-85dccd89d6-mgh29    1/1     Running   0          10h
db-0                        1/1     Running   0          10h
frontend-5c6bc8c544-7vcpd   1/1     Running   0          10h
[centos@cp1 ~]$


````