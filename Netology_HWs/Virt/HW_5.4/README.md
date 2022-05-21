# devops-netology
### performed by Kirill Karagodin
#### HW5.4. Введение. Оркестрация группой Docker контейнеров на примере Docker Compose.
1. Создать собственный образ операционной системы с помощью Packer.
````bash
root@vb-micrapc:~/yandex-cloud# yc config list
token: AQAAAAA2_KzsAATuwV_DeU2WQU7rqlabWfbXCcQ
cloud-id: b1g60ss3hrn8qqmiode2
folder-id: b1gfege9gjopte1c9qa1
compute-default-zone: ru-central1-a
root@vb-micrapc:~/yandex-cloud# yc compute image list
+----+------+--------+-------------+--------+
| ID | NAME | FAMILY | PRODUCT IDS | STATUS |
+----+------+--------+-------------+--------+
+----+------+--------+-------------+--------+

root@vb-micrapc:~/yandex-cloud# yc --version
Yandex Cloud CLI 0.91.0 linux/amd64
root@vb-micrapc:~/yandex-cloud# yc vpc network create --name net --labels my-label=netology --description "my first network via yc"
id: enpgfmc5hrh2ndveod8f
folder_id: b1gfege9gjopte1c9qa1
created_at: "2022-05-20T13:06:23Z"
name: net
description: my first network via yc
labels:
  my-label: netology

root@vb-micrapc:~/yandex-cloud# yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "my first subnet via yc"
id: e9b89nh6dhm5nusqhh8k
folder_id: b1gfege9gjopte1c9qa1
created_at: "2022-05-20T13:06:44Z"
name: my-subnet-a
description: my first subnet via yc
network_id: enpgfmc5hrh2ndveod8f
zone_id: ru-central1-a
v4_cidr_blocks:
- 10.1.2.0/24
root@vb-micrapc:/opt/packer# yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd8dav4eclrpsq35rttf | centos-7-base | centos | f2e99agij1uhrk2ioilk | READY  |
+----------------------+---------------+--------+----------------------+--------+

root@vb-micrapc:/opt/packer#

````
2. Создать вашу первую виртуальную машину в Яндекс.Облаке.
````bash
root@vb-micrapc:/opt/terraform# yc iam service-account --folder-id b1gfege9gjopte1c9qa1 list
+----+------+
| ID | NAME |
+----+------+
+----+------+

root@vb-micrapc:/opt/terraform# yc iam service-account create --name karagodin
id: aje4j4kr0fqenth9ug7q
folder_id: b1gfege9gjopte1c9qa1
created_at: "2022-05-20T22:11:19.355665021Z"
name: karagodin

root@vb-micrapc:/opt/terraform# yc iam service-account --folder-id b1gfege9gjopte1c9qa1 list
+----------------------+-----------+
|          ID          |   NAME    |
+----------------------+-----------+
| aje4j4kr0fqenth9ug7q | karagodin |
+----------------------+-----------+

root@vb-micrapc:/opt/terraform# yc iam key create --service-account-name karagodin --output key.json
id: ajenjednsb55l9k6ln1d
service_account_id: aje4j4kr0fqenth9ug7q
created_at: "2022-05-20T22:11:43.344034971Z"
key_algorithm: RSA_2048

root@vb-micrapc:/opt/terraform# yc resource-manager folder add-access-binding default \
  --role   editor \
  --subject serviceAccount:aje4j4kr0fqenth9ug7q
done (1s)

````
Дашборд
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.4/board.JPG)

Созданная виртуальная машина

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.4/VM1.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.4/VM2.JPG)

3. Создать ваш первый готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.4/grafana1.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.4/grafana2.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.4/grafana3.JPG)