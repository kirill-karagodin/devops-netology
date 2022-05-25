# devops-netology
### performed by Kirill Karagodin
#### HW5.5. Оркестрация кластером Docker контейнеров на примере Docker Swarm.

1. Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
````
В global режиме сервисы запускаются на каждой ноде разом и количество реплик ограничено количеством нод в кластере 
docker swarm.
В replication режиме сервисы реплицируются в том количестве которое указано в команде:
"docker service update --replicas="
````
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
````
Алгоритм Raft
В кластере должен быть минимум 1 менеджер и более, который/которые могут стать кандидатами в лидеры. Если резервный 
менеджер долго не получает сообщений от лидера, то он переходит в состояние «кандидат» и посылает другим менеджерам 
запрос на голосование. Другие менеджеры голосуют за того кандидата, от которого они получили первый запрос. 
Если кандидат получает сообщение от лидера, то он снимает свою кандидатуру и возвращается в обычное состояние. 
Если кандидат получает большинство голосов, то он становится лидером. Если же он не получил большинства 
(это случай, когда на кластере возникли сразу несколько кандидатов и голоса разделились), то кандидат ждёт случайное 
время и инициирует новую процедуру голосования. Процедура голосования повторяется, пока не будет выбран лидер.
````
- Что такое Overlay Network?
````
Overlay-сеть создает подсеть, которую могут использовать контейнеры в разных хостах swarm-кластера. Контейнеры на разных
физических хостах могут обмениваться данными по overlay-сети (если все они прикреплены к одной сети). Overlay-сеть 
использует технологию vxlan, которая инкапсулирует layer 2 фреймы в layer 4 пакеты (UDP/IP).
````
2. Создать ваш первый Docker Swarm кластер в Яндекс.Облаке
````bash
root@vb-micrapc:/opt/src_5.5/terraform# terraform validate
Success! The configuration is valid.

root@vb-micrapc:/opt/src_5.5/terraform# terraform plan
root@vb-micrapc:/opt/src_5.5/terraform# terraform apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
............
Outputs:

external_ip_address_node01 = "51.250.85.41"
external_ip_address_node02 = "51.250.93.110"
external_ip_address_node03 = "51.250.64.231"
external_ip_address_node04 = "51.250.92.206"
external_ip_address_node05 = "51.250.93.155"
external_ip_address_node06 = "51.250.68.73"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"
root@vb-micrapc:/opt/src_5.5/terraform# ssh centos@51.250.85.41
[centos@node01 ~]$ sudo su
[root@node01 centos]# docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
w7zkscx74y6sd2ing9pzb4i16 *   node01.netology.yc   Ready     Active         Leader           20.10.16
u9c2gqd2ij7h210oigqo7r2vv     node02.netology.yc   Ready     Active         Reachable        20.10.16
vazcyczniab5hjgwhy1g2zuto     node03.netology.yc   Ready     Active         Reachable        20.10.16
vlke60lluoyc943h2v1iuz0t6     node04.netology.yc   Ready     Active                          20.10.16
j6kcqnvi0j1anrinmd6h4la8i     node05.netology.yc   Ready     Active                          20.10.16
bhqbktydk7w08h7h3zttahpx1     node06.netology.yc   Ready     Active                          20.10.16
[root@node01 centos]# 
````
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.5/docker.JPG)

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.5/vm.JPG)

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.5/disks.JPG)

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.5/grafana.JPG)

4. Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_5.5/docker_service_ls.JPG)