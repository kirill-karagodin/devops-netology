# devops-netology
### performed by Kirill Karagodin
#### HW 9.4 Jenkins.

### Подготовка:

1. Создать 2 VM: для jenkins-master и jenkins-agent.

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/vms.JPG)

2. Установить jenkins при помощи playbook'a.
3. Запустить и проверить работоспособность. 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/master01.JPG)

4. Сделать первоначальную настройку.

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/master02.JPG)

### Основная часть

1. Сделать Freestyle Job, который будет запускать molecule test из любого вашего репозитория с ролью. 
- В джоб в 'Build Steps' прописана установка 'molecule'(обязательно версии '3.4.0', иными версиями падает в ошибку), и
устновка 'molecule-docker'
- Для Source Code Management дополнительно было настроено 'Additional Behaviours' --> 'Check out to a sub-directory' -->
'Local subdirectory for repo' --> 'vector-role' для того, что бы работала molecule, в противном случае ошибка что 
'molecule' не нашла роль.
- Так же в 'Build Steps' перед выполнением 'molecule test' принудительный переход в каталог с ролью, так же без этого
шага появляется ошибка о ненахождении 'molecule' роли.

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/free.JPG)

2. Сделать Declarative Pipeline Job, который будет запускать molecule test из любого вашего репозитория с ролью.

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/declarative.JPG)

3. Перенести Declarative Pipeline в репозиторий в файл Jenkinsfile.

[Jenkinsfile](https://github.com/kirill-karagodin/vector-role/blob/main/Jenkinsfile)

4. Создать Multibranch Pipeline на запуск Jenkinsfile из репозитория. 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/multi1.JPG)

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/multi2.JPG)

5. Создать Scripted Pipeline, наполнить его скриптом из pipeline. 
6. Внести необходимые изменения, чтобы Pipeline запускал ansible-playbook без флагов --check --diff, если не установлен
параметр при запуске джобы (prod_run = True), по умолчанию параметр имеет значение False и запускает прогон 
с флагами --check --diff. 
7. Проверить работоспособность, исправить ошибки, исправленный Pipeline вложить в репозиторий в файл ScriptedJenkinsfile.

- Исправлено имя агента 
- Исправлен URL репозитория
- Исправлен ключ подключения

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/run.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/true.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.4/img/false.JPG)

При прогоне Pipeline с включенной/выключенной галочкой 'prod_run' проявляется одна и та же ошибка
````bash
TASK [java : Ensure installation dir exists] ***********************************
fatal: [localhost]: FAILED! => {"changed": false, "module_stderr": "sudo: a password is required\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 1}
````
Хотя при запуске локально на агенте все отрабатывает

**ansible-playbook site.yml -i inventory/prod.yml --check --diff**
````bash
[centos@jenkins-agent Scripted]$ ansible-playbook site.yml -i inventory/prod.yml --check --diff
/usr/local/lib/python3.6/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release.
  from cryptography.exceptions import InvalidSignature

PLAY [Install Java] ********************************************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] ***************************************
skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] ***************************************
ok: [localhost]

TASK [java : Ensure installation dir exists] *******************************************************************
ok: [localhost]

TASK [java : Extract java in the installation directory] *******************************************************
skipping: [localhost]

TASK [java : Export environment variables] *********************************************************************
ok: [localhost]

PLAY RECAP *****************************************************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

[centos@jenkins-agent Scripted]$ 
````

**ansible-playbook site.yml -i inventory/prod.yml**
````bash
[centos@jenkins-agent Scripted]$ ansible-playbook site.yml -i inventory/prod.yml
/usr/local/lib/python3.6/site-packages/ansible/parsing/vault/__init__.py:44: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography and will be removed in a future release.
  from cryptography.exceptions import InvalidSignature

PLAY [Install Java] ********************************************************************************************

TASK [Gathering Facts] *****************************************************************************************
ok: [localhost]

TASK [java : Upload .tar.gz file containing binaries from local storage] ***************************************
skipping: [localhost]

TASK [java : Upload .tar.gz file conaining binaries from remote storage] ***************************************
ok: [localhost]

TASK [java : Ensure installation dir exists] *******************************************************************
ok: [localhost]

TASK [java : Extract java in the installation directory] *******************************************************
skipping: [localhost]

TASK [java : Export environment variables] *********************************************************************
ok: [localhost]

PLAY RECAP *****************************************************************************************************
localhost                  : ok=4    changed=0    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

[centos@jenkins-agent Scripted]$

````
8. Отправить ссылку на репозиторий с ролью и Declarative Pipeline и Scripted Pipeline.

[ScriptedJenkinsfile](https://github.com/kirill-karagodin/vector-role/blob/main/ScriptedJenkinsfile)

[Ретозиторий](https://github.com/kirill-karagodin/vector-role)

