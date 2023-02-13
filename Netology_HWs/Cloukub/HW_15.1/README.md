# devops-netology
### performed by Kirill Karagodin
#### HW 15.1 Организация сети

#### Задача 1 Яндекс.Облако (обязательное к выполнению)

1. Создать VPC.
- Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
- Создать в vpc subnet с названием `public`, сетью 192.168.10.0/24. 
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать
`fd80mrhj8fl2oe87o4e1` 
- Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 192.168.20.0/24. 
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс 
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и
убедиться что есть доступ к интернету

#### Ответ

Для выполнения задания был создан конфиг для `terraform` в котором были указаны следующие значения:

1. Создан NAT-инстанс (файл [`node1.tf`](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.1/src/terraform/nede1.tf)) и присвоен ему адрес 192.168.10.254
2. Создана виртуальная машина для подсети `public` (файл [`node2.tf`](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.1/src/terraform/nede2.tf))
3. Создана виртуальная машина для подсети `private` (файл [`node3.tf`](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.1/src/terraform/nede3.tf)) без выхода в интернет
4. Файл [`network.tf`](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.1/src/terraform/network.tf)
- Создана пустая VPC
- Создана `subnet` с названием `public`, сетью 192.168.10.0/24. 
- Создана `subnet` с названием `private`, сетью 192.168.20.0/24.
- Создан `route table` и добавлен статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
5. В файле `variables.tf` указываем образ для NAT-инстанса и так же его статический IP адрес 
````bash
...
# Image node 1 (NAT)
variable "image_node1" {
  default = "fd80mrhj8fl2oe87o4e1"
}
...
# IP adress for nat_node
variable "ipv4_internals_node1" {
  default = "192.168.10.254"
}
````
Проверяем конфиг
````bash
mojnovse@mojno-vseMacBook terraform % terraform validate
Success! The configuration is valid.

mojnovse@mojno-vseMacBook terraform % terraform plan
..............
  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_route_table.private_table will be created
  + resource "yandex_vpc_route_table" "private_table" {
      + created_at = (known after apply)
      + folder_id  = (known after apply)
      + id         = (known after apply)
      + labels     = (known after apply)
      + name       = "private_table"
      + network_id = (known after apply)

      + static_route {
          + destination_prefix = "0.0.0.0/0"
          + next_hop_address   = "192.168.10.254"
        }
    }

  # yandex_vpc_subnet.subnet-1 will be created
  + resource "yandex_vpc_subnet" "subnet-1" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "public"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.10.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

  # yandex_vpc_subnet.subnet-2 will be created
  + resource "yandex_vpc_subnet" "subnet-2" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "private"
      + network_id     = (known after apply)
      + route_table_id = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.20.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 8 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_node1_yandex_cloud = (known after apply)
  + external_ip_address_node2_yandex_cloud = (known after apply)
  + external_ip_address_node3_yandex_cloud = (known after apply)
  + internal_ip_address_node1_yandex_cloud = "192.168.10.254"
  + internal_ip_address_node2_yandex_cloud = (known after apply)
  + internal_ip_address_node3_yandex_cloud = (known after apply)

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if
you run "terraform apply" now.
mojnovse@mojno-vseMacBook terraform %
````
- Выполним apply
````bash
mojnovse@mojno-vseMacBook terraform % terraform apply -auto-approve
.........
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node1_yandex_cloud = "51.250.81.63"
external_ip_address_node2_yandex_cloud = "51.250.79.132"
external_ip_address_node3_yandex_cloud = ""
internal_ip_address_node1_yandex_cloud = "192.168.10.254"
internal_ip_address_node2_yandex_cloud = "192.168.10.13"
internal_ip_address_node3_yandex_cloud = "192.168.20.34"
mojnovse@mojno-vseMacBook terraform %

````
- Сети
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.1/img/networks.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.1/img/subnets.JPG)
- Виртуальные машины
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.1/img/vm.JPG)
- Статические маршруты
````bash
mojnovse@mojno-vseMacBook terraform % yc vpc route-table list
+----------------------+---------------+-------------+----------------------+
|          ID          |     NAME      | DESCRIPTION |      NETWORK-ID      |
+----------------------+---------------+-------------+----------------------+
| enptvpjo1s54toslq0ne | private_table |             | enpndn9hpjkgeu3fkodt |
+----------------------+---------------+-------------+----------------------+

mojnovse@mojno-vseMacBook terraform %
````
- Проверка трафика

Подключаемся к `agent1` и проверяем доступ до `ya.ru`
````bash
mojnovse@mojno-vseMacBook terraform % ssh centos@51.250.79.132
The authenticity of host '51.250.79.132 (51.250.79.132)' can't be established.
ECDSA key fingerprint is SHA256:mdNH+tplYEb8Mcjfk5GNTOyHj8geVHnV9UgG0FYpRPM.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.250.79.132' (ECDSA) to the list of known hosts.
[centos@agent1 ~]$ curl ifconfig.me
51.250.79.132[centos@agent1 ~]$ ping ya.ru
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=59 time=0.753 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=59 time=0.373 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=3 ttl=59 time=0.618 ms
^C
--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 0.373/0.581/0.753/0.158 ms
[centos@agent1 ~]$
````
Подключаемся к `agent2` по внуртеннему `IP` и проверяем доступ до `ya.ru`
Перед тем как подключиться необходимо на `agent1` передать свой приватный ключ
````bash
mojnovse@mojno-vseMacBook terraform % scp ~/.ssh/id_rsa centos@51.250.79.132:.ssh/
id_rsa                                                                                100% 2622   145.9KB/s   00:00
mojnovse@mojno-vseMacBook terraform %
````
Подключаемся с `agent1` на `agent2`
````bash
[centos@agent1 ~]$ ssh centos@192.168.20.34
[centos@agent2 ~]$ ping ya.ru
PING ya.ru (87.250.250.242) 56(84) bytes of data.
64 bytes from ya.ru (87.250.250.242): icmp_seq=1 ttl=57 time=2.48 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=2 ttl=57 time=0.869 ms
64 bytes from ya.ru (87.250.250.242): icmp_seq=3 ttl=57 time=0.866 ms
^C
--- ya.ru ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2002ms
rtt min/avg/max/mdev = 0.866/1.405/2.482/0.762 ms
[centos@agent2 ~]$
````

