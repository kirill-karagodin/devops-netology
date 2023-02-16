# devops-netology
### performed by Kirill Karagodin
#### HW 15.1 Вычислительные мощности. Балансировщики нагрузки

#### Задача 1 Яндекс.Облако (обязательное к выполнению)

1. Создать bucket Object Storage и разместить там файл с картинкой:
- Создать bucket в Object Storage с произвольным именем (например, имя_студента_дата); 
- Положить в bucket файл с картинкой; 
- Сделать файл доступным из Интернет.
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и web-страничкой, содержащей ссылку на 
картинку из bucket:
- Создать Instance Group с 3 ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать image_id = fd827b91d99psvq5fjit; 
- Для создания стартовой веб-страницы рекомендуется использовать раздел user_data в meta_data; 
- Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket; 
- Настроить проверку состояния ВМ.
3. Подключить группу к сетевому балансировщику:
- Создать сетевой балансировщик; 
- Проверить работоспособность, удалив одну или несколько ВМ.
4. *Создать Application Load Balancer с использованием Instance group и проверкой состояния.

#### Ответ

Для реализации данного проекта через `terraform`, в качестве подготовительных шагов были сощданы 2 сервис-аккаунта в YC
- sa-bucket - аккаунт для работы в Object Storage  ролью `storage.editor`
- sa-ig - аккаунт для работы  Instance Group с ролью `editor`
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/sa.JPG)

1. Создан конфиг [`terraform`](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/src/terraform)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/vm.JPG)
````bash

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

bucket_domain_name = "http://karagodin-netology-bucket.storage.yandexcloud.net/test.jpg"
external_load_balancer_ip = "51.250.41.123"
mojnovse@mojno-vseMacBook terraform %
````
2. Создан bucket Object Storage с [картинкой](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/test.jpg)
- [Конфигурационный файл](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/src/terraform/bucket.tf)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/bucket.JPG)
- Скрин картинки в бакете
- ![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/scrin_b.JPG)

3. Создана группа ВМ
- Конфигурация [`Instance Group`](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/src/terraform/instance-group.tf)
- `Instance Group` в YC
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/ig1.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/ig2.JPG)
- Отображение картинки через IG
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/ig3.JPG)
4. Подключил группу к сетевому балансировщику
- Конфигурация ['load-balancer'](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/src/terraform/lb.tf)
- 'load-balancer' в YC
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/lb.JPG)
- Отображение картинки через 'load-balancer'
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/lb2.JPG)

Для проверки работоспособности удалим 1 ВМ
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_15.2/img/vm-1.JPG)
Проверяем доступность картинки
````bash
mojnovse@mojno-vseMacBook terraform % curl 51.250.41.123
<html><img src="http://karagodin-netology-bucket.storage.yandexcloud.net/test.jpg"/></html>
mojnovse@mojno-vseMacBook terraform %
````
