# devops-netology
### performed by Kirill Karagodin
#### HW 12.1 Компоненты Kubernetes

#### Задача 1: Установить Minikube

Установил Minikube локально на ноутбуке (MacOs) по данной [инструкции](https://kubernetes.io/ru/docs/tasks/tools/install-minikube/)
````bash
mojnovse@mojno-vseMacBook ~ % minikube version
minikube version: v1.28.0
commit: 986b1ebd987211ed16f8cc10aed7d2c42fc8392f
mojnovse@mojno-vseMacBook ~ %
````
При первой попытке старта получил ошибку
````bash
mojnovse@mojno-vseMacBook ~ % minikube start --vm-driver=none
* minikube v1.28.0 на Darwin 10.15.7

X Exiting due to DRV_UNSUPPORTED_OS: The driver 'none' is not supported on darwin/amd64

mojnovse@mojno-vseMacBook ~ %
````
После изменеия драйвер с `none` на `docker` minikube запускается без проблем
````bash
mojnovse@mojno-vseMacBook ~ % minikube start --vm-driver=docker
* minikube v1.28.0 на Darwin 10.15.7
* Используется драйвер docker на основе конфига пользователя
* Using Docker Desktop driver with root privileges
* Запускается control plane узел minikube в кластере minikube
* Скачивается базовый образ ...
    > gcr.io/k8s-minikube/kicbase:  0 B [________________________] ?% ? p/s 50s
* Creating docker container (CPUs=2, Memory=4000MB) ...
* Подготавливается Kubernetes v1.25.3 на Docker 20.10.20 ...
  - Generating certificates and keys ...
  - Booting up control plane ...
  - Configuring RBAC rules ...
* Компоненты Kubernetes проверяются ...
  - Используется образ gcr.io/k8s-minikube/storage-provisioner:v5
* Включенные дополнения: storage-provisioner, default-storageclass
* Готово! kubectl настроен для использования кластера "minikube" и "default" пространства имён по умолчанию
mojnovse@mojno-vseMacBook ~ % minikube status
minikube
type: Control Plane
host: Running
kubelet: Running
apiserver: Running
kubeconfig: Configured

mojnovse@mojno-vseMacBook ~ %
````
#### Задача 2: Запуск Hello World
Запустил приложение Hello World согласно [инструкции](https://kubernetes.io/ru/docs/tutorials/hello-minikube/#%D1%81%D0%BE%D0%B7%D0%B4%D0%B0%D0%BD%D0%B8%D0%B5-%D0%BA%D0%BB%D0%B0%D1%81%D1%82%D0%B5%D1%80%D0%B0-minikube)
````bash
mojnovse@mojno-vseMacBook ~ % kubectl create deployment hello-node --image=k8s.gcr.io/echoserver:1.4
deployment.apps/hello-node created
mojnovse@mojno-vseMacBook ~ % kubectl get deployments
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
hello-node   1/1     1            1           93s
mojnovse@mojno-vseMacBook ~ % kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
hello-node-697897c86-2p4xl   1/1     Running   0          2m9s
mojnovse@mojno-vseMacBook ~ % 
````
Создал сервис
````bash
mojnovse@mojno-vseMacBook ~ % kubectl expose deployment hello-node --type=LoadBalancer --port=8080
service/hello-node exposed
mojnovse@mojno-vseMacBook ~ % kubectl get services
NAME         TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
hello-node   LoadBalancer   10.99.163.210   <pending>     8080:32349/TCP   13s
kubernetes   ClusterIP      10.96.0.1       <none>        443/TCP          5m48s
mojnovse@mojno-vseMacBook ~ % minikube service hello-node
|-----------|------------|-------------|---------------------------|
| NAMESPACE |    NAME    | TARGET PORT |            URL            |
|-----------|------------|-------------|---------------------------|
| default   | hello-node |        8080 | http://192.168.49.2:32349 |
|-----------|------------|-------------|---------------------------|
* Starting tunnel for service hello-node.
|-----------|------------|-------------|------------------------|
| NAMESPACE |    NAME    | TARGET PORT |          URL           |
|-----------|------------|-------------|------------------------|
| default   | hello-node |             | http://127.0.0.1:49952 |
|-----------|------------|-------------|------------------------|
* Opening service default/hello-node in default browser...
! Because you are using a Docker driver on darwin, the terminal needs to be open to run it.
````
Установил аддоны `ingress` и `dashboard`
- ingress
````bash
mojnovse@mojno-vseMacBook ~ % minikube addons enable ingress
* ingress is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
* After the addon is enabled, please run "minikube tunnel" and your ingress resources would be available at "127.0.0.1"
  - Используется образ k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
  - Используется образ k8s.gcr.io/ingress-nginx/kube-webhook-certgen:v1.1.1
  - Используется образ k8s.gcr.io/ingress-nginx/controller:v1.2.1
* Verifying ingress addon...

* The 'ingress' addon is enabled
mojnovse@mojno-vseMacBook ~ %
````
- dashboard
````bash
mojnovse@mojno-vseMacBook ~ % minikube addons enable dashboard
* dashboard is an addon maintained by Kubernetes. For any concerns contact minikube on GitHub.
You can view the list of minikube maintainers at: https://github.com/kubernetes/minikube/blob/master/OWNERS
  - Используется образ docker.io/kubernetesui/dashboard:v2.7.0
  - Используется образ docker.io/kubernetesui/metrics-scraper:v1.0.8
* Some dashboard features require the metrics-server addon. To enable all features please run:

        minikube addons enable metrics-server


* The 'dashboard' addon is enabled
mojnovse@mojno-vseMacBook ~ %
````
- список доступных и установленных аддонов
````bash
mojnovse@mojno-vseMacBook ~ % minikube addons list
|-----------------------------|----------|--------------|--------------------------------|
|         ADDON NAME          | PROFILE  |    STATUS    |           MAINTAINER           |
|-----------------------------|----------|--------------|--------------------------------|
| ambassador                  | minikube | disabled     | 3rd party (Ambassador)         |
| auto-pause                  | minikube | disabled     | Google                         |
| cloud-spanner               | minikube | disabled     | Google                         |
| csi-hostpath-driver         | minikube | disabled     | Kubernetes                     |
| dashboard                   | minikube | enabled ✅   | Kubernetes                     |
| default-storageclass        | minikube | enabled ✅   | Kubernetes                     |
| efk                         | minikube | disabled     | 3rd party (Elastic)            |
| freshpod                    | minikube | disabled     | Google                         |
| gcp-auth                    | minikube | disabled     | Google                         |
| gvisor                      | minikube | disabled     | Google                         |
| headlamp                    | minikube | disabled     | 3rd party (kinvolk.io)         |
| helm-tiller                 | minikube | disabled     | 3rd party (Helm)               |
| inaccel                     | minikube | disabled     | 3rd party (InAccel             |
|                             |          |              | [info@inaccel.com])            |
| ingress                     | minikube | enabled ✅   | Kubernetes                     |
| ingress-dns                 | minikube | disabled     | Google                         |
| istio                       | minikube | disabled     | 3rd party (Istio)              |
| istio-provisioner           | minikube | disabled     | 3rd party (Istio)              |
| kong                        | minikube | disabled     | 3rd party (Kong HQ)            |
| kubevirt                    | minikube | disabled     | 3rd party (KubeVirt)           |
| logviewer                   | minikube | disabled     | 3rd party (unknown)            |
| metallb                     | minikube | disabled     | 3rd party (MetalLB)            |
| metrics-server              | minikube | disabled     | Kubernetes                     |
| nvidia-driver-installer     | minikube | disabled     | Google                         |
| nvidia-gpu-device-plugin    | minikube | disabled     | 3rd party (Nvidia)             |
| olm                         | minikube | disabled     | 3rd party (Operator Framework) |
| pod-security-policy         | minikube | disabled     | 3rd party (unknown)            |
| portainer                   | minikube | disabled     | 3rd party (Portainer.io)       |
| registry                    | minikube | disabled     | Google                         |
| registry-aliases            | minikube | disabled     | 3rd party (unknown)            |
| registry-creds              | minikube | disabled     | 3rd party (UPMC Enterprises)   |
| storage-provisioner         | minikube | enabled ✅   | Google                         |
| storage-provisioner-gluster | minikube | disabled     | 3rd party (Gluster)            |
| volumesnapshots             | minikube | disabled     | Kubernetes                     |
|-----------------------------|----------|--------------|--------------------------------|
mojnovse@mojno-vseMacBook ~ %
````
#### Задача 2: Установить kubectl
Проверил работу приложения из задания 2, запустив port-forward до кластера 
````bash
mojnovse@mojno-vseMacBook ~ % kubectl port-forward service/hello-node --address 0.0.0.0 33333:8080
Forwarding from 0.0.0.0:33333 -> 8080
````
Подключился по адресу `http://10.0.62.229:33333/` cо стационарного ПК на ноутбук, на котором поднят minikube 
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Devkub/HW_12.1/img/kub.JPG)