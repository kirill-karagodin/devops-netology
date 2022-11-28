# devops-netology
### performed by Kirill Karagodin
#### HW 12.2 Команды для работы с Kubernetes

#### Задача 1: Запуск пода из образа в деплойменте

Для начала следует разобраться с прямым запуском приложений из консоли. Такой подход поможет быстро развернуть 
инструменты отладки в кластере. Требуется запустить деплоймент на основе образа из hello world уже через deployment. 
Сразу стоит запустить 2 копии приложения (replicas=2).

Требования:
- пример из hello world запущен в качестве deployment 
- количество реплик в deployment установлено в 2 
- наличие deployment можно проверить командой kubectl get deployment 
- наличие подов можно проверить командой kubectl get pods
#### Ответ

Запустил `minikube`
````bash
mojnovse@mojno-vseMacBook ~ % minikube start --vm-driver=docker --force --apiserver-ips=10.0.62.229
* minikube v1.28.0 на Darwin 10.15.7
! minikube skips various validations when --force is supplied; this may lead to unexpected behavior
* Используется драйвер docker на основе существующего профиля
* Запускается control plane узел minikube в кластере minikube
* Скачивается базовый образ ...
* Перезагружается существующий docker container для "minikube" ...
* Подготавливается Kubernetes v1.25.3 на Docker 20.10.20 ...
* Компоненты Kubernetes проверяются ...
  - Используется образ gcr.io/k8s-minikube/storage-provisioner:v5
* After the addon is enabled, please run "minikube tunnel" and your ingress resources would be available at "127.0.0.1"
  - Используется образ k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
  - Используется образ k8s.gcr.io/ingress-nginx/controller:v1.2.1
  - Используется образ k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
  - Используется образ docker.io/kubernetesui/dashboard:v2.7.0
  - Используется образ docker.io/kubernetesui/metrics-scraper:v1.0.8
* Verifying ingress addon...
* Some dashboard features require the metrics-server addon. To enable all features please run:

        minikube addons enable metrics-server


* Включенные дополнения: storage-provisioner, default-storageclass, dashboard, ingress
* Готово! kubectl настроен для использования кластера "minikube" и "default" пространства имён по умолчанию
mojnovse@mojno-vseMacBook ~ %
````
Запустил hello world в качестве deployment с двумя репликами
При первой попытке запуска команды `kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2`
получил ошибку, так как после выполнения предыдущей домашней работы `hello-node` был запущен, перед выполнением 
основного шага удалил старое
````bash
mojnovse@mojno-vseMacBook ~ % kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2
error: failed to create deployment: deployments.apps "hello-node" already exists
mojnovse@mojno-vseMacBook ~ % kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   1/1     1            1           10d
mojnovse@mojno-vseMacBook ~ % kubectl delete deployment hello-node
deployment.apps "hello-node" deleted
mojnovse@mojno-vseMacBook ~ % kubectl get deployment
No resources found in default namespace.
mojnovse@mojno-vseMacBook ~ % 
````
Запустил hello world
````bash
mojnovse@mojno-vseMacBook ~ % kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/hello-node created
mojnovse@mojno-vseMacBook ~ % kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   2/2     2            2           6s
mojnovse@mojno-vseMacBook ~ % kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
hello-node-697897c86-x78dx   1/1     Running   0          12s
hello-node-697897c86-xxwbn   1/1     Running   0          12s
mojnovse@mojno-vseMacBook ~ %
````
#### Задача 2: Просмотр логов для разработки

Разработчикам крайне важно получать обратную связь от штатно работающего приложения и, еще важнее, об ошибках в его
работе. Требуется создать пользователя и выдать ему доступ на чтение конфигурации и логов подов в app-namespace.

Требования:
- создан новый токен доступа для пользователя 
- пользователь прописан в локальный конфиг (~/.kube/config, блок users)
- пользователь может просматривать логи подов и их конфигурацию (kubectl logs pod <pod_id>, kubectl describe pod 
<pod_id>)

Создаем пользователя `developer`
````bash
mojnovse@mojno-vseMacBook ~ % kubectl create serviceaccount developer
serviceaccount/developer created
mojnovse@mojno-vseMacBook ~ % kubectl get serviceaccount
NAME        SECRETS   AGE
default     0         10d
developer   0         96s
mojnovse@mojno-vseMacBook ~ %

````
Создаем роль и привязываем роль к пользователю
````bash
mojnovse@mojno-vseMacBook ~ % cat <<EOF | kubectl apply -f -
kind: Role
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  namespace: default
  name: developer-view
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log"]
  verbs: ["get", "list", "logs", "describe"]
EOF
role.rbac.authorization.k8s.io/developer-view created
mojnovse@mojno-vseMacBook ~ % kubectl get roles
NAME             CREATED AT
developer-view   2022-11-28T18:58:29Z
mojnovse@mojno-vseMacBook ~ % kubectl create rolebinding dev-viewer --role=developer-view --serviceaccount=default:developer --namespace=default
rolebinding.rbac.authorization.k8s.io/dev-viewer created
mojnovse@mojno-vseMacBook ~ % kubectl describe rolebinding dev-viewer
Name:         dev-viewer
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  Role
  Name:  developer-view
Subjects:
  Kind            Name       Namespace
  ----            ----       ---------
  ServiceAccount  developer  default
mojnovse@mojno-vseMacBook ~ % kubectl get rolebinding
NAME         ROLE                  AGE
dev-viewer   Role/developer-view   78s
mojnovse@mojno-vseMacBook ~ %
````
Создал токен для пользователя `developer` 
````bash
mojnovse@mojno-vseMacBook ~ % cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: developer-token
  annotations:
    kubernetes.io/service-account.name: developer
type: kubernetes.io/service-account-token
EOF
secret/developer-token created
mojnovse@mojno-vseMacBook ~ % kubectl describe sa developer
Name:                developer
Namespace:           default
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   <none>
Tokens:              developer-token
Events:              <none>
mojnovse@mojno-vseMacBook ~ % kubectl describe secret/developer-token
Name:         developer-token
Namespace:    default
Labels:       <none>
Annotations:  kubernetes.io/service-account.name: developer
              kubernetes.io/service-account.uid: 8e04e964-7855-4156-ac12-711c7a4682b9

Type:  kubernetes.io/service-account-token

Data
====
ca.crt:     1111 bytes
namespace:  7 bytes
token:      eyJhbGciOiJSUzI1NiIsImtpZCI6ImdzbEJSUV8ySy1MUi1yTTRYdXNvREJ4MTZodi1qNUd6WWo0cS1tRDVNUXMifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6ImRldmVsb3Blci10b2tlbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJkZXZlbG9wZXIiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC51aWQiOiI4ZTA0ZTk2NC03ODU1LTQxNTYtYWMxMi03MTFjN2E0NjgyYjkiLCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpkZXZlbG9wZXIifQ.xyf7QLrbxYfjU2lXQ1cuQtpPpjz1mGwFP8nvnPjXbPVKbbApZMoc2XxWzt6FmiaU0BvxUGZtwJi464ZpNfQFP8UoDVySOoDswyh3lni5K8Hcq6LfrEyE2fyb-YSkIHgiTICDxeX11ogh3ZpDH8-zYlM7l3WRgC6krqcHl3zk0Mj-H8TTWASy4chrTv-HswUgh_KoZszwYO4cCzSZNR8ka-oiP9MKvgW5B69cvIjDq4jAudgIkTi299VXIAFRiOvLFGtZagzmpBJ6FWCidwLTBnnKlQjwqWhxSbP9eZXMqiCaep6x3hj6p2NeYVUkBwB4e-7InL-v-WSM0ZLtTNqR7w
mojnovse@mojno-vseMacBook ~ %
````
Получил токен учетной записи 
````bash
mojnovse@mojno-vseMacBook ~ % export NAMESPACE="default"
mojnovse@mojno-vseMacBook ~ % export K8S_USER="developer"
mojnovse@mojno-vseMacBook ~ % export K8S_USER_TOKEN=$(kubectl -n ${NAMESPACE} describe secret $(kubectl -n ${NAMESPACE} get secret | (grep ${K8S_USER} || echo "$_") | awk '{print $1}') | grep token: | awk '{print $2}'\n)
mojnovse@mojno-vseMacBook ~ %
````
Добавил пользователя в конфиг `~/.kube/config`
````bash
mojnovse@mojno-vseMacBook ~ % kubectl config set-credentials developer --token $K8S_USER_TOKEN
User "developer" set.
mojnovse@mojno-vseMacBook ~ %
````
Переключился на пользователя `developer`
````bash
mojnovse@mojno-vseMacBook ~ % kubectl config set-context minikube --user developer
Context "minikube" modified.
mojnovse@mojno-vseMacBook ~ %
````
Просмотр логов подов (логов видимо нет)
````bash
mojnovse@mojno-vseMacBook ~ % kubectl logs hello-node-697897c86-x78dx
mojnovse@mojno-vseMacBook ~ % kubectl describe pod hello-node-697897c86-x78dx

Name:             hello-node-697897c86-x78dx
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Mon, 28 Nov 2022 21:07:57 +0300
Labels:           app=hello-node
                  pod-template-hash=697897c86
Annotations:      <none>
Status:           Running
IP:               172.17.0.2
IPs:
  IP:           172.17.0.2
Controlled By:  ReplicaSet/hello-node-697897c86
Containers:
  echoserver:
    Container ID:   docker://ec366dd16e5651d913dc3e759eadb2593e65f5d8572f69eee3eb69b94b03d370
    Image:          k8s.gcr.io/echoserver:1.4
    Image ID:       docker-pullable://k8s.gcr.io/echoserver@sha256:5d99aa1120524c801bc8c1a7077e8f5ec122ba16b6dda1a5d3826057f67b9bcb
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Mon, 28 Nov 2022 21:07:58 +0300
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-kcz6z (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  kube-api-access-kcz6z:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>
mojnovse@mojno-vseMacBook ~ %
````
Проверка лишних доступов
````bash
mojnovse@mojno-vseMacBook ~ % kubectl delete pod hello-node-697897c86-x78dx

Error from server (Forbidden): pods "hello-node-697897c86-x78dx" is forbidden: User "system:serviceaccount:default:developer" cannot delete resource "pods" in API group "" in the namespace "default"
mojnovse@mojno-vseMacBook ~ % kubectl scale --replicas=5 deployment/hello-node

Error from server (Forbidden): deployments.apps "hello-node" is forbidden: User "system:serviceaccount:default:developer" cannot get resource "deployments" in API group "apps" in the namespace "default"
mojnovse@mojno-vseMacBook ~ %
````
#### Задача 3: Изменение количества реплик

Поработав с приложением, вы получили запрос на увеличение количества реплик приложения для нагрузки. Необходимо 
изменить запущенный deployment, увеличив количество реплик до 5. Посмотрите статус запущенных подов после увеличения 
реплик.

Требования:
- в deployment из задания 1 изменено количество реплик на 5 
- проверить что все поды перешли в статус running (kubectl get pods)

Переключаюсь на пользователя `minikube`
````bash
mojnovse@mojno-vseMacBook ~ % kubectl config set-context minikube --user minikube
Context "minikube" modified.
mojnovse@mojno-vseMacBook ~ %
````
Увеличим количество реплик до 5 `deployment hello-node`
````bash
mojnovse@mojno-vseMacBook ~ % kubectl scale --replicas=5 deployment/hello-node
deployment.apps/hello-node scaled
mojnovse@mojno-vseMacBook ~ %
````
Проверка статуса. Все реплики перешли в состояние `running`
````bash
mojnovse@mojno-vseMacBook ~ % kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
hello-node-697897c86-btgl6   1/1     Running   0          16s
hello-node-697897c86-ln6c2   1/1     Running   0          16s
hello-node-697897c86-n7kdx   1/1     Running   0          16s
hello-node-697897c86-x78dx   1/1     Running   0          60m
hello-node-697897c86-xxwbn   1/1     Running   0          60m
mojnovse@mojno-vseMacBook ~ % kubectl get deployment
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   5/5     5            5           60m
mojnovse@mojno-vseMacBook ~ %
````