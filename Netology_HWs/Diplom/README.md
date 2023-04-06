# devops-netology
### performed by Kirill Karagodin
#### Дипломный практикум в Yandex.Cloud

* [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
- Следует использовать последнюю стабильную версию [Terraform](https://www.terraform.io/).

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: [Terraform Cloud](https://app.terraform.io/)  
   б. Альтернативный вариант: S3 bucket в созданном ЯО аккаунте
3. Настройте [workspaces](https://www.terraform.io/docs/language/state/workspaces.html)  
   а. Рекомендуемый вариант: создайте два workspace: *stage* и *prod*. В случае выбора этого варианта все последующие шаги должны учитывать факт существования нескольких workspace.  
   б. Альтернативный вариант: используйте один workspace, назвав его *stage*. Пожалуйста, не используйте workspace, создаваемый Terraform-ом по-умолчанию (*default*).
4. Создайте VPC с подсетями в разных зонах доступности.
5. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
6. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать региональный мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистр с собранным docker image. В качестве регистра может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Рекомендуемый способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте в кластер [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры.

Альтернативный вариант:
1. Для организации конфигурации можно использовать [helm charts](https://helm.sh/)

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/) либо [gitlab ci](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/)

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистр, а также деплой соответствующего Docker образа в кластер Kubernetes.

---
## Этапы выполнения:

### Инфраструктура

Для выполнения данного проекта необходимо спроектировать инфраструктуру и развернуть ее в Yandex Claud.
В качестве целевой модели была выбранна следующая конфигурация:
1. Все компоненты управления инфраструктурой внутри облака (Jenkins+агенты, Grafana+Prometheus, Nginx(Балансировщик))
вынесены в отдельную подсеть 10.200.80.0/28. (Вынос Grafana+Prometheus из класера, как предлагается в задании в разделе 
"Подготовка cистемы мониторинга и деплой приложения" обусловлен тем что, используется два отдельных кластера, так же 
предполагается настройка мониторинга и остальных серверов в инфраструктуре.).
2. "Боевой" кластер Kubernetes (PROD)  - 10.200.110.0/27 без доступа из "дикого" интернета.
3. Тестовый кластер Kubernetes (STAGE) - 10.200.100.0/27 без доступа из "дикого" интернета.
4. Отельные агенты для "боевой" и тестовой среды (stage_agent prod_agent). 
5. Агенты имеют доступ только к своим средам.

Схема сети представлена на картинке ниже

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/infra.JPG)

Для реализации данной схемы, был описан конфиг [Terraform](https://github.com/kirill-karagodin/infra-playbook/tree/main/terraform)
- [network.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/network.tf) - создает сеть и три подсети (group-1, stage, prod)
- [stage_nodes.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/stage_nodes.tf) и [prod_nodes.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/prod_nodes.tf) - создание серверов для кластеров тестовой и боевой среды
- [stage-agent.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/stage-agent.tf) и [prod-agent.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/prod-agent.tf) - агенты дженкинс
- [jenkins-master.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/jenkins-master.tf) - сервер Jenkins
- [grafana.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/grafana.tf) - сервер где будет располагаться Grafana+Prometheus
- [nginx.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/nginx.tf) - балансировщик Nginx, в схеме он обрабатывает запросы из интернета и предоставляет доступ к ресурсам по DNS именам
- [dns.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/dns.tf) - сервис YC
- [bucket.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/bucket.tf) - сервис YC, куда поместим две картинки, которые будут использоваться в тестовом приложении

В качестве ресурсов для всем нод в данной инфраструктуре (описанны в файле [variables.tf](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/variables.tf))
было выделено следующее:
- CPU - 2 core
- RAM - 4Gb
- HDD - 10Gb
- Зарезервированны статичные IP адреса для нод в своих подсетях
- Для нод кластеров PROD и STAGE NAT - False

После выполнения _terraform apply_ получаем следующее:

Общая картина

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/infra-all.JPG)

Сервера

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/servers.JPG)

Bucket

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/bucket.JPG)

Балансировщики

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/bl.JPG)

ClodDNS

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/dns.JPG)

### Установка CI/CD и мониторинга 

Для первоначальной установки на "голые" сервера программного обеспечения будем использовать, созданный для этого проекта, plyabook [_infra-playbook_](https://github.com/kirill-karagodin/infra-playbook)
Plyabook предназначен для следующих целей:
- Установка Jenkins сервера
- Установка ПО Jenkuns-a на агентах
- Установка ПО Grafana и Prometheus (Grafana установлена версии 9.4.7. на данный момент доступна к скачиванию на террирории РФ, [ссылка на загрузку rpm пакета](https://dl.grafana.com/oss/release/grafana-9.4.7-1.x86_64.rpm))
- Установка и конфигурирование Nginx

В состав данного playbook-а вошли
1. За основу был взят playbook [Jenkins](https://github.com/netology-code/mnt-homeworks/tree/MNT-13/09-ci-04-jenkins/infrastructure)
2. Для установки Nginx использовалась роль [nginx-role](https://github.com/kirill-karagodin/nginx-role)
3. Основой для Prometheus послужил [Ansible Playbook for Prometheus and Grafana](https://github.com/LucaRottiers/Prometheus-Grafana-Ansible-Playbook)

После окончания работы playbook-а получаем следующее:

Jenkins доступен по [адресу](http://jenkins.karagodin-ka.ru/)

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/jenkins.JPG)

Подключенные агенты

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/agents.JPG)


Grafana доступна по [ссылке](http://grafana.karagodin-ka.ru)

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/grafana.JPG)

Prometheus

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/prometheus1.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/prometheus2.JPG)

### Работа внутри инфраструктуры, подготовка и деплой тестового приложения

Для дальнейшей работы по проекту разделим ее на несколько шагов:
1. Установка ПО Kubernetes в Prod и Stage кластеры.
2. Установка компонента Node Exporter на сервера и в кластера Prod и Stage.
3. Организация сборки и интеграции тестового приложения в кластера Prod и Stage.

#### Шаг 1.

Для установки ПО Kubernetes в Prod и Stage будем использовать [kubespray](https://github.com/kirill-karagodin/kubespray), 
подложив в него заранее созданные [terraform-ом](https://github.com/kirill-karagodin/infra-playbook/blob/main/terraform/inventory.tf) файлы _hosts_:
- [prod](https://github.com/kirill-karagodin/infra-playbook/blob/main/inventory/k8s-prod.ini)
- [srtage](https://github.com/kirill-karagodin/infra-playbook/blob/main/inventory/k8s-stage.ini)

Создадим 2 Item-а в Jenkins со свободной конфигурацией для PROD и STAGE

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/kude-all.JPG)

В управлении исходным котом ставим "Git" и указываем ссылку на наш репозиторий с kubespray

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/git.JPG)

В шагах сборки

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/step.JPG)

На картинке показан пример для PROD кластера. Для STAGE достаточно в шагах сброки заменить
````bash
pip3.9 install -r requirements.txt
ansible-playbook -i inventory/netology-cluster/k8s-prod.ini cluster.yml -b -v
````
на
````bash
pip3.9 install -r requirements.txt
ansible-playbook -i inventory/netology-cluster/k8s-ыефпу.ini cluster.yml -b -v
````
Но при первом запуске мы получим ошибку по доступу, так как публичный ключ, который был оправлен на хосты при работе terraform-а,
не совпадает с приватным ключем пользователя jenkins, от имени которого будут проходить работы агентов.

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/error.JPG)

И при попытке подключиться с любого хоста внутри инфраструктуры мы получим тот же результат, так как на них нет приватной части ключа.
Для решения данной проблемы мной были приняты следующие меры:
1. Для подключения к недоступным хостам (все хосты кластеров Prod и Stage), я настроил тунельное подлючение со своего ноутбука.
для этого неоходимо было создать файл ~/.ssh/cofig
````bash
mojnovse@mojno-vseMacBook ~ % ls -la ~/.ssh/
total 48
drwx------   6 mojnovse  staff    192 Mar 28 18:50 .
drwxr-xr-x+ 36 mojnovse  staff   1152 Apr  6 01:46 ..
-rw-r--r--   1 mojnovse  staff    719 Mar 29 15:05 config
-rw-------   1 mojnovse  staff   2622 Dec  7 23:55 id_rsa
-rw-r--r--   1 mojnovse  staff    585 Dec  7 23:55 id_rsa.pub
-rw-r--r--   1 mojnovse  staff  11035 Mar 29 18:48 known_hosts
mojnovse@mojno-vseMacBook ~ %
````
Со следующим содержанием:
````bash
mojnovse@mojno-vseMacBook ~ % cat ~/.ssh/config
Host stage-node1
     HostName 10.200.100.11
     User cloud-user
     ProxyCommand ssh -W %h:%p cloud-user@130.193.51.32


Host stage-nodet2
     HostName 10.200.100.12
     User cloud-user
     ProxyCommand ssh -W %h:%p cloud-user@130.193.51.32


Host stage-node3
     HostName 10.200.100.13
     User cloud-user
     ProxyCommand ssh -W %h:%p cloud-user@130.193.51.32

Host prod-node1
     HostName 10.200.110.11
     User cloud-user
     ProxyCommand ssh -W %h:%p cloud-user@130.193.51.32


Host prod-node2
     HostName 10.200.110.12
     User cloud-user
     ProxyCommand ssh -W %h:%p cloud-user@130.193.51.32


Host prod-node3
     HostName 10.200.110.13
     User cloud-user
     ProxyCommand ssh -W %h:%p cloud-user@130.193.51.32
mojnovse@mojno-vseMacBook ~ %
````
Теперь можно подключаться (пример подключения к 1 ноде кластера PROD)
````bash
mojnovse@mojno-vseMacBook ~ % ssh prod-node1
Last login: Wed Apr  5 19:28:51 2023 from 10.200.80.5
[cloud-user@cp1 ~]$
````
Далее копируем публичную часть пользователя jenkins ключа на ноды (с prod агента на ноды кластера PROD, со stage агента - на STAGE)

Пример с первой ноды STAGE кластера
````bash
[cloud-user@stage-agent1 ~]$ sudo su
[root@stage-agent1 cloud-user]# su - jenkins
Last login: Tue Apr  4 11:14:59 UTC 2023 on pts/0
[jenkins@stage-agent1 ~]$ ssh cloud-user@10.200.100.11
Last login: Wed Apr  5 18:26:49 2023 from 10.200.80.5
[cloud-user@stage-cp1 ~]$ cat ~/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQChMcGvOK4FwqaYPxYBeEwEOm4QEOVFY7Eel/gg3V1WKwPuktHif4HEgwDR9ZVKnvI7T6nGWp5/s0yxP39Yv9HrFWMlQtzRWFGBxHyDdc5wFCudBxXnglevpTRiwhi23qIlIEPMngXC74zzwe/JKK1V8T6xYOiJi4VkMWV8Y6VX0n9H2vUFtNDdR5R3Hdk4yd4N9myo55GLcYKs6HtBDNDT/Oaz6qz7KI4QRZlr6ycioa6YZoHjirPYr9bMl1uv/td6XB1tjUc3HTmJ8FOZJ6xFp6uonQKpgQZ19AhVb54GDIO563VYOOADeVCPLkaBCVq1OQ9pI2Wp2wlFC5PwvMQ3TIslGhVrQT4N68WtsVBlyKiYC3JeO8UzSK82tnLl9ioTAcX3lSHAr62JVMjtJXBc446laBP3i7OroRl7uQOJUl3B1bMWRnoRIiyDd8KasDMWZxBeYZ5n8nMLvNYgb7lr7m6QpxiWcm5JT0rbJWdB46ZhHlIHzoWt5zCV/G2RLRE= mojnovse@mojno-vseMacBook.local
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqfQ8Bs7XpK/7+qDMzgsFGY5P7hfLchuOFkiIgEN8kBgxXgheIRYLQNZtNEXR4Opd/E92m798x3vYfWtQP81GvJRIWedpjpQcsAYEQUu5i/Et2vlcqEK3DIDe49ab1z3bW4Gky8BKF7IRRBGj3+QFzBHtK0rfM9lvtG9RvUtHDzyhuTf7WQ7ug7iFsAGW8Dpwqjpw5dYhAm4JnUA0h2k8EFrFSHTFMyakoNwR5Cyz3bs30KYjUuTUcDw6sZU/JjItsXgvlDH4NuEiNoQ3D/le9vWr0ahxCMyeHRWTonH2IPhsr4bbXnJlMN71OjcytEqpTMSJYYWWZTJD1je61lN4ZhJaTUhm/OWYqs7YL9kJKmOSKJTnN6xluncJXDYVFpPOerrwGZWyjktvnKILgZ9WIcDvnHO47jqsHVdtnQDUzZiisNPltkgCgKjlpO5/Btbb2qxBfHPqp1XPux49fl+Hm+BtYWAY+QpRu4le+3dlHxLWUsHHlQqByeSbs71ieS6U= jenkins@stage-agent1.netology.cloud

[cloud-user@stage-cp1 ~]$
````
После проделанных манипуляций запускаем деплой

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Diplom/img/kub-finsh.JPG)

STAGE кластер
````bash
[cloud-user@stage-cp1 ~]$ kubectl get nodes -o wide
NAME          STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE          KERNEL-VERSION          CONTAINER-RUNTIME
stage-cp1     Ready    control-plane   8d    v1.25.4   10.200.100.11   <none>        CentOS Stream 8   4.18.0-408.el8.x86_64   docker://20.10.20
stage-node1   Ready    <none>          8d    v1.25.4   10.200.100.12   <none>        CentOS Stream 8   4.18.0-408.el8.x86_64   docker://20.10.20
stage-node2   Ready    <none>          8d    v1.25.4   10.200.100.13   <none>        CentOS Stream 8   4.18.0-408.el8.x86_64   docker://20.10.20
[cloud-user@stage-cp1 ~]$

````
PROD кластер
````bash
NAME    STATUS   ROLES           AGE   VERSION   INTERNAL-IP     EXTERNAL-IP   OS-IMAGE          KERNEL-VERSION          CONTAINER-RUNTIME
cp1     Ready    control-plane   8d    v1.25.4   10.200.110.11   <none>        CentOS Stream 8   4.18.0-408.el8.x86_64   docker://20.10.20
node1   Ready    <none>          8d    v1.25.4   10.200.110.12   <none>        CentOS Stream 8   4.18.0-408.el8.x86_64   docker://20.10.20
node2   Ready    <none>          8d    v1.25.4   10.200.110.13   <none>        CentOS Stream 8   4.18.0-408.el8.x86_64   docker://20.10.20
[cloud-user@cp1 ~]$

````
#### Шаг 2.
