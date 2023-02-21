# devops-netology
### performed by Kirill Karagodin
#### HW 15.3 Безопасность в облачных провайдерах

#### Задача 1 Яндекс.Облако (обязательное к выполнению)

Задание 1. Яндекс.Облако (обязательное к выполнению)

1. С помощью ключа в KMS необходимо зашифровать содержимое бакета:
- Создать ключ в KMS, 
- С помощью ключа зашифровать содержимое бакета, созданного ранее.
2. (Выполняется НЕ в terraform) *Создать статический сайт в Object Storage c собственным публичным адресом и сделать 
доступным по HTTPS
- Создать сертификат, 
- Создать статическую страницу в Object Storage и применить сертификат HTTPS, 
- В качестве результата предоставить скриншот на страницу с сертификатом в заголовке ("замочек").

#### Ответ

Задание 1.

Конфиг [`terraform`](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.3/src/terraform)
- Создан ключ [**`kms`**](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.3/src/terraform/kms.tf)
- Выдадим права на ключ сервисному аккаунту `sa-bucket`
Так как при использовании попытке выдать права СА средствами `terraform`через блок в `kms.tf`
````bash
resource "yandex_resourcemanager_folder_iam_member" "kms-user" {
  folder_id = var.yandex_folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${var.sa-bucket}"
}
````
получаем ошибку:
````bash
yandex_lb_network_load_balancer.load-balancer: Creation complete after 3s [id=enpglsu4gtms0jotguie]
╷
│ Error: error putting object in bucket "karagodin-netology-bucket": AccessDenied: Access Denied
│       status code: 403, request id: 17b0ba15fcad6eaa, host id:
│
│   with yandex_storage_object.object-1,
│   on bucket.tf line 24, in resource "yandex_storage_object" "object-1":
│   24: resource "yandex_storage_object" "object-1" {
│
╵
╷
│ Error: Error applying IAM policy for folder "b1gfege9gjopte1c9qa1": Error setting IAM policy for folder "b1gfege9gjopte1c9qa1": server-request-id = b21b18e3-291f-4adb-9608-569a6f3d3ecf server-trace-id = f38b63bd89dd581:2016ef7039535354:f38b63bd89dd581:1 client-request-id = 586df018-509e-464d-8cd8-6c0ac919b066 client-trace-id = 19f67b3d-ca7a-461f-90af-903bce33f9cf rpc error: code = PermissionDenied desc = Permission denied
│
│   with yandex_resourcemanager_folder_iam_member.kms-user,
│   on kms.tf line 9, in resource "yandex_resourcemanager_folder_iam_member" "kms-user":
│    9: resource "yandex_resourcemanager_folder_iam_member" "kms-user" {
│
╵
mojnovse@mojno-vseMacBook terraform %
````
То выдадим права через консоль YC
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.3/img/sa-bucket.JPG)
- Зашифруем с помощью ключа
````bash
Apply complete! Resources: 8 added, 0 changed, 0 destroyed.

Outputs:

bucket_domain_name = "http://karagodin-netology-bucket.storage.yandexcloud.net/test.jpg"
external_load_balancer_ip = "51.250.43.97"
mojnovse@mojno-vseMacBook terraform %
````
Картинка в бакете
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.3/img/b-test.JPG)
- Ресурсы YC

Дашборд
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.3/img/dashboard.JPG)
Информация о ключе
````bash
mojnovse@mojno-vseMacBook terraform % yc kms symmetric-key list
+----------------------+----------------------+----------------------+-------------------+---------------------+--------+
|          ID          |         NAME         |  PRIMARY VERSION ID  | DEFAULT ALGORITHM |     CREATED AT      | STATUS |
+----------------------+----------------------+----------------------+-------------------+---------------------+--------+
| abjbv1cjbsd5ssnppv7a | example-symetric-key | abj9gumrci1e7u0qj47l | AES_128           | 2023-02-21 15:31:44 | ACTIVE |
+----------------------+----------------------+----------------------+-------------------+---------------------+--------+

mojnovse@mojno-vseMacBook terraform %

````
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.3/img/key.JPG)

Bucket

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.3/img/bucket.JPG)


