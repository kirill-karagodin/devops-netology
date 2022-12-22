# devops-netology
### performed by Kirill Karagodin
#### HW 13.1 контейнеры, поды, deployment, statefulset, services, endpoints

#### Подготовока

- подготовил кластер с помощью [terraform](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.1/terraform) 
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Devkub/HW_13.1/img/ya.JPG)
- Установку кластера произвел с помощью `kubespray`
````bash
........
PLAY RECAP ********************************************************************************************************************************
cp1                        : ok=702  changed=137  unreachable=0    failed=0    skipped=1231 rescued=0    ignored=8
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=481  changed=83   unreachable=0    failed=0    skipped=756  rescued=0    ignored=1
node2                      : ok=481  changed=83   unreachable=0    failed=0    skipped=755  rescued=0    ignored=1
........
[centos@cp1 ~]$ kubectl get nodes -o wide
NAME    STATUS   ROLES           AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                CONTAINER-RUNTIME
cp1     Ready    control-plane   12m   v1.25.4   192.168.101.11   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   docker://20.10.20
node1   Ready    <none>          11m   v1.25.4   192.168.101.12   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   docker://20.10.20
node2   Ready    <none>          11m   v1.25.4   192.168.101.13   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   docker://20.10.20

````
- Cобираем бэкэнд-компоненту и отправляем ее в Dockerhub-репозиторий
````bash
mojnovse@mojno-vseMacBook backend % sudo docker build -t kirillkaragodin/backend:1.0.0 .
[+] Building 1.6s (13/13) FINISHED
 ....                                                                                 0.0s

 => => writing image sha256:fd68b4f9f816776ed6a102e9dda8276fc24f657f75fa3133ca528c4f18b93da9                                                                                                    0.1s
 => => naming to docker.io/kirillkaragodin/backend:1.0.0                                                                                                                                        0.0s
mojnovse@mojno-vseMacBook backend % sudo docker push kirillkaragodin/backend:1.0.0
The push refers to repository [docker.io/kirillkaragodin/backend]
5d8815a8e049: Pushed
80a47af0b391: Pushed
944fb27a1f25: Pushed
d2281b8dba55: Pushed
5f70bf18a086: Mounted from kirillkaragodin/frontend
c044ccc8b849: Pushed
7ad4dc87a044: Pushed
e0ee5a2405e8: Mounted from library/python
0a67de8a9ec1: Pushed
97d47e63d0b5: Mounted from library/python
dec5d443c5c1: Mounted from library/node
753fac84fc56: Mounted from library/node
81fcd676802f: Mounted from library/node
6a1754327612: Mounted from library/node
3943af3b0cbd: Mounted from library/node
1.0.0: digest: sha256:2b57bb3c1d83fdbffcf3a92e983fa86c3209bf184077d726adaca8d6237ec98d size: 3470
mojnovse@mojno-vseMacBook backend %


````
- Cобираем фронтенд-компоненту и отправляем ее в Dockerhub-репозиторий
````bash
mojnovse@mojno-vseMacBook frontend % sudo docker build -t kirillkaragodin/frontend:1.0.0 .
Password:
[+] Building 29.8s (7/21)
 => [internal] load build definition from Dockerfile 
....

 => => writing image sha256:f7c59f4527817fe783b341a40d525b90f193e2f7d8930da49c1223ed0b34b051                                                                                                    0.0s
 => => naming to docker.io/kirillkaragodin/frontend:1.0.0                                                                                                                                       0.0s
mojnovse@mojno-vseMacBook frontend % sudo docker push kirillkaragodin/frontend:1.0.0
The push refers to repository [docker.io/kirillkaragodin/frontend]
ccd96acf4f48: Pushed
e0206b815eb5: Pushed
d8e9648ea2fe: Pushed
5f70bf18a086: Mounted from kirillkaragodin/backend
18b1f2e14941: Pushed
c72d75f45e5b: Mounted from library/nginx
9a0ef04f57f5: Mounted from library/nginx
d13aea24d2cb: Mounted from library/nginx
2b3eec357807: Mounted from library/nginx
2dadbc36c170: Mounted from library/nginx
8a70d251b653: Mounted from library/nginx
1.0.0: digest: sha256:8aaf03218c6a8b211c834010ed362b198dbaf8deb04bf402ed34f2ca4d2c16a5 size: 2607
mojnovse@mojno-vseMacBook frontend %
````
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Devkub/HW_13.1/img/hub.JPG)

#### Задание 1: подготовить тестовый конфиг для запуска приложения

Для начала следует подготовить запуск приложения в stage окружении с простыми настройками. Требования:
 - под содержит в себе 2 контейнера — фронтенд, бекенд; 
 - регулируется с помощью deployment фронтенд и бекенд; 
 - база данных — через statefulset

#### Ответ

- Создал namespace `stage`
````bash
[centos@cp1 ~]$ kubectl create namespace stage
namespace/stage created
[centos@cp1 ~]$ kubectl  get ns
NAME              STATUS   AGE
default           Active   60m
kube-node-lease   Active   60m
kube-public       Active   60m
kube-system       Active   60m
stage             Active   2s
[centos@cp1 ~]$
````
- deployment для [stage](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.1/stage)
- Запустил deployment для БД
````bash
[centos@cp1 stage]$ kubectl get po,svc,pv --namespace=stage -o wide
NAME       READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
pod/db-0   1/1     Running   0          58s   10.233.102.130   node1   <none>           <none>

NAME               TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/postgres   ClusterIP   10.233.4.78   <none>        5432/TCP   45s   app=db

NAME                  CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE   VOLUMEMODE
persistentvolume/pv   1Gi        RWO            Retain           Bound    stage/postgres-db-db-0                           51s   Filesystem
[centos@cp1 stage]$
````
- Запустил deployment для `frontend` и `beckend`
````bash
[centos@cp1 stage]$ kubectl apply -f app.yml --namespace=stage
deployment.apps/fron-back created
[centos@cp1 stage]$ kubectl get po --namespace=stage -o wide
NAME                         READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
db-0                         1/1     Running   0          3m22s   10.233.102.130   node1   <none>           <none>
fron-back-6dbb6dbb6f-xq7zz   2/2     Running   0          114s    10.233.75.2      node2   <none>           <none>
[centos@cp1 stage]$

````
- Проверяем работу `frontend`
````bash
[centos@cp1 stage]$ kubectl exec fron-back-6dbb6dbb6f-xq7zz   -c frontend --namespace=stage -- curl http://localhost:80
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
</html>  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   448  100   448    0     0  64000      0 --:--:-- --:--:-- --:--:--  218k
[centos@cp1 stage]$

````
Фронтенд работает
- Проверяем работу `backend`
````bash
[centos@cp1 stage]$ kubectl exec fron-back-6dbb6dbb6f-xq7zz -c backend --namespace=stage -- curl http://localhost:9000/api/news/
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  5182  100  5182    0     0  50310      0 --:--:-- --:--:-- --:--:-- 50310
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}][centos@cp1 stage]$
````
Бекенд работает, и имеет доступ к БД (в противном случае бекенд не поднялся бы на 9000 порту и в логе были видны ошибки)

#### Задание 2: подготовить конфиг для production окружения

Следующим шагом будет запуск приложения в production окружении. Требования сложнее:
 - каждый компонент (база, бекенд, фронтенд) запускаются в своем поде, регулируются отдельными deployment’ами; 
 - для связи используются service (у каждого компонента свой); 
 - в окружении фронта прописан адрес сервиса бекенда; 
 - в окружении бекенда прописан адрес сервиса базы данных.

#### Ответ

- Создал namespace `prod`
````bash
[centos@cp1 prod]$ kubectl create namespace prod
namespace/prod created
[centos@cp1 prod]$ kubectl  get ns
NAME              STATUS   AGE
default           Active   73m
kube-node-lease   Active   73m
kube-public       Active   73m
kube-system       Active   73m
prod              Active   6s
stage             Active   63m
[centos@cp1 prod]$
````
- Подготовил deployment для [prod](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.1/prod)
- Запустил deployment для БД
````bash
[centos@cp1 prod]$ kubectl apply -f db_sfs.yml --namespace=prod
statefulset.apps/db created
[centos@cp1 prod]$ kubectl apply -f db_pv.yml --namespace=prod
persistentvolume/pv-prod created
[centos@cp1 prod]$ kubectl apply -f db_svc.yml --namespace=prod
service/postgres created
[centos@cp1 prod]$ kubectl get po,svc,pv --namespace=prod -o wide
NAME       READY   STATUS    RESTARTS   AGE    IP               NODE    NOMINATED NODE   READINESS GATES
pod/db-0   1/1     Running   0          111s   10.233.102.131   node1   <none>           <none>

NAME               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/postgres   ClusterIP   10.233.19.80   <none>        5432/TCP   30s   app=db

NAME                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE   VOLUMEMODE
persistentvolume/pv        1Gi        RWO            Retain           Bound    stage/postgres-db-db-0                           66m   Filesystem
persistentvolume/pv-prod   1Gi        RWO            Retain           Bound    prod/postgres-db-db-0                            37s   Filesystem
[centos@cp1 prod]$
````
- Запустил deployment для `beckend`
````bash
[centos@cp1 prod]$ kubectl apply -f backend.yml --namespace=prod
deployment.apps/backend created
service/backend created
[centos@cp1 prod]$ kubectl get po,svc -l="app=backend" --namespace=prod -o wide
NAME                          READY   STATUS    RESTARTS   AGE   IP            NODE    NOMINATED NODE   READINESS GATES
pod/backend-cc4868c87-gwcj2   1/1     Running   0          8s    10.233.75.3   node2   <none>           <none>

NAME              TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/backend   ClusterIP   10.233.55.57   <none>        9000/TCP   8s    app=backend
[centos@cp1 prod]$
````
- Запустил deployment для `frontend`
````bash
[centos@cp1 prod]$ kubectl apply -f frontend.yml --namespace=prod
deployment.apps/frontend created
service/frontend created
[centos@cp1 prod]$ kubectl get po,svc -l="app=frontend" --namespace=prod -o wide
NAME                            READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
pod/frontend-85578c9f77-6pb9w   1/1     Running   0          27s   10.233.102.132   node1   <none>           <none>

NAME               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE   SELECTOR
service/frontend   ClusterIP   10.233.11.94   <none>        8000/TCP   27s   app=frontend
[centos@cp1 prod]$
````
- Проверяем работу `frontend`
````bash
[centos@cp1 prod]$ curl http://frontend.prod.svc.cluster.local:8000
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
</html>[centos@cp1 prod]$

````
- Проверяем работу `backend`
 ````bash
[centos@cp1 prod]$ curl http://backend.prod.svc.cluster.local:9000/api/news/
[{"id":1,"title":"title 0","short_description":"small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0small text 0","preview":"/static/image.png"},{"id":2,"title":"title 1","short_description":"small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1small text 1","preview":"/static/image.png"},{"id":3,"title":"title 2","short_description":"small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2small text 2","preview":"/static/image.png"},{"id":4,"title":"title 3","short_description":"small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3small text 3","preview":"/static/image.png"},{"id":5,"title":"title 4","short_description":"small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4small text 4","preview":"/static/image.png"},{"id":6,"title":"title 5","short_description":"small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5small text 5","preview":"/static/image.png"},{"id":7,"title":"title 6","short_description":"small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6small text 6","preview":"/static/image.png"},{"id":8,"title":"title 7","short_description":"small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7small text 7","preview":"/static/image.png"},{"id":9,"title":"title 8","short_description":"small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8small text 8","preview":"/static/image.png"},{"id":10,"title":"title 9","short_description":"small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9small text 9","preview":"/static/image.png"},{"id":11,"title":"title 10","short_description":"small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10small text 10","preview":"/static/image.png"},{"id":12,"title":"title 11","short_description":"small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11small text 11","preview":"/static/image.png"},{"id":13,"title":"title 12","short_description":"small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12small text 12","preview":"/static/image.png"},{"id":14,"title":"title 13","short_description":"small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13small text 13","preview":"/static/image.png"},{"id":15,"title":"title 14","short_description":"small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14small text 14","preview":"/static/image.png"},{"id":16,"title":"title 15","short_description":"small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15small text 15","preview":"/static/image.png"},{"id":17,"title":"title 16","short_description":"small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16small text 16","preview":"/static/image.png"},{"id":18,"title":"title 17","short_description":"small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17small text 17","preview":"/static/image.png"},{"id":19,"title":"title 18","short_description":"small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18small text 18","preview":"/static/image.png"},{"id":20,"title":"title 19","short_description":"small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19small text 19","preview":"/static/image.png"},{"id":21,"title":"title 20","short_description":"small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20small text 20","preview":"/static/image.png"},{"id":22,"title":"title 21","short_description":"small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21small text 21","preview":"/static/image.png"},{"id":23,"title":"title 22","short_description":"small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22small text 22","preview":"/static/image.png"},{"id":24,"title":"title 23","short_description":"small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23small text 23","preview":"/static/image.png"},{"id":25,"title":"title 24","short_description":"small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24small text 24","preview":"/static/image.png"}][centos@cp1 prod]$
````
- Список запущенных объектов каждого типа
````bash
[centos@cp1 prod]$ kubectl get po,deploy,sts,svc --namespace=prod -o wide
NAME                            READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
pod/backend-cc4868c87-gwcj2     1/1     Running   0          3m19s   10.233.75.3      node2   <none>           <none>
pod/db-0                        1/1     Running   0          6m58s   10.233.102.131   node1   <none>           <none>
pod/frontend-85578c9f77-6pb9w   1/1     Running   0          2m46s   10.233.102.132   node1   <none>           <none>

NAME                       READY   UP-TO-DATE   AVAILABLE   AGE     CONTAINERS   IMAGES                           SELECTOR
deployment.apps/backend    1/1     1            1           3m19s   backend      kirillkaragodin/backend:1.0.0    app=backend
deployment.apps/frontend   1/1     1            1           2m47s   frontend     kirillkaragodin/frontend:1.0.0   app=frontend

NAME                  READY   AGE     CONTAINERS   IMAGES
statefulset.apps/db   1/1     6m58s   db           postgres:13-alpine

NAME               TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)    AGE     SELECTOR
service/backend    ClusterIP   10.233.55.57   <none>        9000/TCP   3m19s   app=backend
service/frontend   ClusterIP   10.233.11.94   <none>        8000/TCP   2m46s   app=frontend
service/postgres   ClusterIP   10.233.19.80   <none>        5432/TCP   5m37s   app=db
[centos@cp1 prod]$
````

