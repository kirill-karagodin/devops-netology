# devops-netology
### performed by Kirill Karagodin
#### HW 13.2 разделы и монтирование

#### Подготовока

Приложение запущено и работает, но время от времени появляется необходимость передавать между бекендами данные. 
А сам бекенд генерирует статику для фронта. Нужно оптимизировать это. Для настройки NFS сервера можно воспользоваться 
следующей инструкцией (производить под пользователем на сервере, у которого есть доступ до kubectl):
- установить helm: `curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash` 
- добавить репозиторий чартов: `helm repo add stable https://charts.helm.sh/stable && helm repo update` 
- установить nfs-server через helm: `helm install nfs-server stable/nfs-server-provisioner`

В конце установки будет выдан пример создания PVC для этого сервера.

- подготовил кластер с помощью [terraform](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.1/terraform) 
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Devkub/HW_13.2/img/ya.JPG)
- Установку кластера произвел с помощью `kubespray`
````bash

PLAY RECAP ****************************************************************************************************************************************************
cp1                        : ok=705  changed=152  unreachable=0    failed=0    skipped=1230 rescued=0    ignored=8
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=484  changed=98   unreachable=0    failed=0    skipped=755  rescued=0    ignored=1
node2                      : ok=484  changed=98   unreachable=0    failed=0    skipped=754  rescued=0    ignored=1


````
- Выполнил шаги инструкции
````bash
[centos@cp01 stage]$ curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 11345  100 11345    0     0  21702      0 --:--:-- --:--:-- --:--:-- 21692
[WARNING] Could not find git. It is required for plugin installation.
Downloading https://get.helm.sh/helm-v3.10.3-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
[centos@cp01 stage]$ helm repo add stable https://charts.helm.sh/stable && helm repo update
"stable" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "stable" chart repository
Update Complete. ⎈Happy Helming!⎈
[centos@cp01 stage]$ helm install nfs-server stable/nfs-server-provisioner
WARNING: This chart is deprecated
NAME: nfs-server
LAST DEPLOYED: Sat Dec 24 13:42:59 2022
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
The NFS Provisioner service has now been installed.

A storage class named 'nfs' has now been created
and is available to provision dynamic volumes.

You can use this storageclass by creating a `PersistentVolumeClaim` with the
correct storageClassName attribute. For example:

    ---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: test-dynamic-volume-claim
    spec:
      storageClassName: "nfs"
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 100Mi
[centos@cp01 stage]$
````
#### Задание 1: подключить для тестового конфига общую папку

В stage окружении часто возникает необходимость отдавать статику бекенда сразу фронтом. Проще всего сделать это 
через общую папку. Требования:
- в поде подключена общая папка между контейнерами (например, /static); 
- после записи чего-либо в контейнере с беком файлы можно получить из контейнера с фронтом.

#### Ответ
- Создал namespace `stage`
````bash
[centos@cp01 stage]$ kubectl create namespace stage
namespace/stage created
[centos@cp01 stage]$ kubectl  get ns
NAME              STATUS   AGE
default           Active   12m
kube-node-lease   Active   12m
kube-public       Active   12m
kube-system       Active   12m
stage             Active   5s
[centos@cp01 stage]$
````
- Подготовил и применил [манифест](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.1/stage/app.yml), 
в котором volume подключен к двум контейнерам в поде для `stage`
````bash
[centos@cp01 stage]$ kubectl get po --namespace=stage -o wide
NAME                         READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
db-0                         1/1     Running   0          4m21s   10.233.102.130   node1   <none>           <none>
fron-back-694c5f989f-k8bbn   2/2     Running   0          111s    10.233.102.131   node1   <none>           <none>
[centos@cp01 stage]$
````
- Создадим файл на `frontend` с содержанием `created on frontend`
````bash
[centos@cp01 stage]$ kubectl exec fron-back-694c5f989f-k8bbn -c frontend --namespace=stage -- sh -c "echo 'created on frontend' > /static/test-file.txt"
[centos@cp01 stage]$ kubectl exec fron-back-694c5f989f-k8bbn -c frontend --namespace=stage -- sh -c "cat /static/test-file.txt"
created on frontend
[centos@cp01 stage]$
````
- Проверим содержание файла с `backend`
````bash
[centos@cp01 stage]$ kubectl exec fron-back-694c5f989f-k8bbn -c backend --namespace=stage -- sh -c "cat /static/test-file.txt"
created on frontend
[centos@cp01 stage]$
````
#### Задание 2: подключить общую папку для прода

Поработав на stage, доработки нужно отправить на прод. В продуктиве у нас контейнеры крутятся в разных подах, 
поэтому потребуется PV и связь через PVC. Сам PV должен быть связан с NFS сервером. Требования:
- все бекенды подключаются к одному PV в режиме ReadWriteMany; 
- фронтенды тоже подключаются к этому же PV с таким же режимом; 
- файлы, созданные бекендом, должны быть доступны фронту.

#### Ответ

- Создал namespace `prod`
````bash
[centos@cp01 prod]$ kubectl create namespace prod
namespace/prod created
[centos@cp01 prod]$ kubectl  get ns
NAME              STATUS   AGE
default           Active   46m
kube-node-lease   Active   46m
kube-public       Active   46m
kube-system       Active   46m
prod              Active   8s
stage             Active   33m
[centos@cp01 prod]$
````
- Подготовил и применил, в котором volume подключен к двум контейнерам в поде для `prod`
  - [frontend](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.2/prod/frontend.yml)
  - [bakend](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.2/prod/bakend.yml)
  - [pvc](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_13.2/prod/pvc.yml)
- Применяем манифесты
````bash
[centos@cp01 prod]$ kubectl get  pod,pvc,pv --namespace=prod -o wide
NAME                            READY   STATUS    RESTARTS   AGE     IP               NODE    NOMINATED NODE   READINESS GATES
pod/backend-85dccd89d6-mgh29    1/1     Running   0          79s     10.233.102.133   node1   <none>           <none>
pod/db-0                        1/1     Running   0          4m58s   10.233.75.4      node2   <none>           <none>
pod/frontend-5c6bc8c544-7vcpd   1/1     Running   0          82s     10.233.102.132   node1   <none>           <none>

NAME                                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE     VOLUMEMODE
persistentvolumeclaim/postgres-db-db-0   Bound    pv-prod                                    1Gi        RWO                           4m58s   Filesystem
persistentvolumeclaim/pvc                Bound    pvc-42e291c5-7a09-4441-a0b3-892235db1c4d   100Mi      RWX            nfs            3m27s   Filesystem

NAME                                                        CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                    STORAGECLASS   REASON   AGE     VOLUMEMODE
persistentvolume/pv                                         1Gi        RWO            Retain           Bound    stage/postgres-db-db-0                           57m     Filesystem
persistentvolume/pv-prod                                    1Gi        RWO            Retain           Bound    prod/postgres-db-db-0                            4m52s   Filesystem
persistentvolume/pvc-42e291c5-7a09-4441-a0b3-892235db1c4d   100Mi      RWX            Delete           Bound    prod/pvc                 nfs                     3m26s   Filesystem
[centos@cp01 prod]$
````
- В поде `frontend` создал файл `test-file.txt`
````bash
[centos@cp01 prod]$ kubectl exec frontend-5c6bc8c544-7vcpd -c frontend --namespace=prod -- sh -c "echo 'created on frontend for prod' > /static/test-file.txt"
[centos@cp01 prod]$ kubectl exec frontend-5c6bc8c544-7vcpd -c frontend --namespace=prod -- sh -c "cat /static/test-file.txt"                             created on frontend for prod
[centos@cp01 prod]$
````
- В поде `backend` проверил содержимое файла `test-file.txt`
````bash
[centos@cp01 prod]$ kubectl exec backend-85dccd89d6-mgh29 -c backend --namespace=prod -- sh -c "cat /static/test-file.txt"
created on frontend for prod
[centos@cp01 prod]$
````