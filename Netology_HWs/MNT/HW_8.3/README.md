# devops-netology
### performed by Kirill Karagodin
#### HW8.3 Работа с Yandex Cloud.
Подготовка к выполнению

Подготовьте в Yandex Cloud три хоста: для clickhouse, для vector и для lighthouse.

Созданные виртуальные машины

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_8.3/img/VMs.JPG)

Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает lighthouse.
2. При создании tasks рекомендую использовать модули: get_url, template, yum, apt.
3. Tasks должны: скачать статику lighthouse, установить nginx или любой другой webserver, настроить его конфиг для 
открытия lighthouse, запустить webserver.

[site.yml](https://github.com/kirill-karagodin/08-ansible-02-playbook/blob/main/site.yml)

4. Приготовьте свой собственный inventory файл prod.yml.
````bash
root@vb-micrapc:/opt/src_8.3/playbook# cat inventory/prod.yml
---
    clickhouse:
      hosts:
        clickhouse-01:
          ansible_host: 51.250.66.212
          ansible_user: centos
    vector:
      hosts:
        vector-01:
          ansible_host: 51.250.7.101
          ansible_user: centos
    lighthouse:
      hosts:
        lighthouse-01:
          ansible_host: 51.250.94.50
          ansible_user: centos
root@vb-micrapc:/opt/src_8.3/playbook#

````
5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
````bash
root@vb-micrapc:/opt/src_8.3/playbook# ansible-lint site.yml
WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
root@vb-micrapc:/opt/src_8.3/playbook#

````
6. Попробуйте запустить playbook на этом окружении с флагом --check.
````bash
root@vb-micrapc:/opt/src_8.3/playbook# ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
The authenticity of host '84.252.129.24 (84.252.129.24)' can't be established.
ED25519 key fingerprint is SHA256:Ri61nU/KwJPombz4L9Iv5XRZR2Tfy45TLoWPNGhAtE8.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0

root@vb-micrapc:/opt/src_8.3/playbook#
````
7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.
````bash

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
lighthouse-01              : ok=10   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

````
Страница lighthouse

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_8.3/img/ligthhouse.JPG)
9. Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть 
параметры и теги.

[README.md](https://github.com/kirill-karagodin/08-ansible-02-playbook/blob/main/README.md)

10. Готовый playbook выложите в свой репозиторий, поставьте тег 08-ansible-03-yandex на фиксирующий коммит, в ответ 
предоставьте ссылку на него.

[Репозиторий](https://github.com/kirill-karagodin/08-ansible-02-playbook/tree/08-ansible-03-yandex)
