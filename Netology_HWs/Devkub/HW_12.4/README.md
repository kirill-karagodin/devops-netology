# devops-netology
### performed by Kirill Karagodin
#### HW 12.4 Развертывание кластера на собственных серверах, лекция 2

#### Задание 1: Подготовить инвентарь kubespray

Новые тестовые кластеры требуют типичных простых настроек. Нужно подготовить инвентарь и проверить его работу. 
Требования к инвентарю:
- подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды; 
- в качестве CRI — containerd; 
- запуск etcd производить на мастере.

#### Ответ

- Склонировал себе репозиторий kubespray 
````bash
mojnovse@mojno-vseMacBook HW_12.4 % git clone https://github.com/kubernetes-sigs/kubespray
Cloning into 'kubespray'...
remote: Enumerating objects: 65276, done.
remote: Counting objects: 100% (109/109), done.
remote: Compressing objects: 100% (79/79), done.
remote: Total 65276 (delta 35), reused 80 (delta 21), pack-reused 65167
Receiving objects: 100% (65276/65276), 20.68 MiB | 3.88 MiB/s, done.
Resolving deltas: 100% (36706/36706), done.
mojnovse@mojno-vseMacBook HW_12.4 % ls -la
total 0
drwxr-xr-x   3 mojnovse  staff    96 Dec  7 23:32 .
drwxr-xr-x+ 32 mojnovse  staff  1024 Dec  7 23:31 ..
drwxr-xr-x  53 mojnovse  staff  1696 Dec  7 23:32 kubespray
mojnovse@mojno-vseMacBook HW_12.4 %
````
Установил зависимости 
````bash
mojnovse@mojno-vseMacBook kubespray % sudo pip3 install -r requirements.txt
````
- Скопировал пример в папку с моей конфигурацией 
````bash
cp -rfp inventory/sample inventory/netology-cluster
````
- Подготовил машины в YC с помощью [terraform](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_12.4/terraform)
````bash
mojnovse@mojno-vseMacBook kubespray % yc compute instance list
+----------------------+--------+---------------+---------+----------------+----------------+
|          ID          |  NAME  |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP   |
+----------------------+--------+---------------+---------+----------------+----------------+
| fhm1holfc6mialp77kru | node02 | ru-central1-a | RUNNING | 158.160.38.39  | 192.168.101.21 |
| fhm9bse8vujqutgdikbl | cp01   | ru-central1-a | RUNNING | 158.160.43.14  | 192.168.101.24 |
| fhmdh0mut1jal85oeuqb | node04 | ru-central1-a | RUNNING | 158.160.49.111 | 192.168.101.36 |
| fhmdqsv57aev5tli9viv | node03 | ru-central1-a | RUNNING | 158.160.35.170 | 192.168.101.12 |
| fhmj71go6v4f065n4ate | node01 | ru-central1-a | RUNNING | 158.160.34.109 | 192.168.101.19 |
+----------------------+--------+---------------+---------+----------------+----------------+
````
- Описал `inventory` (создан при помощи `terraform`)
````bash
mojnovse@mojno-vseMacBook kubespray % cat inventory/netology-cluster/inventory.ini
# ## Configure 'ip' variable to bind kubernetes services on a
# ## different ip than the default iface
# ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty string value.
[all]
node1 ansible_host=158.160.34.109  ip=192.168.101.19 ansible_user=centos
node2 ansible_host=158.160.38.39  ip=192.168.101.21 ansible_user=centos
node3 ansible_host=158.160.35.170  ip=192.168.101.12 ansible_user=centos
node4 ansible_host=158.160.49.111  ip=192.168.101.36 ansible_user=centos
cp1 ansible_host=158.160.43.14  ip=192.168.101.24 etcd_member_name=etcd1 ansible_user=centos

# ## configure a bastion host if your nodes are not directly reachable
# [bastion]
# bastion ansible_host=x.x.x.x ansible_user=some_user

[kube_control_plane]
cp1

[etcd]
cp1

[kube_node]
node1
node2
node3
node4

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr

mojnovse@mojno-vseMacBook kubespray %

````
- По умолчанию в конфиге в качестве CRI используется `containerd`, поэтому конфиг не поменял
- Запустил деплой кластера 
````bash
mojnovse@mojno-vseMacBook kubespray % ansible-playbook -i inventory/netology-cluster/inventory.ini cluster.yml -b -v
````
- Кластер
После окончания работы `ansible` при попытке посмотреть состояние кластера получил ошибку
````bash
[centos@cp1 ~]$ kubectl get pods
The connection to the server localhost:8080 was refused - did you specify the right host or port?
[centos@cp1 ~]$ 
````
Для решения этой ошибки необходимо создать конфиг `.kube` в домашний каталоге пользователя и скопировать туда 
админский конфиг. Также необходимо назначить права на этот файл 
````bash
[centos@cp1 ~]$ mkdir -p $HOME/.kube
[centos@cp1 ~]$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
[centos@cp1 ~]$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
[centos@cp1 ~]$
````
Рабочий кластер
````bash
[centos@cp1 ~]$ kubectl get nodes
NAME    STATUS   ROLES           AGE     VERSION
cp1     Ready    control-plane   3h11m   v1.25.4
node1   Ready    <none>          3h9m    v1.25.4
node2   Ready    <none>          3h9m    v1.25.4
node3   Ready    <none>          3h9m    v1.25.4
node4   Ready    <none>          3h9m    v1.25.4
[centos@cp1 ~]$ 
````
- Запустил деплоймент для проверки 
````bash
[centos@cp1 ~]$ kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=4
deployment.apps/hello-node created
[centos@cp1 ~]$ kubectl get pods -o wide
NAME                         READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
hello-node-697897c86-9l68l   1/1     Running   0          48s   10.233.71.1      node3   <none>           <none>
hello-node-697897c86-jncn6   1/1     Running   0          50s   10.233.102.129   node1   <none>           <none>
hello-node-697897c86-qmz9z   1/1     Running   0          50s   10.233.75.1      node2   <none>           <none>
hello-node-697897c86-rc6b9   1/1     Running   0          50s   10.233.74.65     node4   <none>           <none>
[centos@cp1 ~]$
````
