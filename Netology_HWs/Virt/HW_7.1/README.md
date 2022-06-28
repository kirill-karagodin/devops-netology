# devops-netology
### performed by Kirill Karagodin
#### HW7.1 Инфраструктура как код.

1. Выбор инструментов.

Легенда

Через час совещание на котором менеджер расскажет о новом проекте. Начать работу над которым надо будет уже сегодня.
На данный момент известно, что это будет сервис, который ваша компания будет предоставлять внешним заказчикам. 
Первое время, скорее всего, будет один внешний клиент, со временем внешних клиентов станет больше.
Так же по разговорам в компании есть вероятность, что техническое задание еще не четкое, что приведет к большому 
количеству небольших релизов, тестирований интеграций, откатов, доработок, то есть скучно не будет.
Вам, как девопс инженеру, будет необходимо принять решение об инструментах для организации инфраструктуры. На данный 
момент в вашей компании уже используются следующие инструменты:
- остатки Сloud Formation
- некоторые образы сделаны при помощи Packer,
- год назад начали активно использовать Terraform,
- разработчики привыкли использовать Docker,
- уже есть большая база Kubernetes конфигураций,
- для автоматизации процессов используется Teamcity,
- также есть совсем немного Ansible скриптов,
- и ряд bash скриптов для упрощения рутинных задач.

Для этого в рамках совещания надо будет выяснить подробности о проекте, что бы в итоге определиться с инструментами:
- Какой тип инфраструктуры будем использовать для этого проекта: изменяемый или не изменяемый? 
````
Неизменяемый тип инфраструктуры, в изменяемом возникает проблема дрейфа конфигураций, что негативно 
скажется на большом количестве релизов, тестирования интеграций, откатов и доработок.
````
- Будет ли центральный сервер для управления инфраструктурой? 
````
Выбрать вариант без централизованного сервера будет предпочтительнее для экономии ресурсов и затрат на обсуживание.
Но отдельный сервер для управления инфороструктурой может быть полезн как единая точка входа.
````
- Будут ли агенты на серверах?
````
да, например node_exporter, который собирает данные о вычислительных ресурсах: загрузку процессора, памяти, диска итд.
````
- Будут ли использованы средства для управления конфигурацией или инициализации ресурсов?
````
Инициализация ресурсов отвечает больше за создание самих серверов, а cредства управления конфигурауией предназначены 
больше для установки и администрирования ПО на существующих серверах. Т.к. год назад начали активно использовать
Terraform и есть остатки Сloud Formation, то следовательно будут использованы средсва инициализация ресурсов.
Так как в легенде указано "также есть совсем немного Ansible скриптов", следовательно стредсва управления конфигурацией
будут задейсвованы.
````
Какие инструменты из уже используемых вы хотели бы использовать для нового проекта?
````
Terraform, Ansible, Packer, Docker
````
Хотите ли рассмотреть возможность внедрения новых инструментов для этого проекта?
````
Возможно от TeamCity лучше отказаться в пользу GitLab CI/CD
````
2. Установка терраформ.

Установите терраформ при помощи менеджера пакетов используемого в вашей операционной системе.
При попытке установки terraform при помощи менеджера пакетов получаем ошибку уже на шаге добавления ключа GPG для APT
````bash
root@vb-micrapc:/# curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
Warning: apt-key is deprecated. Manage keyring files in trusted.gpg.d instead (see apt-key(8)).
curl: (22) The requested URL returned error: 403
gpg: no valid OpenPGP data found.
````
Ошибка обусловлена недоступностью продуктов hashicorp на территории РФ
Если смоделировать шаги выполнения данного задания последовательность следующая:
- Добавить ключ
````bash
sudo curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
````
- Добавить репозиторий
````bash
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
````
- Апдейт информации о пакетах
````bash
sudo apt-get update
````
- Установка пакета
````bash
sudo apt-get install terraform
````
3. Поддержка легаси кода.
Изначально в системе уже был установдени terraform в рамках ранее выполненных домашних заданий  
````bash
root@vb-micrapc:/# terraform --version
Terraform v1.2.0
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.2.3. You can update by downloading from https://www.terraform.io/downloads.html
root@vb-micrapc:/# 
````
Устновим вторую версию ПО
````bash
root@vb-micrapc:/opt# mkdir terraform-1.1.6
root@vb-micrapc:/opt# cd terraform-1.1.6/
root@vb-micrapc:/opt/terraform-1.1.6# curl https://hashicorp-releases.website.yandexcloud.net/terraform/1.1.6/terraform_1.1.6_linux_amd64.zip --output terraform_1.1.6_linux_amd64.zip && sha256sum terraform_1.1.6_linux_amd64.zip
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 17.8M  100 17.8M    0     0  10.1M      0  0:00:01  0:00:01 --:--:-- 10.1M
3e330ce4c8c0434cdd79fe04ed6f6e28e72db44c47ae50d01c342c8a2b05d331  terraform_1.1.6_linux_amd64.zip
root@vb-micrapc:/opt/terraform-1.1.6# unzip terraform_1.1.6_linux_amd64.zip
Archive:  terraform_1.1.6_linux_amd64.zip
  inflating: terraform
````
Установленные версии в системе
````bash
root@vb-micrapc:/opt/terraform-1.1.6# ./terraform --version
Terraform v1.1.6
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.2.3. You can update by downloading from https://www.terraform.io/downloads.html
root@vb-micrapc:/opt/terraform-1.1.6# terraform --version
Terraform v1.2.0
on linux_amd64

Your version of Terraform is out of date! The latest version
is 1.2.3. You can update by downloading from https://www.terraform.io/downloads.html
root@vb-micrapc:/opt/terraform-1.1.6#
````