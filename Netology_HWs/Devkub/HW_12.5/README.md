# devops-netology
### performed by Kirill Karagodin
#### HW 12.5 Сетевые решения CNI

#### Задание 1: установить в кластер CNI плагин Calico

Для проверки других сетевых решений стоит поставить отличный от Flannel плагин — например, Calico. Требования:
- установка производится через ansible/kubespray;
- после применения следует настроить политику доступа к hello-world извне. Инструкции kubernetes.io, Calico

#### Ответ
- Подготовил машины в YC с помощью [terraform](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Devkub/HW_12.4/terraform)
````bash
mojnovse@mojno-vseMacBook terraform % yc compute instance list
+----------------------+--------+---------------+---------+----------------+----------------+
|          ID          |  NAME  |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP   |
+----------------------+--------+---------------+---------+----------------+----------------+
| fhm24g4uttr9fu3fmfnl | node03 | ru-central1-a | RUNNING | 158.160.38.32  | 192.168.101.28 |
| fhm4u0hp9eimn494eagv | node01 | ru-central1-a | RUNNING | 84.252.128.42  | 192.168.101.11 |
| fhmjr3oafkuhr7e9dhfa | node04 | ru-central1-a | RUNNING | 62.84.114.202  | 192.168.101.12 |
| fhmlf5h1iguioijkklfu | cp01   | ru-central1-a | RUNNING | 158.160.35.58  | 192.168.101.17 |
| fhmof5ao4602tdnpa79q | node02 | ru-central1-a | RUNNING | 84.252.129.204 | 192.168.101.7  |
+----------------------+--------+---------------+---------+----------------+----------------+

mojnovse@mojno-vseMacBook terraform %
````
- Развернул кластер с помощью kubespray
````bash
centos@cp1 ~]$ kubectl get nodes -o wide
NAME    STATUS   ROLES           AGE   VERSION   INTERNAL-IP      EXTERNAL-IP   OS-IMAGE                KERNEL-VERSION                CONTAINER-RUNTIME
cp1     Ready    control-plane   12m   v1.25.4   192.168.101.17   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.11
node1   Ready    <none>          10m   v1.25.4   192.168.101.11   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.11
node2   Ready    <none>          10m   v1.25.4   192.168.101.7    <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.11
node3   Ready    <none>          10m   v1.25.4   192.168.101.28   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.11
node4   Ready    <none>          10m   v1.25.4   192.168.101.12   <none>        CentOS Linux 7 (Core)   3.10.0-1160.66.1.el7.x86_64   containerd://1.6.11
[centos@cp1 ~]$
````
- Развернул два пода hello-node и hello-node-noacc
````bash
[centos@cp1 ~]$ kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/hello-node created
[centos@cp1 ~]$ kubectl create deployment hello-node-noacc --image=k8s.gcr.io/echoserver:1.4 --replicas=2
deployment.apps/hello-node-noacc created
[centos@cp1 ~]$ kubectl get pods -o wide
NAME                                READY   STATUS    RESTARTS   AGE   IP               NODE    NOMINATED NODE   READINESS GATES
hello-node-697897c86-jg7d8          1/1     Running   0          67s   10.233.71.1      node3   <none>           <none>
hello-node-697897c86-zkm92          1/1     Running   0          67s   10.233.74.65     node4   <none>           <none>
hello-node-noacc-66dcd48747-hrt9d   1/1     Running   0          61s   10.233.75.2      node2   <none>           <none>
hello-node-noacc-66dcd48747-xrvkd   1/1     Running   0          61s   10.233.102.130   node1   <none>           <none>
[centos@cp1 ~]$
````
- Создал сервис
````bash
[centos@cp1 ~]$ kubectl expose deployment hello-node --port=8080
service/hello-node exposed
[centos@cp1 ~]$ kubectl expose deployment hello-node-noacc --port=8080
service/hello-node-noacc exposed
[centos@cp1 ~]$ kubectl get service -o wide
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE   SELECTOR
hello-node         ClusterIP   10.233.31.152   <none>        8080/TCP   12s   app=hello-node
hello-node-noacc   ClusterIP   10.233.62.36    <none>        8080/TCP   6s    app=hello-node-noacc
kubernetes         ClusterIP   10.233.0.1      <none>        443/TCP    14m   <none>
[centos@cp1 ~]$
````
Проверка доступности обоих сервисов, доступ есть
````bash
[centos@cp1 ~]$ curl hello-node:8080
CLIENT VALUES:
client_address=10.233.116.128
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://hello-node:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=hello-node:8080
user-agent=curl/7.29.0
BODY:
-no body in request-
[centos@cp1 ~]$ curl hello-node-noacc:8080
CLIENT VALUES:
client_address=10.233.116.128
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://hello-node-noacc:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=hello-node-noacc:8080
user-agent=curl/7.29.0
BODY:
-no body in request-
[centos@cp1 ~]$
````
- Создадим политику разрешающую входящие соединения с `hello-node-noacc` на `hello-node`
````bash
[centos@cp1 ~]$ cat <<EOF | kubectl apply -f -
> apiVersion: networking.k8s.io/v1
> kind: NetworkPolicy
> metadata:
>   name: hello-node-noacc
>   namespace: default
> spec:
>   podSelector:
>     matchLabels:
>       app: hello-node-noacc
>   policyTypes:
>     - Ingress
> EOF
networkpolicy.networking.k8s.io/hello-node-noacc created
[centos@cp1 ~]$ cat <<EOF | kubectl apply -f -
> apiVersion: networking.k8s.io/v1
> kind: NetworkPolicy
> metadata:
>   name: hello-node
>   namespace: default
> spec:
>   podSelector:
>     matchLabels:
>       app: hello-node
>   policyTypes:
>     - Ingress
>   ingress:
>     - from:
>       - podSelector:
>           matchLabels:
>             app: hello-node-noacc
> EOF
networkpolicy.networking.k8s.io/hello-node created
[centos@cp1 ~]$
````
- Создадим дефолтное запрещающее правило
````bash
[centos@cp1 ~]$ cat <<EOF | kubectl apply -f -
> apiVersion: networking.k8s.io/v1
> kind: NetworkPolicy
> metadata:
>   name: default-deny-ingress
> spec:
>   podSelector: {}
>   policyTypes:
>     - Ingress
> EOF
networkpolicy.networking.k8s.io/default-deny-ingress created
[centos@cp1 ~]$
````
- Проверка доступа `hello-node-noacc` --> `hello-node` (присутствует)
````bash
[centos@cp1 ~]$ kubectl exec hello-node-noacc-66dcd48747-hrt9d -- curl -s -m 1 hello-node:8080
CLIENT VALUES:
client_address=10.233.75.2
command=GET
real path=/
query=nil
request_version=1.1
request_uri=http://hello-node:8080/

SERVER VALUES:
server_version=nginx: 1.10.0 - lua: 10001

HEADERS RECEIVED:
accept=*/*
host=hello-node:8080
user-agent=curl/7.47.0
BODY:
-no body in request-[centos@cp1 ~]$
````
- Проверка доступа `hello-node` --> `hello-node-noacc` (отсутствует)
````bash
[centos@cp1 ~]$ kubectl exec hello-node-697897c86-jg7d8  -- curl -s -m 1 hello-node-noacc:8080
command terminated with exit code 28
[centos@cp1 ~]$
````
#### Задание 2: изучить, что запущено по умолчанию

Самый простой способ — проверить командой calicoctl get . Для проверки стоит получить список нод, ipPool и profile.
Требования:
- установить утилиту calicoctl; 
- получить 3 вышеописанных типа в консоли.

#### Ответ

- Утилита `calicoctl` уже была установлена с помощью `kubespray`
````bash
[centos@cp1 ~]$ calicoctl version
Client Version:    v3.23.3
Git commit:        3a3559be1
Cluster Version:   v3.23.3
Cluster Type:      kubespray,kubeadm,kdd,k8s
[centos@cp1 ~]$
````
- Команда  `calicoctl get ipPool`
````bash
[centos@cp1 ~]$ calicoctl get ipPool
NAME           CIDR             SELECTOR
default-pool   10.233.64.0/18   all()

[centos@cp1 ~]$
````
- Команда `calicoctl get nodes`
````bash
[centos@cp1 ~]$ calicoctl get nodes
NAME
cp1
node1
node2
node3
node4

[centos@cp1 ~]$
````
- Команда `calicoctl get profile`
````bash
[centos@cp1 ~]$ calicoctl get profile
NAME
projectcalico-default-allow
kns.default
kns.kube-node-lease
kns.kube-public
kns.kube-system
ksa.default.default
ksa.kube-node-lease.default
ksa.kube-public.default
ksa.kube-system.attachdetach-controller
ksa.kube-system.bootstrap-signer
ksa.kube-system.calico-kube-controllers
ksa.kube-system.calico-node
ksa.kube-system.certificate-controller
ksa.kube-system.clusterrole-aggregation-controller
ksa.kube-system.coredns
ksa.kube-system.cronjob-controller
ksa.kube-system.daemon-set-controller
ksa.kube-system.default
ksa.kube-system.deployment-controller
ksa.kube-system.disruption-controller
ksa.kube-system.dns-autoscaler
ksa.kube-system.endpoint-controller
ksa.kube-system.endpointslice-controller
ksa.kube-system.endpointslicemirroring-controller
ksa.kube-system.ephemeral-volume-controller
ksa.kube-system.expand-controller
ksa.kube-system.generic-garbage-collector
ksa.kube-system.horizontal-pod-autoscaler
ksa.kube-system.job-controller
ksa.kube-system.kube-proxy
ksa.kube-system.namespace-controller
ksa.kube-system.node-controller
ksa.kube-system.nodelocaldns
ksa.kube-system.persistent-volume-binder
ksa.kube-system.pod-garbage-collector
ksa.kube-system.pv-protection-controller
ksa.kube-system.pvc-protection-controller
ksa.kube-system.replicaset-controller
ksa.kube-system.replication-controller
ksa.kube-system.resourcequota-controller
ksa.kube-system.root-ca-cert-publisher
ksa.kube-system.service-account-controller
ksa.kube-system.service-controller
ksa.kube-system.statefulset-controller
ksa.kube-system.token-cleaner
ksa.kube-system.ttl-after-finished-controller
ksa.kube-system.ttl-controller

[centos@cp1 ~]$

````
