# devops-netology
### performed by Kirill Karagodin
#### HW8.4 Работа с Roles.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его
````bash
root@vb-micrapc:/opt/src_8.4/playbook# cat requirements.yml
---
  - name: clickhouse
    src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.11.0"
root@vb-micrapc:/opt/src_8.4/playbook#
````
2. При помощи ansible-galaxy скачать себе эту роль.
````bash
root@vb-micrapc:/opt/src_8.4/playbook# ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting clickhouse to /opt/src_8.4/playbook/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
root@vb-micrapc:/opt/src_8.4/playbook# ll
total 44
drwxr-xr-x 7 root root 4096 сен  1 16:39 ./
drwxr-xr-x 3 root root 4096 сен  1 16:15 ../
drwxr-xr-x 6 root root 4096 авг 29 09:52 group_vars/
-rwxr-xr-x 1 root root    7 авг 23 10:55 index.gitignore*
drwxr-xr-x 2 root root 4096 авг 29 20:31 inventory/
-rw-r--r-- 1 root root  121 сен  1 16:36 requirements.yml
drwxr-xr-x 3 root root 4096 сен  1 16:39 roles/
-rwxr-xr-x 1 root root 5559 авг 29 19:29 site.yml*
drwxr-xr-x 2 root root 4096 авг 29 19:30 templates/
drwxr-xr-x 3 root root 4096 авг 29 20:31 terraform/
root@vb-micrapc:/opt/src_8.4/playbook# ll roles/
total 12
drwxr-xr-x  3 root root 4096 сен  1 16:39 ./
drwxr-xr-x  7 root root 4096 сен  1 16:39 ../
drwxr-xr-x 10 root root 4096 сен  1 16:39 clickhouse/
root@vb-micrapc:/opt/src_8.4/playbook#

````
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`
````bash
root@vb-micrapc:/opt/src_8.4/playbook/roles# ansible-galaxy role init vector-role
- Role vector-role was created successfully
root@vb-micrapc:/opt/src_8.4/playbook/roles# ll
total 16
drwxr-xr-x  4 root root 4096 сен  1 16:42 ./
drwxr-xr-x  7 root root 4096 сен  1 16:39 ../
drwxr-xr-x 10 root root 4096 сен  1 16:39 clickhouse/
drwxr-xr-x  8 root root 4096 сен  1 16:42 vector-role/
root@vb-micrapc:/opt/src_8.4/playbook/roles#

````
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между vars и default.
5. Перенести нужные шаблоны конфигов в templates
6. Описать в README.md обе роли и их параметры

[README.md](https://github.com/kirill-karagodin/vector-role/blob/main/README.md)

7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.
 - Создать новый каталог с ролью при помощи `ansible-galaxy role init lighthouse-role`
 - На основе tasks из старого playbook заполните новую role. Разнесите переменные между vars и default.
 - Перенести нужные шаблоны конфигов в templates
 - Описать в README.md обе роли и их параметры
   
[README.md](https://github.com/kirill-karagodin/lighthouse-role/blob/main/README.md)

8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в 
requirements.yml в playbook.
````bash
root@vb-micrapc:/opt/src_8.4/playbook# cat requirements.yml
---
  - name: clickhouse-role
    src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
    scm: git
    version: "1.13"
  - name: vector-role
    src: git@github.com:kirill-karagodin/vector-role.git
    scm: git
    version: "1.3.3"
  - name: nginx-role
    src: git@github.com:kirill-karagodin/nginx-role.git
    scm: git
    version: "1.0.2"
  - name: lighthouse-role
    src: git@github.com:kirill-karagodin/lighthouse-role.git
    scm: git
    version: "1.0.2"
root@vb-micrapc:/opt/src_8.4/playbook#

````
9. Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения 
roles с tasks.
````bash
root@vb-micrapc:/opt/src_8.4/playbook# cat site.yml
---
# Установка Clickhouse
- name: Install Clickhouse
  hosts: clickhouse
  roles:
    - clickhouse-role

# Установка Vector
- name: Install Vector
  hosts: vector
  roles:
    - vector-role

# Установка Nginx для Lighthouse
- name: Install Nginx
  hosts: lighthouse
  roles:
    - nginx-role

# Установка Lighthouse
- name: Install Lighthouse
  hosts: lighthouse
  roles:
    - lighthouse-role
# Вывод URL
  post_tasks:
    - name: Show connect URL lighthouse
      debug:
        msg: "http://{{ ansible_host }}/#http://{{ hostvars['clickhouse-01'].ansible_host }}:8123/?user={{ clickhouse_user }}"
root@vb-micrapc:/opt/src_8.4/playbook#
````
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

[vector-role](https://github.com/kirill-karagodin/vector-role)

[lighthouse-role](https://github.com/kirill-karagodin/lighthouse-role)

Дополнительно Nginx был вынесен в отдельную роль

[nginx-role](https://github.com/kirill-karagodin/nginx-role)

[playbook](https://github.com/kirill-karagodin/08-ansible-02-playbook/tree/08-ansible-04-role)

Запуск готового playbook
````bash
PLAY RECAP **********************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=24   changed=8    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0
lighthouse-01              : ok=11   changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=8    changed=7    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

````
Проверка идемпотентность
````bash
PLAY RECAP **********************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=23   changed=0    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0
lighthouse-01              : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
vector-01                  : ok=6    changed=0    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0

````