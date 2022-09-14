# devops-netology
### performed by Kirill Karagodin
#### HW8.5 Тестирование Roles.

### Molecule
1. Запустите molecule test -s centos7 внутри корневой директории clickhouse-role, посмотрите на вывод команды.
````bash
root@vb-micrapc:/opt/src_8.4/playbook/roles/clickhouse-role# molecule test -s centos7
CRITICAL 'molecule/centos7/molecule.yml' glob failed.  Exiting.
root@vb-micrapc:/opt/src_8.4/playbook/roles/clickhouse-role#
````
При выполнении данного пункта возникла ошибка, но при замене `cantos7` на `ubuntu_focal` получаем результат:
````bash
root@vb-micrapc:/opt/src_8.4/playbook/roles/clickhouse-role# molecule test -s ubuntu_focal
INFO     ubuntu_focal scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/0f592f/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/0f592f/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/0f592f/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/hosts.yml linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/hosts
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/group_vars/ linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/group_vars
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/host_vars/ linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/host_vars
INFO     Running ubuntu_focal > dependency
INFO     Running ansible-galaxy collection install -v --force community.docker:>=1.9.1
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/hosts.yml linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/hosts
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/group_vars/ linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/group_vars
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/host_vars/ linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/host_vars
INFO     Running ubuntu_focal > lint
COMMAND: yamllint .
ansible-lint
flake8

/bin/bash: line 1: yamllint: command not found
/bin/bash: line 2: ansible-lint: command not found
/bin/bash: line 3: flake8: command not found
CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/hosts.yml linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/hosts
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/group_vars/ linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/group_vars
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/host_vars/ linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/host_vars
INFO     Running ubuntu_focal > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/hosts.yml linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/hosts
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/group_vars/ linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/group_vars
INFO     Inventory /opt/src_8.4/playbook/roles/clickhouse-role/molecule/ubuntu_focal/../resources/inventory/host_vars/ linked to /root/.cache/molecule/clickhouse-role/ubuntu_focal/inventory/host_vars
INFO     Running ubuntu_focal > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=ubuntu_focal)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=ubuntu_focal)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
root@vb-micrapc:/opt/src_8.4/playbook/roles/clickhouse-role#

````
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при 
помощи `molecule init scenario --driver-name docker.`
````bash
root@vb-micrapc:/opt/src_8.4/playbook/roles/vector-role# molecule init scenario
INFO     Initializing new scenario default...
INFO     Initialized scenario in /opt/src_8.4/playbook/roles/vector-role/molecule/default successfully.
root@vb-micrapc:/opt/src_8.4/playbook/roles/vector-role#
````
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте 
найденные ошибки, если они есть.
4. Добавьте несколько assert'ов в verify.yml файл для проверки работоспособности vector-role (проверка, что конфиг 
валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

**default (centos7)**
<details><summary></summary>

````bash
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role# molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] ******************************************************************************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *********************************************************************************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] ********************************************************************************************************************************************************************************************
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ************************************************************************************************************************************************************************************************************

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /opt/src_8.5/playbook/roles/vector-role/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] *******************************************************************************************************************************************************************************************************************************

TASK [Log into a Docker registry] ***********************************************************************************************************************************************************************************************************
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] *************************************************************************************************************************************************************************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] **************************************************************************************************************************************************************************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Discover local Docker images] *********************************************************************************************************************************************************************************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] **********************************************************************************************************************************************************************************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7)

TASK [Create docker network(s)] *************************************************************************************************************************************************************************************************************

TASK [Determine the CMD directives] *********************************************************************************************************************************************************************************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] **********************************************************************************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] ********************************************************************************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '425142924818.12419', 'results_file': '/root/.ansible_async/425142924818.12419', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/centos:7', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Include vector-role] ******************************************************************************************************************************************************************************************************************

TASK [vector-role : Get Vector distrib (yum)] ***********************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Get Vector distrib (dnf)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (deb)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (yum)] ******************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Install Vector packages (dnf)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (deb)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Creates directory] ******************************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
changed: [instance]

TASK [vector-role : Deploy config Vector] ***************************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Create systemd unit Vector] *********************************************************************************************************************************************************************************************
changed: [instance]

RUNNING HANDLER [vector-role : Start Vector service] ****************************************************************************************************************************************************************************************
fatal: [instance]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: "}

NO MORE HOSTS LEFT **************************************************************************************************************************************************************************************************************************

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=6    changed=5    unreachable=0    failed=1    skipped=4    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/root/.cache/molecule/vector-role/default/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/src_8.5/playbook/roles/vector-role/molecule/default/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] ******************************************************************************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *********************************************************************************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] ********************************************************************************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ************************************************************************************************************************************************************************************************************

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role#
````
Тестирование на CentOS7 падает в ошибку на шаге `RUNNING HANDLER [vector-role : Start Vector service]`
````bash
RUNNING HANDLER [vector-role : Start Vector service] ****************************************************************************************************************************************************************************************
fatal: [instance]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: "}
````
</details>

при этом если проводить тест на Ubuntu, все выполняется успешно
Содержиние файла `handlers/main.yml`
````bash
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role# cat handlers/main.yml
---
# handlers file for vector-role
- name: Start Vector service
  become: true
  ansible.builtin.service:
     name: vector
     state: restarted
  when: ansible_facts.virtualization_type != "docker"
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role#
````

**ubuntu**
<details><summary></summary>

````bash
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role# molecule test -s ubuntu_latest
INFO     ubuntu_latest scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running ubuntu_latest > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running ubuntu_latest > lint
INFO     Lint is disabled.
INFO     Running ubuntu_latest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_latest > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] ******************************************************************************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *********************************************************************************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] ********************************************************************************************************************************************************************************************
ok: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ************************************************************************************************************************************************************************************************************

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running ubuntu_latest > syntax

playbook: /opt/src_8.5/playbook/roles/vector-role/molecule/ubuntu_latest/converge.yml
INFO     Running ubuntu_latest > create

PLAY [Create] *******************************************************************************************************************************************************************************************************************************

TASK [Log into a Docker registry] ***********************************************************************************************************************************************************************************************************
skipping: [localhost] => (item=None)
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] *************************************************************************************************************************************************************************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] **************************************************************************************************************************************************************************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Discover local Docker images] *********************************************************************************************************************************************************************************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] **********************************************************************************************************************************************************************************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)

TASK [Create docker network(s)] *************************************************************************************************************************************************************************************************************

TASK [Determine the CMD directives] *********************************************************************************************************************************************************************************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] **********************************************************************************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] ********************************************************************************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '25550468672.44774', 'results_file': '/root/.ansible_async/25550468672.44774', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running ubuntu_latest > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running ubuntu_latest > converge

PLAY [Converge] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Include vector-role] ******************************************************************************************************************************************************************************************************************

TASK [vector-role : Get Vector distrib (yum)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (dnf)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (deb)] ***********************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Install Vector packages (yum)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (dnf)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (deb)] ******************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Creates directory] ******************************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to '0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
changed: [instance]

RUNNING HANDLER [vector-role : Start Vector service] ****************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Deploy config Vector] ***************************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Create systemd unit Vector] *********************************************************************************************************************************************************************************************
changed: [instance]

RUNNING HANDLER [vector-role : Start Vector service] ****************************************************************************************************************************************************************************************
skipping: [instance]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=6    changed=5    unreachable=0    failed=0    skipped=6    rescued=0    ignored=0

INFO     Running ubuntu_latest > idempotence

PLAY [Converge] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Include vector-role] ******************************************************************************************************************************************************************************************************************

TASK [vector-role : Get Vector distrib (yum)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (dnf)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (deb)] ***********************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Install Vector packages (yum)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (dnf)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (deb)] ******************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Creates directory] ******************************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to '0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [instance]

TASK [vector-role : Deploy config Vector] ***************************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Create systemd unit Vector] *********************************************************************************************************************************************************************************************
ok: [instance]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=6    changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running ubuntu_latest > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running ubuntu_latest > verify
INFO     Running Ansible Verifier

PLAY [Verify] *******************************************************************************************************************************************************************************************************************************

TASK [Get Vector version] *******************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Assert Vector instalation] ************************************************************************************************************************************************************************************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validation Vector configuration] ******************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Assert Vector validate config] ********************************************************************************************************************************************************************************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu_latest > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running ubuntu_latest > destroy

PLAY [Destroy] ******************************************************************************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *********************************************************************************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] ********************************************************************************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ************************************************************************************************************************************************************************************************************

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role#

````
</details>

5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

[Molecule](https://github.com/kirill-karagodin/vector-role/tree/1.5.0)

### Tox


1. Добавьте в директорию с vector-role файлы из директории
2. Запустите docker:

`docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`

где `path_to_repo` - путь до корня репозитория с `vector-role` на вашей файловой системе.
````bash
root@vb-micrapc:/opt/src_8.4/playbook/roles/vector-role# docker run --privileged=True -v /opt/src_8.4/playbook/roles/vector-role/:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@5f36a78db424 vector-role]#
````
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.

<details><summary></summary>

````bash
[root@5f36a78db424 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.0,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==38.0.1,distro==1.7.0,enrich==1.2.7,idna==3.3,importlib-metadata==4.12.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.10.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.13.0,PyNaCl==1.5.0,pyparsing==3.0.9,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.5.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,typing_extensions==4.3.0,urllib3==1.26.12,wcmatch==8.4,yamllint==1.26.3,zipp==3.8.1
py37-ansible210 run-test-pre: PYTHONHASHSEED='2815064786'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.0,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==38.0.1,distro==1.7.0,enrich==1.2.7,idna==3.3,importlib-metadata==4.12.0,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.10.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.13.0,PyNaCl==1.5.0,pyparsing==3.0.9,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.5.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,typing_extensions==4.3.0,urllib3==1.26.12,wcmatch==8.4,yamllint==1.26.3,zipp==3.8.1
py37-ansible30 run-test-pre: PYTHONHASHSEED='2815064786'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==2.2.0,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.1.0,bcrypt==4.0.0,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==38.0.1,distro==1.7.0,enrich==1.2.7,idna==3.3,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.15.0,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.10.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.13.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.5.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,urllib3==1.26.12,wcmatch==8.4,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='2815064786'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==2.2.0,ansible-lint==5.1.3,arrow==1.2.3,attrs==22.1.0,bcrypt==4.0.0,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==38.0.1,distro==1.7.0,enrich==1.2.7,idna==3.3,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.15.0,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.4.0,molecule-podman==1.0.1,packaging==21.3,paramiko==2.11.0,pathspec==0.10.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.13.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.5.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,urllib3==1.26.12,wcmatch==8.4,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='2815064786'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
__________________________________________________________________________________________________________________ summary __________________________________________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
[root@5f36a78db424 vector-role]#
````
</details>

4. Создайте облегчённый сценарий для molecule с драйвером `molecule_podman`. 
````bash
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role# molecule init scenario ubuntu_lite --driver-name podman
INFO     Initializing new scenario ubuntu_lite...
INFO     Initialized scenario in /opt/src_8.5/playbook/roles/vector-role/molecule/ubuntu_lite successfully.
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role#
````
Проверьте его на исполнимость.
<details><summary></summary>

````bash
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role# molecule init scenario ubuntu_lite --driver-name podman
INFO     Initializing new scenario ubuntu_lite...
INFO     Initialized scenario in /opt/src_8.5/playbook/roles/vector-role/molecule/ubuntu_lite successfully.
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role# molecule test -s ubuntu_lite
INFO     ubuntu_lite scenario test matrix: destroy, create, converge, idempotence, verify, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running ubuntu_lite > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] ******************************************************************************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *********************************************************************************************************************************************************************************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] ********************************************************************************************************************************************************************************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '274702160943.29403', 'results_file': '/root/.ansible_async/274702160943.29403', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running ubuntu_lite > create

PLAY [Create] *******************************************************************************************************************************************************************************************************************************

TASK [get podman executable path] ***********************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [save path to executable as fact] ******************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Log into a container registry] ********************************************************************************************************************************************************************************************************
skipping: [localhost] => (item="instance registry username: None specified")

TASK [Check presence of custom Dockerfiles] *************************************************************************************************************************************************************************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] **************************************************************************************************************************************************************************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/ubuntu:latest")

TASK [Discover local Podman images] *********************************************************************************************************************************************************************************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ****************************************************************************************************************************************************************************************************
skipping: [localhost] => (item=docker.io/pycontribs/ubuntu:latest)

TASK [Determine the CMD directives] *********************************************************************************************************************************************************************************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] **********************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Discover local podman networks] *******************************************************************************************************************************************************************************************************
skipping: [localhost] => (item=instance: None specified)

TASK [Create podman network dedicated to this scenario] *************************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Create molecule instance(s)] **********************************************************************************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] ********************************************************************************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (295 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (294 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (293 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (292 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running ubuntu_lite > converge

PLAY [Converge] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Copy something to test use of synchronize module] *************************************************************************************************************************************************************************************
changed: [instance]

TASK [Include vector-role] ******************************************************************************************************************************************************************************************************************

TASK [vector-role : Get Vector distrib (yum)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (dnf)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (deb)] ***********************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Install Vector packages (yum)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (dnf)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (deb)] ******************************************************************************************************************************************************************************************
[WARNING]: Updating cache and auto-installing missing dependency: python-apt
changed: [instance]

TASK [vector-role : Creates directory] ******************************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
changed: [instance]

TASK [vector-role : Deploy config Vector] ***************************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Create systemd unit Vector] *********************************************************************************************************************************************************************************************
changed: [instance]

RUNNING HANDLER [vector-role : Start Vector service] ****************************************************************************************************************************************************************************************
skipping: [instance]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=7    changed=6    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running ubuntu_lite > idempotence

PLAY [Converge] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Copy something to test use of synchronize module] *************************************************************************************************************************************************************************************
ok: [instance]

TASK [Include vector-role] ******************************************************************************************************************************************************************************************************************

TASK [vector-role : Get Vector distrib (yum)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (dnf)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (deb)] ***********************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Install Vector packages (yum)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (dnf)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (deb)] ******************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Creates directory] ******************************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [instance]

TASK [vector-role : Deploy config Vector] ***************************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Create systemd unit Vector] *********************************************************************************************************************************************************************************************
ok: [instance]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=7    changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running ubuntu_lite > verify
INFO     Running Ansible Verifier

PLAY [Verify] *******************************************************************************************************************************************************************************************************************************

TASK [Get Vector version] *******************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Assert Vector instalation] ************************************************************************************************************************************************************************************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validation Vector configuration] ******************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Assert Vector validate config] ********************************************************************************************************************************************************************************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu_lite > destroy

PLAY [Destroy] ******************************************************************************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *********************************************************************************************************************************************************************************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] ********************************************************************************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '515628939178.38509', 'results_file': '/root/.ansible_async/515628939178.38509', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role#
````
</details>

5. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
````bash
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role# cat tox.ini
[tox]
minversion = 3.21.4
basepython = python3.10
envlist = py{310}-ansible{210}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<2.10
commands =
    {posargs:molecule test -s ubuntu_lite --destroy always}
````
6. Запустите команду tox. Убедитесь, что всё отработало успешно.

Выполнено локально, не в предоставленном контейнере, так как работа внутри контейнера сопровождается различными ошибка,
что останавливает работу `tox`

<details><summary></summary>

````bash
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role# tox
py310-ansible210 installed: ansible==2.9.27,ansible-compat==2.2.0,ansible-lint==5.4.0,arrow==1.2.3,attrs==22.1.0,bcrypt==4.0.0,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2022.6.15.2,cffi==1.15.1,chardet==5.0.0,charset-normalizer==2.1.1,click==8.1.3,click-help-colors==0.9.1,commonmark==0.9.1,cookiecutter==2.1.1,cryptography==38.0.1,distro==1.7.0,enrich==1.2.7,idna==3.4,Jinja2==3.1.2,jinja2-time==0.2.0,jmespath==1.0.1,jsonschema==4.16.0,lxml==4.9.1,MarkupSafe==2.1.1,molecule==3.5.2,molecule-podman==2.0.0,packaging==21.3,paramiko==2.11.0,pathspec==0.10.1,pluggy==1.0.0,pycparser==2.21,Pygments==2.13.0,PyNaCl==1.5.0,pyparsing==3.0.9,pyrsistent==0.18.1,python-dateutil==2.8.2,python-slugify==6.1.2,PyYAML==5.4.1,requests==2.28.1,rich==12.5.1,ruamel.yaml==0.17.21,ruamel.yaml.clib==0.2.6,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.0.1,text-unidecode==1.3,urllib3==1.26.12,wcmatch==8.4,yamllint==1.26.3
py310-ansible210 run-test-pre: PYTHONHASHSEED='181546142'
py310-ansible210 run-test: commands[0] | molecule test -s ubuntu_lite --destroy always
INFO     ubuntu_lite scenario test matrix: destroy, create, converge, idempotence, verify, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATHS=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running ubuntu_lite > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] ******************************************************************************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *********************************************************************************************************************************************************************************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] ********************************************************************************************************************************************************************************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '544219401124.33149', 'results_file': '/root/.ansible_async/544219401124.33149', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running ubuntu_lite > create

PLAY [Create] *******************************************************************************************************************************************************************************************************************************

TASK [get podman executable path] ***********************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [save path to executable as fact] ******************************************************************************************************************************************************************************************************
ok: [localhost]

TASK [Log into a container registry] ********************************************************************************************************************************************************************************************************
skipping: [localhost] => (item="instance registry username: None specified")

TASK [Check presence of custom Dockerfiles] *************************************************************************************************************************************************************************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] **************************************************************************************************************************************************************************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/ubuntu:latest")

TASK [Discover local Podman images] *********************************************************************************************************************************************************************************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ****************************************************************************************************************************************************************************************************
skipping: [localhost] => (item=docker.io/pycontribs/ubuntu:latest)

TASK [Determine the CMD directives] *********************************************************************************************************************************************************************************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] **********************************************************************************************************************************************************************************************
changed: [localhost]

TASK [Discover local podman networks] *******************************************************************************************************************************************************************************************************
skipping: [localhost] => (item=instance: None specified)

TASK [Create podman network dedicated to this scenario] *************************************************************************************************************************************************************************************
skipping: [localhost]

TASK [Create molecule instance(s)] **********************************************************************************************************************************************************************************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] ********************************************************************************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running ubuntu_lite > converge

PLAY [Converge] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Copy something to test use of synchronize module] *************************************************************************************************************************************************************************************
changed: [instance]

TASK [Include vector-role] ******************************************************************************************************************************************************************************************************************

TASK [vector-role : Get Vector distrib (yum)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (dnf)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (deb)] ***********************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Install Vector packages (yum)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (dnf)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (deb)] ******************************************************************************************************************************************************************************************
[WARNING]: Updating cache and auto-installing missing dependency: python-apt
changed: [instance]

TASK [vector-role : Creates directory] ******************************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
changed: [instance]

RUNNING HANDLER [vector-role : Start Vector service] ****************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Deploy config Vector] ***************************************************************************************************************************************************************************************************
changed: [instance]

TASK [vector-role : Create systemd unit Vector] *********************************************************************************************************************************************************************************************
changed: [instance]

RUNNING HANDLER [vector-role : Start Vector service] ****************************************************************************************************************************************************************************************
skipping: [instance]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=7    changed=6    unreachable=0    failed=0    skipped=6    rescued=0    ignored=0

INFO     Running ubuntu_lite > idempotence

PLAY [Converge] *****************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Copy something to test use of synchronize module] *************************************************************************************************************************************************************************************
ok: [instance]

TASK [Include vector-role] ******************************************************************************************************************************************************************************************************************

TASK [vector-role : Get Vector distrib (yum)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (dnf)] ***********************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Get Vector distrib (deb)] ***********************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Install Vector packages (yum)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (dnf)] ******************************************************************************************************************************************************************************************
skipping: [instance]

TASK [vector-role : Install Vector packages (deb)] ******************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Creates directory] ******************************************************************************************************************************************************************************************************
[WARNING]: The value 0 (type int) in a string field was converted to u'0' (type string). If this does not look like what you expect, quote the entire value to ensure it does not change.
ok: [instance]

TASK [vector-role : Deploy config Vector] ***************************************************************************************************************************************************************************************************
ok: [instance]

TASK [vector-role : Create systemd unit Vector] *********************************************************************************************************************************************************************************************
ok: [instance]

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=7    changed=0    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running ubuntu_lite > verify
INFO     Running Ansible Verifier

PLAY [Verify] *******************************************************************************************************************************************************************************************************************************

TASK [Get Vector version] *******************************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Assert Vector instalation] ************************************************************************************************************************************************************************************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

TASK [Validation Vector configuration] ******************************************************************************************************************************************************************************************************
ok: [instance]

TASK [Assert Vector validate config] ********************************************************************************************************************************************************************************************************
ok: [instance] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
instance                   : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running ubuntu_lite > destroy

PLAY [Destroy] ******************************************************************************************************************************************************************************************************************************

TASK [Destroy molecule instance(s)] *********************************************************************************************************************************************************************************************************
changed: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] ********************************************************************************************************************************************************************************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (298 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '903236062176.42038', 'results_file': '/root/.ansible_async/903236062176.42038', 'changed': True, 'failed': False, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
__________________________________________________________________________________________________________________ summary __________________________________________________________________________________________________________________
  py310-ansible210: commands succeeded
  congratulations :)
root@vb-micrapc:/opt/src_8.5/playbook/roles/vector-role#

````
</details>

7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

[Tox](https://github.com/kirill-karagodin/vector-role/tree/1.5.3)