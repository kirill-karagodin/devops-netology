# devops-netology
### performed by Kirill Karagodin
#### HW8.6 Создание собственных modules.

1. В виртуальном окружении создать новый my_own_module.py файл
2. Наполнить его содержимым
3. Заполните файл в соответствии с требованиями ansible так, чтобы он выполнял основную задачу: module должен создавать 
текстовый файл на удалённом хосте по пути, определённом в параметре path, с содержимым, определённым в параметре 
content.

[my_own_module.py](https://)

5. Проверьте module на исполняемость локально.

Создал файл `test.json`
````bash
(venv) root@vb-micrapc:/opt/src_8.6/ansible# cat test.json
{
    "ANSIBLE_MODULE_ARGS": {
        "path": "/opt/test1.txt",
        "content": "Hello my friend!\n"
    }
}
````
Проверяем
````bash
(venv) root@vb-micrapc:/opt/src_8.6/ansible# python -m ansible.modules.my_own_module test.json

{"changed": true, "original_message": "Hello my friend!", "message": "File was created!", "invocation": {"module_args": {"path": "/opt/test1.txt", "content": "Hello my friend!"}}}
````
Проверяем наличие файла
````bash
(venv) root@vb-micrapc:/opt/src_8.6/ansible# cat /opt/test1.txt
Hello my friend!
(venv) root@vb-micrapc:/opt/src_8.6/ansible#
````
5. Напишите single task playbook и используйте module в нём.
````bash
(venv) root@vb-micrapc:/opt/src_8.6/playbook# cat site.yml
---
- name: Test my module
  hosts: localhost
  gather_facts: false
  tasks:
    - name: Run Module
      my_own_module:
        path: "/opt/test2.txt"
        content: "Hello, my freind!\n"
(venv) root@vb-micrapc:/opt/src_8.6/playbook#
````
6. Проверьте через playbook на идемпотентность.
````bash
(venv) root@vb-micrapc:/opt/src_8.6/playbook# ansible-playbook site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test my module] ***********************************************************************************************************************************************************************************************************************

TASK [Run Module] ***************************************************************************************************************************************************************************************************************************
changed: [localhost]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(venv) root@vb-micrapc:/opt/src_8.6/playbook# cat /opt/te
terraform/       terraform-1.1.6/ test1.txt        test2.txt
(venv) root@vb-micrapc:/opt/src_8.6/playbook# cat /opt/test2.txt
Hello, my freind!
(venv) root@vb-micrapc:/opt/src_8.6/playbook# ansible-playbook site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
become unstable at any point.
[WARNING]: No inventory was parsed, only implicit localhost is available
[WARNING]: provided hosts list is empty, only localhost is available. Note that the implicit localhost does not match 'all'

PLAY [Test my module] ***********************************************************************************************************************************************************************************************************************

TASK [Run Module] ***************************************************************************************************************************************************************************************************************************
ok: [localhost]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

(venv) root@vb-micrapc:/opt/src_8.6/playbook#
````
7. Выйдите из виртуального окружения.
8. Инициализируйте новую collection: `ansible-galaxy collection init my_own_namespace.yandex_cloud_elk`
````bash
root@vb-micrapc:/opt/src_8.6# ansible-galaxy collection init my_own_namespace.yandex_cloud_elk
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
become unstable at any point.
- Collection my_own_namespace.yandex_cloud_elk was created successfully
root@vb-micrapc:/opt/src_8.6# 
````
9. В данную collection перенесите свой module в соответствующую директорию.
````bash
root@vb-micrapc:/opt/src_8.6# cp ansible/lib/ansible/modules/my_own_module.py my_own_namespace/yandex_cloud_elk/plugins/modules
root@vb-micrapc:/opt/src_8.6#
````
10. Single task playbook преобразуйте в single task role и перенесите в collection. У role должны быть default всех 
параметров module
11. Создайте playbook для использования этой role.
````bash
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk/roles# ansible-galaxy role init my_role
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
become unstable at any point.
- Role my_role was created successfully
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk/roles#
````
- **defaults/main.yml**
````bash
---
# defaults file for my_role
test_path: "/tmp/test1.txt"
test_content: "Hello, my freind!\n"

````
- **tasks/main.yml**
````bash
---
# tasks file for my_role
- name: Execute module
  my_own_module:
    path: "{{ test_path }}"
    content: "{{ test_content }}"

````
- **inventory/hosts.yml**
````bash
---
    my_test:
      hosts:
        mytest:
          ansible_host: 51.250.6.111
          ansible_user: centos

````
- **site.yml** 
````bash
---
- name: Test my_own_module in yandex.cloud
  hosts:
    - mytest
  roles:
    - my_role
````
Средствами terraform создана виртуальная машина в Yandex Cloud

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_8.6/img/vm.JPG)

Запуск playbook:
````bash
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk# ansible-playbook -i inventory/prod.yml site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
become unstable at any point.

PLAY [Test my_own_module in yandex.cloud] ***************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [mytest]

TASK [my_role : Execute module] *************************************************************************************************************************************************************************************************************
changed: [mytest]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
mytest                     : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk#
````
Проверка наличия файла на удаленном хосте
````bash
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk# ssh centos@51.250.6.111
[centos@node01 ~]$ cat /tmp/test1.txt
Hello, my freind!
[centos@node01 ~]$
````
Проверка на идемпотентность
````bash
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk# ansible-playbook -i inventory/prod.yml site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
become unstable at any point.

PLAY [Test my_own_module in yandex.cloud] ***************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [mytest]

TASK [my_role : Execute module] *************************************************************************************************************************************************************************************************************
ok: [mytest]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
mytest                     : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk#
````
12. Заполните всю документацию по collection, выложите в свой репозиторий, поставьте тег `1.0.0` на этот коммит.
13. Создайте .tar.gz этой collection: ansible-galaxy collection build в корневой директории collection.
````bash
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk# ansible-galaxy collection build
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
become unstable at any point.
Created collection for my_own_namespace.yandex_cloud_elk at /opt/src_8.6/my_own_namespace/yandex_cloud_elk/my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk# ll
total 33648
drwxr-xr-x 8 root root     4096 сен 13 23:47 ./
drwxr-xr-x 3 root root     4096 сен 13 22:35 ../
drwxr-xr-x 2 root root     4096 сен 13 22:35 docs/
-rw-r--r-- 1 root root     3083 сен 13 22:35 galaxy.yml
drwxr-xr-x 2 root root     4096 сен 13 23:26 inventory/
drwxr-xr-x 2 root root     4096 сен 13 22:35 meta/
-rw-r--r-- 1 root root 34408273 сен 13 23:47 my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
drwxr-xr-x 3 root root     4096 сен 13 22:46 plugins/
-rw-r--r-- 1 root root       92 сен 13 22:35 README.md
drwxr-xr-x 3 root root     4096 сен 13 22:48 roles/
-rw-r--r-- 1 root root       92 сен 13 23:14 site.yml
drwxr-xr-x 3 root root     4096 сен 13 23:11 terraform/
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk# 
````
14. Создайте ещё одну директорию любого наименования, перенесите туда single task playbook и архив c collection.
````bash
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk# cp my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz ../../test_build/
root@vb-micrapc:/opt/src_8.6/my_own_namespace/yandex_cloud_elk# cd ../../test_build/
root@vb-micrapc:/opt/src_8.6/test_build# ll
total 33612
drwxr-xr-x 2 root root     4096 сен 13 23:51 ./
drwxr-xr-x 6 root root     4096 сен 13 23:50 ../
-rw-r--r-- 1 root root 34408273 сен 13 23:51 my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
root@vb-micrapc:/opt/src_8.6/test_build#
````
Внес изменения в site.yml
````bash
root@vb-micrapc:/opt/src_8.6/test_build# cat site.yml
---
- name: Test my module
  hosts: all
  gather_facts: false
  tasks:
    - name: Run Module
      my_own_module:
        path: "/tmp/test2.txt"
        content: "Hello, my freind!\n"
root@vb-micrapc:/opt/src_8.6/test_build#
````
`invetory/prod.yml` перенес из playbook с ролью

15. Установите collection из локального архива: ansible-galaxy collection install <archivename>.tar.gz
````bash
root@vb-micrapc:/opt/src_8.6/test_build# tree
.
├── collection
│   └── ansible_collections
│       └── my_own_namespace
│           └── yandex_cloud_elk
│               ├── docs
│               ├── FILES.json
│               ├── inventory
│               │   └── prod.yml
│               ├── MANIFEST.json
│               ├── meta
│               │   └── runtime.yml
│               ├── plugins
│               │   ├── modules
│               │   │   └── my_own_module.py
│               │   └── README.md
│               ├── README.md
│               ├── roles
│               │   └── my_role
│               │       ├── defaults
│               │       │   └── main.yml
│               │       ├── files
│               │       ├── handlers
│               │       │   └── main.yml
│               │       ├── meta
│               │       │   └── main.yml
│               │       ├── README.md
│               │       ├── tasks
│               │       │   └── main.yml
│               │       ├── templates
│               │       ├── tests
│               │       │   ├── inventory
│               │       │   └── test.yml
│               │       └── vars
│               │           └── main.yml
│               └── site.yml
├── inventory
│   └── prod.yml
├── my_own_namespace-yandex_cloud_elk-1.0.0.tar.gz
└── site.yml
````
16. Запустите playbook, убедитесь, что он работает.
````bash
root@vb-micrapc:/opt/src_8.6/test_build# ansible-playbook -i inventory/prod.yml site.yml
[WARNING]: You are running the development version of Ansible. You should only run Ansible from "devel" if you are modifying the Ansible engine, or trying out features under development. This is a rapidly changing source of code and can
become unstable at any point.

PLAY [Test my module] ***********************************************************************************************************************************************************************************************************************

TASK [Run Module] ***************************************************************************************************************************************************************************************************************************
changed: [mytest]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
mytest                     : ok=1    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

root@vb-micrapc:/opt/src_8.6/test_build#
root@vb-micrapc:/opt/src_8.6/test_build# ssh centos@51.250.6.111
[centos@node01 ~]$ cat /tmp/test2.txt
Hello, my freind!
[centos@node01 ~]$

````
17. В ответ необходимо прислать ссылку на репозиторий с collection

[collection](https://github.com/kirill-karagodin/my_own_collection/tree/1.0.0)



