# devops-netology
### performed by Kirill Karagodin
#### HW3.7 Компьютерные сети (лекция 2)

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
````
в linux: ip -c a
для windows: ipconfig

root@VB-micraPC:/# ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:c8:ff:9a brd ff:ff:ff:ff:ff:ff
    inet 10.0.62.248/24 brd 10.0.62.255 scope global dynamic noprefixroute enp0s3
       valid_lft 310sec preferred_lft 310sec
    inet6 fe80::c06a:a5f1:660:d341/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
root@VB-micraPC:/# 
````
2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux 
для этого?
````
На сегодня, есть три самых распространеенных вида протокола для распознавания соседа по сетевому интерфейсу:

LLDP – протокол канального уровня для обмена информацией между соседними устройствами, позволяет определить к какому 
порту коммутатора подключен сервер.

NDP (англ. Neighbor Discovery Protocol, ) - Протокол обнаружения соседей Любой компьютер, на котором установлен сетевой 
стек IPv6, должен выполнять NDP. Этот протокол обнаружения используется не только для обнаружения соседних устройств, 
но и сетей, в которых они находятся, выбора пути, адресов DNS-серверов, шлюзов и предотвращения дублирования IP-адресов. 
Это довольно надежный протокол, который объединяет ARP и ICMP запросы IPv4.

CDP (Cisco Discovery Protocol) - является собственным протоколом компании Cisco Systems, позволяющий обнаруживать 
подключённое (напрямую или через устройства первого уровня) сетевое оборудование Cisco, его название, версию IOS и 
IP-адреса
````
3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды 
есть в Linux для этого? Приведите пример конфига.
````
Технология, которая используется для разделения L2 коммутатора на несколько виртуальных сетей это VLAN. Пакет - vlan. 
Команды - apt install vlan
Был создан интерфейс enp0s3, на который прописали vlan 200 c ip 10.0.63.2/24

root@VB-micraPC:/# ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:c8:ff:9a brd ff:ff:ff:ff:ff:ff
    inet 10.0.62.248/24 brd 10.0.62.255 scope global dynamic noprefixroute enp0s3
       valid_lft 314sec preferred_lft 314sec
    inet6 fe80::c06a:a5f1:660:d341/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
root@VB-micraPC:/# vconfig add enp0s3 200
Warning: vconfig is deprecated and might be removed in the future, please migrate to ip(route2) as soon as possible!
root@VB-micraPC:/# ip -c a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:c8:ff:9a brd ff:ff:ff:ff:ff:ff
    inet 10.0.62.248/24 brd 10.0.62.255 scope global dynamic noprefixroute enp0s3
       valid_lft 469sec preferred_lft 469sec
    inet6 fe80::c06a:a5f1:660:d341/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
3: enp0s3.200@enp0s3: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    link/ether 08:00:27:c8:ff:9a brd ff:ff:ff:ff:ff:ff
root@VB-micraPC:/# ifconfig enp0s3.200 10.0.63.2 netmask 255.255.255.0 up
root@VB-micraPC:/# ifconfig -a
enp0s3: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.62.248  netmask 255.255.255.0  broadcast 10.0.62.255
        inet6 fe80::c06a:a5f1:660:d341  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:c8:ff:9a  txqueuelen 1000  (Ethernet)
        RX packets 5239  bytes 1902367 (1.9 MB)
        RX errors 0  dropped 15  overruns 0  frame 0
        TX packets 1988  bytes 532866 (532.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp0s3.200: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.63.2  netmask 255.255.255.0  broadcast 10.0.63.255
        inet6 fe80::a00:27ff:fec8:ff9a  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:c8:ff:9a  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 32  bytes 3833 (3.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Локальная петля (Loopback))
        RX packets 172  bytes 14780 (14.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 172  bytes 14780 (14.7 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

root@VB-micraPC:/#

Пример содержимого файла interfases, при настройки VLAN через interfases

#interface loopback
auto lo
iface lo inet loopback
#Interface eth0 - untagged 
auto eth0
iface eth0 inet static
      address 192.168.10.10
      netmask 255.255.255.0
      gateway 192.168.10.1
      dns-nameservers 8.8.8.8
#Interface eth0.200 - tagged vlan 200
auto eth0.200
iface eth0.200 inet static
      address 192.168.8.10
      netmask 255.255.255.0


````
4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
````
Типы агрегации (объединения) интерфейсов в Linux:

mode=0 (balance-rr) Этот режим используется по-умолчанию, если в настройках не указано другое. balance-rr обеспечивает
балансировку нагрузки и отказоустойчивость. В данном режиме пакеты отправляются "по кругу" от первого интерфейса 
к последнему и сначала. Если выходит из строя один из интерфейсов, пакеты отправляются на остальные оставшиеся.При 
подключении портов к разным коммутаторам, требует их настройки.

mode=1 (active-backup) При active-backup один интерфейс работает в активном режиме, остальные в ожидающем. Если активный
падает, управление передается одному из ожидающих. Не требует поддержки данной функциональности от коммутатора.

mode=2 (balance-xor) Передача пакетов распределяется между объединенными интерфейсами по формуле ((MAC-адрес источника) 
XOR (MAC-адрес получателя)) % число интерфейсов. Один и тот же интерфейс работает с определённым получателем. Режим даёт
балансировку нагрузки и отказоустойчивость.

mode=3 (broadcast) Происходит передача во все объединенные интерфейсы, обеспечивая отказоустойчивость.

mode=4 (802.3ad) Это динамическое объединение портов. В данном режиме можно получить значительное увеличение пропускной 
способности как входящего так и исходящего трафика, используя все объединенные интерфейсы. Требует поддержки режима от 
коммутатора, а так же (иногда) дополнительную настройку коммутатора.

mode=5 (balance-tlb) Адаптивная балансировка нагрузки. При balance-tlb входящий трафик получается только активным 
интерфейсом, исходящий - распределяется в зависимости от текущей загрузки каждого интерфейса. Обеспечивается 
отказоустойчивость и распределение нагрузки исходящего трафика. Не требует специальной поддержки коммутатора.

mode=6 (balance-alb) Адаптивная балансировка нагрузки (более совершенная). Обеспечивает балансировку нагрузки как 
исходящего (TLB, transmit load balancing), так и входящего трафика (для IPv4 через ARP). Не требует специальной
поддержки коммутатором, но требует возможности изменять MAC-адрес устройства.

cat /etc/network/interfaces

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

auto enp0s8
iface enp0s8 inet static
address 192.168.56.101
netmask 255.255.255.0

auto enp0s6
iface enp0s6 inet dhcp

auto enp0s7
iface enp0s7 inet dhcp

# The primary network interface
auto bond0 enp0s6 enp0s7
iface bond0 inet static
        address 10.0.0.11
        netmask 255.255.255.0
        gateway 10.0.0.254
        bond-slaves enp0s6 enp0s7
        bond-mode balance-alb
bond-miimon 100
bond-downdelay 200
        bond-updelay 200

````
5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. 
Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.
````
8 ip адресов находится внутри /29. Из маски /24 можно получить 32 сети с маской /29
````
6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12,
192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум
40-50 хостов внутри подсети.
````
Адресный блок 100.64.0.0/26 - подойдет для организации стыка между двумя организациями из расчета 40-50 хостов,
т.к. содержит в себе максимально возможные 64 ip, из которых два зарезервированы под адрес сети и broadkast.
````
7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только
один нужный IP?
````
Linux:
root@VB-micraPC:/# arp -e
Адрес HW-тип HW-адрес Флаги Маска Интерфейс
10.0.62.251              ether   4c:ed:fb:79:b1:48   C                     enp0s3
10.0.62.2                        (не заверше                      enp0s3
_gateway                 ether   6c:3b:6b:07:cb:95   C                     enp0s3
root@VB-micraPC:/#

Windows:
C:\Users\Mojno_Vse>arp -a

Интерфейс: 10.0.62.251 --- 0x6
  адрес в Интернете      Физический адрес      Тип
  10.0.62.1             6c-3b-6b-07-cb-95     динамический
  10.0.62.248           08-00-27-c8-ff-9a     динамический
  10.0.62.255           ff-ff-ff-ff-ff-ff     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  224.0.0.252           01-00-5e-00-00-fc     статический
  239.255.102.18        01-00-5e-7f-66-12     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический
  255.255.255.255       ff-ff-ff-ff-ff-ff     статический

Интерфейс: 192.168.56.1 --- 0xa
  адрес в Интернете      Физический адрес      Тип
  192.168.56.255        ff-ff-ff-ff-ff-ff     статический
  224.0.0.22            01-00-5e-00-00-16     статический
  224.0.0.251           01-00-5e-00-00-fb     статический
  224.0.0.252           01-00-5e-00-00-fc     статический
  239.255.255.250       01-00-5e-7f-ff-fa     статический

C:\Users\Mojno_Vse>

````