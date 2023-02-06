# devops-netology
### performed by Kirill Karagodin
#### HW 14.2 Карты конфигураций

#### Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Как создать карту конфигураций?
````bash
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
````
Как просмотреть список карт конфигураций?
````bash
kubectl get configmaps
kubectl get configmap
````
Как просмотреть карту конфигурации?
````bash
kubectl get configmap nginx-config
kubectl describe configmap domain
````
Как получить информацию в формате YAML и/или JSON?
````bash
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
````
Как выгрузить карту конфигурации и сохранить его в файл?
````bash
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
````
Как удалить карту конфигурации?
````bash
kubectl delete configmap nginx-config
````
Как загрузить карту конфигурации из файла?
````bash
kubectl apply -f nginx-config.yml
````
#### Ответ

- Создал карту конфигураций
````bash
mojnovse@mojno-vseMacBook src % kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
mojnovse@mojno-vseMacBook src % kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
mojnovse@mojno-vseMacBook src %
````
- Просмотр списка карт конфигураций
````bash
mojnovse@mojno-vseMacBook src % kubectl get configmaps
NAME               DATA   AGE
kube-root-ca.crt   1      79d
nginx-config       1      25s
mojnovse@mojno-vseMacBook src % kubectl get configmap
NAME               DATA   AGE
kube-root-ca.crt   1      79d
nginx-config       1      26s
mojnovse@mojno-vseMacBook src %
````
- Просмотр карты конфигурации
````bash
mojnovse@mojno-vseMacBook src % kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      56s
mojnovse@mojno-vseMacBook src % kubectl describe configmap domain
Name:         domain
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
mojnovse@mojno-vseMacBook src %
````
- Получение информации в формате YAML/JSON

**YAML**
````bash
mojnovse@mojno-vseMacBook src % kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |
    server {
        listen 80;
        server_name  netology.ru www.netology.ru;
        access_log  /var/log/nginx/domains/netology.ru-access.log  main;
        error_log   /var/log/nginx/domains/netology.ru-error.log info;
        location / {
            include proxy_params;
            proxy_pass http://10.10.10.10:8080/;
        }
    }
kind: ConfigMap
metadata:
  creationTimestamp: "2023-02-06T13:29:50Z"
  name: nginx-config
  namespace: default
  resourceVersion: "17791"
  uid: 65474215-7dba-4949-a4ff-945be6c9401c
mojnovse@mojno-vseMacBook src %
````
**JSON**
````bash
mojnovse@mojno-vseMacBook src % kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2023-02-06T13:31:33Z",
        "name": "domain",
        "namespace": "default",
        "resourceVersion": "17880",
        "uid": "aeabc7da-d4a7-4d6e-a17b-bd9fb0e2df8d"
    }
}
mojnovse@mojno-vseMacBook src %
````
- Выгрузка в файл YAML/JSON
[**JSON**](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_14.3/src/configmaps.json)
````bash
mojnovse@mojno-vseMacBook src % kubectl get configmaps -o json > configmaps.json
mojnovse@mojno-vseMacBook src %
````
[**YAML**](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_14.3/src/nginx-config.yml)
````bash
mojnovse@mojno-vseMacBook src % kubectl get configmap nginx-config -o yaml > nginx-config.yml
mojnovse@mojno-vseMacBook src %
````
Просмотр наличия файлов
````bash
mojnovse@mojno-vseMacBook src % ls -ls
total 40
8 -rw-r--r--  1 mojnovse  staff  3228 Feb  6 16:36 configmaps.json
8 -rwxr--r--  1 mojnovse  staff   370 Feb  6 16:26 generator.py
8 -rwxr--r--  1 mojnovse  staff   576 Feb  6 16:26 myapp-pod.yml
8 -rw-r--r--  1 mojnovse  staff   566 Feb  6 16:36 nginx-config.yml
8 -rwxr--r--  1 mojnovse  staff   306 Feb  6 16:26 nginx.conf
0 drwxr-xr-x  3 mojnovse  staff    96 Feb  6 16:26 templates
mojnovse@mojno-vseMacBook src %
````
- Удаление карты
````bash
mojnovse@mojno-vseMacBook src % kubectl delete configmap nginx-config
configmap "nginx-config" deleted
mojnovse@mojno-vseMacBook src % kubectl get configmap
NAME               DATA   AGE
domain             1      8m20s
kube-root-ca.crt   1      79d
mojnovse@mojno-vseMacBook src %
````
- Загрузка карты из файла
````bash
mojnovse@mojno-vseMacBook src % kubectl apply -f nginx-config.yml
configmap/nginx-config created
mojnovse@mojno-vseMacBook src % kubectl get configmap
NAME               DATA   AGE
domain             1      9m
kube-root-ca.crt   1      79d
nginx-config       1      2s
mojnovse@mojno-vseMacBook src %
````