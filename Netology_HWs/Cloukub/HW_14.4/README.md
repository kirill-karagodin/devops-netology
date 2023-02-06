# devops-netology
### performed by Kirill Karagodin
#### HW 14.2 Сервис-аккаунты

#### Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните задачу 1 как справочный материал.

Как создать сервис-аккаунт?
````bash
kubectl create serviceaccount netology
````
Как просмотреть список сервис-акаунтов?
````bash
kubectl get serviceaccounts
kubectl get serviceaccount
````
Как получить информацию в формате YAML и/или JSON?
````bash
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
````
Как выгрузить сервис-акаунты и сохранить его в файл?
````bash
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
````
Как удалить сервис-акаунт?
````bash
kubectl delete serviceaccount netology
````
Как загрузить сервис-акаунт из файла?
````bash
kubectl apply -f netology.yml
````
#### Ответ

- Создал сервис-аккаунт
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl create serviceaccount netology
serviceaccount/netology created
mojnovse@mojno-vseMacBook HW_14.4 %
````
- Просмотр списка сервис-аккаунтов
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccounts
NAME        SECRETS   AGE
default     0         79d
developer   0         69d
netology    0         14s
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccount
NAME        SECRETS   AGE
default     0         79d
developer   0         69d
netology    0         16s
mojnovse@mojno-vseMacBook HW_14.4 %
````
- Получить информацию в формате YAML/JSON

**YAML**
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccount netology -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2023-02-06T16:24:31Z"
  name: netology
  namespace: default
  resourceVersion: "26544"
  uid: 7b8154b5-9d2d-4b28-9eda-5150001fa735
mojnovse@mojno-vseMacBook HW_14.4 %
````
**JSON**
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccount default -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2022-11-18T17:15:54Z",
        "name": "default",
        "namespace": "default",
        "resourceVersion": "318",
        "uid": "2cf2da93-ca61-4058-97a9-1b8626f8e7c3"
    }
}
mojnovse@mojno-vseMacBook HW_14.4 %

````
- Выгрузил сервис-аккаунты и сохранил его в файл

[**JSON**](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_14.4/src/serviceaccounts.json)
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccounts -o json > serviceaccounts.json
mojnovse@mojno-vseMacBook HW_14.4 % ls -la
total 8
drwxr-xr-x   3 mojnovse  staff    96 Feb  6 19:25 .
drwxr-xr-x  13 mojnovse  staff   416 Feb  6 17:16 ..
-rw-r--r--   1 mojnovse  staff  1242 Feb  6 19:25 serviceaccounts.json
mojnovse@mojno-vseMacBook HW_14.4 %
````
[**YAML**](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_14.4/src/netology.yml)
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccount netology -o yaml > netology.yml
mojnovse@mojno-vseMacBook HW_14.4 % ls -la
total 16
drwxr-xr-x   4 mojnovse  staff   128 Feb  6 19:26 .
drwxr-xr-x  13 mojnovse  staff   416 Feb  6 17:16 ..
-rw-r--r--   1 mojnovse  staff   199 Feb  6 19:26 netology.yml
-rw-r--r--   1 mojnovse  staff  1242 Feb  6 19:25 serviceaccounts.json
mojnovse@mojno-vseMacBook HW_14.4 %
````
- Удалил сервис-аккаунт
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccount
NAME        SECRETS   AGE
default     0         79d
developer   0         69d
netology    0         2m39s
mojnovse@mojno-vseMacBook HW_14.4 % kubectl delete serviceaccount netology
serviceaccount "netology" deleted
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccount
NAME        SECRETS   AGE
default     0         79d
developer   0         69d
mojnovse@mojno-vseMacBook HW_14.4 %

````
- Восстановил сервис-аккаунт из файла
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccount
NAME        SECRETS   AGE
default     0         79d
developer   0         69d
mojnovse@mojno-vseMacBook HW_14.4 % kubectl apply -f netology.yml
serviceaccount/netology created
mojnovse@mojno-vseMacBook HW_14.4 % kubectl get serviceaccount
NAME        SECRETS   AGE
default     0         79d
developer   0         69d
netology    0         5s
mojnovse@mojno-vseMacBook HW_14.4 %
````
#### Задача 2 (*): Работа с сервис-акаунтами внутри модуля

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить доступность API Kubernetes
````bash
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
````
Просмотреть переменные среды
````bash
env | grep KUBE
````
Получить значения переменных
````bash
K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
SADIR=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat $SADIR/token)
CACERT=$SADIR/ca.crt
NAMESPACE=$(cat $SADIR/namespace)
````
Подключаемся к API
````bash
curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
````
В случае с minikube может быть другой адрес и порт, который можно взять здесь
````bash
cat ~/.kube/config
````
или здесь
````bash
kubectl cluster-info
````

#### Ответ

Запускаем под
````bash
mojnovse@mojno-vseMacBook HW_14.4 % kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.2#
````
Просмотрел переменные среды
````bash
sh-5.2# env | grep KUBE
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
sh-5.2#
````
Получил значения переменных
````bash
sh-5.2# K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
sh-5.2# SADIR=/var/run/secrets/kubernetes.io/serviceaccount
sh-5.2# TOKEN=$(cat $SADIR/token)
sh-5.2# CACERT=$SADIR/ca.crt
sh-5.2# NAMESPACE=$(cat $SADIR/namespace
````
Подключился к API
````bash
sh-5.2# curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
{
  "kind": "APIResourceList",
  "groupVersion": "v1",
  "resources": [
    {
      "name": "bindings",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "componentstatuses",
      "singularName": "",
      "namespaced": false,
      "kind": "ComponentStatus",
      "verbs": [
        "get",
        "list"
      ],
      "shortNames": [
        "cs"
      ]
    },
    {
      "name": "configmaps",
      "singularName": "",
      "namespaced": true,
      "kind": "ConfigMap",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "cm"
      ],
      "storageVersionHash": "qFsyl6wFWjQ="
    },
    {
      "name": "endpoints",
      "singularName": "",
      "namespaced": true,
      "kind": "Endpoints",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ep"
      ],
      "storageVersionHash": "fWeeMqaN/OA="
    },
    {
      "name": "events",
      "singularName": "",
      "namespaced": true,
      "kind": "Event",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ev"
      ],
      "storageVersionHash": "r2yiGXH7wu8="
    },
    {
      "name": "limitranges",
      "singularName": "",
      "namespaced": true,
      "kind": "LimitRange",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "limits"
      ],
      "storageVersionHash": "EBKMFVe6cwo="
    },
    {
      "name": "namespaces",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "create",
        "delete",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ns"
      ],
      "storageVersionHash": "Q3oi5N2YM8M="
    },
    {
      "name": "namespaces/finalize",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "update"
      ]
    },
    {
      "name": "namespaces/status",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "nodes",
      "singularName": "",
      "namespaced": false,
      "kind": "Node",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "no"
      ],
      "storageVersionHash": "XwShjMxG9Fs="
    },
    {
      "name": "nodes/proxy",
      "singularName": "",
      "namespaced": false,
      "kind": "NodeProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "nodes/status",
      "singularName": "",
      "namespaced": false,
      "kind": "Node",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "persistentvolumeclaims",
      "singularName": "",
      "namespaced": true,
      "kind": "PersistentVolumeClaim",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "pvc"
      ],
      "storageVersionHash": "QWTyNDq0dC4="
    },
    {
      "name": "persistentvolumeclaims/status",
      "singularName": "",
      "namespaced": true,
      "kind": "PersistentVolumeClaim",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "persistentvolumes",
      "singularName": "",
      "namespaced": false,
      "kind": "PersistentVolume",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "pv"
      ],
      "storageVersionHash": "HN/zwEC+JgM="
    },
    {
      "name": "persistentvolumes/status",
      "singularName": "",
      "namespaced": false,
      "kind": "PersistentVolume",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "po"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "xPOwRZ+Yhw8="
    },
    {
      "name": "pods/attach",
      "singularName": "",
      "namespaced": true,
      "kind": "PodAttachOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/binding",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "pods/ephemeralcontainers",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods/eviction",
      "singularName": "",
      "namespaced": true,
      "group": "policy",
      "version": "v1",
      "kind": "Eviction",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "pods/exec",
      "singularName": "",
      "namespaced": true,
      "kind": "PodExecOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/log",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get"
      ]
    },
    {
      "name": "pods/portforward",
      "singularName": "",
      "namespaced": true,
      "kind": "PodPortForwardOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/proxy",
      "singularName": "",
      "namespaced": true,
      "kind": "PodProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods/status",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "podtemplates",
      "singularName": "",
      "namespaced": true,
      "kind": "PodTemplate",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "storageVersionHash": "LIXB2x4IFpk="
    },
    {
      "name": "replicationcontrollers",
      "singularName": "",
      "namespaced": true,
      "kind": "ReplicationController",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "rc"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "Jond2If31h0="
    },
    {
      "name": "replicationcontrollers/scale",
      "singularName": "",
      "namespaced": true,
      "group": "autoscaling",
      "version": "v1",
      "kind": "Scale",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "replicationcontrollers/status",
      "singularName": "",
      "namespaced": true,
      "kind": "ReplicationController",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "resourcequotas",
      "singularName": "",
      "namespaced": true,
      "kind": "ResourceQuota",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "quota"
      ],
      "storageVersionHash": "8uhSgffRX6w="
    },
    {
      "name": "resourcequotas/status",
      "singularName": "",
      "namespaced": true,
      "kind": "ResourceQuota",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "secrets",
      "singularName": "",
      "namespaced": true,
      "kind": "Secret",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "storageVersionHash": "S6u1pOWzb84="
    },
    {
      "name": "serviceaccounts",
      "singularName": "",
      "namespaced": true,
      "kind": "ServiceAccount",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "sa"
      ],
      "storageVersionHash": "pbx9ZvyFpBE="
    },
    {
      "name": "serviceaccounts/token",
      "singularName": "",
      "namespaced": true,
      "group": "authentication.k8s.io",
      "version": "v1",
      "kind": "TokenRequest",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "services",
      "singularName": "",
      "namespaced": true,
      "kind": "Service",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "svc"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "0/CO1lhkEBI="
    },
    {
      "name": "services/proxy",
      "singularName": "",
      "namespaced": true,
      "kind": "ServiceProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "services/status",
      "singularName": "",
      "namespaced": true,
      "kind": "Service",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    }
  ]
}sh-5.2#
````
