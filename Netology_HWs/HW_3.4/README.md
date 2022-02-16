# devops-netology
### performed by Kirill Karagodin
#### HW3.4 Операционные системы, лекция 2.
1. node_exporter

``````
Создан файд node_exporter.service
root@vagrant:~# cat /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple

EnvironmentFile=/opt/node_exporter-1.3.1.linux-amd64/node_exporter_env
ExecStart=/opt/node_exporter-1.3.1.linux-amd64/node_exporter $OPTIONS

[Install]
WantedBy=default.target

root@vagrant:~# systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; disabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-02-16 18:53:41 UTC; 1min 21s ago
   Main PID: 1792 (node_exporter)
      Tasks: 4 (limit: 4658)
     Memory: 2.4M
     CGroup: /system.slice/node_exporter.service
             └─1792 /opt/node_exporter-1.3.1.linux-amd64/node_exporter
В файле node_exporter_env задана одна переменная A=b. PID и системные переменные процесса node_exporter
заданные через файл node_exporter_env
root@vagrant:~# ps -e | grep node_exporter
   1047 ?        00:00:00 node_exporter
root@vagrant:~# cat /proc/1047/environ
LANG=en_US.UTF-8PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/binHOME=/home/node_exporterLOGNAME=node_exporterUSER=node_exporterINVOCATION_ID=2a488a46f6e340fd9a3b76ee56f94c3aJOURNAL_STREAM=9:24452A=b
root@vagrant:~#
``````
1.1 Поместите его в автозагрузку
``````
root@vagrant:~# systemctl enable node_exporter
Created symlink /etc/systemd/system/default.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
``````
1.2 Предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на 
systemctl cat cron)
``````
root@vagrant:~# systemctl cat cron
# /lib/systemd/system/cron.service
[Unit]
Description=Regular background program processing daemon
Documentation=man:cron(8)
After=remote-fs.target nss-user-lookup.target

[Service]
EnvironmentFile=-/etc/default/cron
ExecStart=/usr/sbin/cron -f $EXTRA_OPTS
IgnoreSIGPIPE=false
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target

``````
1.3 Удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически
поднимается.

STOP node_exporter
``````
root@vagrant:~# systemctl stop node_exporter
root@vagrant:~# systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: inactive (dead) since Wed 2022-02-16 20:25:20 UTC; 3s ago
    Process: 637 ExecStart=/opt/node_exporter-1.3.1.linux-amd64/node_exporter $OPTIONS (code=killed, sign>
   Main PID: 637 (code=killed, signal=TERM)

Feb 16 20:23:42 vagrant node_exporter[637]: ts=2022-02-16T20:23:42.687Z caller=node_exporter.go:115 level>
Feb 16 20:23:42 vagrant node_exporter[637]: ts=2022-02-16T20:23:42.687Z caller=node_exporter.go:115 level>
Feb 16 20:23:42 vagrant node_exporter[637]: ts=2022-02-16T20:23:42.687Z caller=node_exporter.go:115 level>
Feb 16 20:23:42 vagrant node_exporter[637]: ts=2022-02-16T20:23:42.687Z caller=node_exporter.go:115 level>
Feb 16 20:23:42 vagrant node_exporter[637]: ts=2022-02-16T20:23:42.687Z caller=node_exporter.go:115 level>
Feb 16 20:23:42 vagrant node_exporter[637]: ts=2022-02-16T20:23:42.687Z caller=node_exporter.go:199 level>
Feb 16 20:23:42 vagrant node_exporter[637]: ts=2022-02-16T20:23:42.688Z caller=tls_config.go:195 level=in>
Feb 16 20:25:20 vagrant systemd[1]: Stopping Node Exporter...
Feb 16 20:25:20 vagrant systemd[1]: node_exporter.service: Succeeded.
Feb 16 20:25:20 vagrant systemd[1]: Stopped Node Exporter.
``````
START node_exporter
``````
root@vagrant:~# systemctl start node_exporter
root@vagrant:~# systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-02-16 20:26:59 UTC; 1s ago
   Main PID: 1049 (node_exporter)
      Tasks: 4 (limit: 4658)
     Memory: 2.5M
     CGroup: /system.slice/node_exporter.service
             └─1049 /opt/node_exporter-1.3.1.linux-amd64/node_exporter

Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.329Z caller=node_exporter.go:115 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.329Z caller=node_exporter.go:115 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.329Z caller=node_exporter.go:115 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.329Z caller=node_exporter.go:115 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.329Z caller=node_exporter.go:115 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.329Z caller=node_exporter.go:115 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.329Z caller=node_exporter.go:115 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.329Z caller=node_exporter.go:115 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.331Z caller=node_exporter.go:199 leve>
Feb 16 20:26:59 vagrant node_exporter[1049]: ts=2022-02-16T20:26:59.331Z caller=tls_config.go:195 level=i>
root@vagrant:~#
``````
Рестарт системы
``````
PID до рестарта системы
root@vagrant:~# ps -e | grep node_exporter
   1049 ?        00:00:00 node_exporter
PID после рестарта 
root@vagrant:~# init 6
login as: root
root@10.0.62.249's password:
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed 16 Feb 2022 08:29:15 PM UTC

  System load:  0.69               Processes:             129
  Usage of /:   13.1% of 30.88GB   Users logged in:       0
  Memory usage: 5%                 IPv4 address for eth0: 10.0.62.249
  Swap usage:   0%


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Wed Feb 16 20:23:57 2022 from 10.0.62.251
root@vagrant:~# ps -e | grep node_exporter
    638 ?        00:00:00 node_exporter
root@vagrant:~# systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-02-16 20:29:04 UTC; 37s ago
   Main PID: 638 (node_exporter)
      Tasks: 5 (limit: 4658)
     Memory: 13.7M
     CGroup: /system.slice/node_exporter.service
             └─638 /opt/node_exporter-1.3.1.linux-amd64/node_exporter

Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:115 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:115 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:115 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:115 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:115 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:115 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:115 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:115 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.305Z caller=node_exporter.go:199 level>
Feb 16 20:29:05 vagrant node_exporter[638]: ts=2022-02-16T20:29:05.306Z caller=tls_config.go:195 level=in>
root@vagrant:~#
``````
2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию.

CPU
``````
root@vagrant:~# curl -s http://localhost:9100/metrics | grep node_cpu
# HELP node_cpu_guest_seconds_total Seconds the CPUs spent in guests (VMs) for each mode.
# TYPE node_cpu_guest_seconds_total counter
node_cpu_guest_seconds_total{cpu="0",mode="nice"} 0
node_cpu_guest_seconds_total{cpu="0",mode="user"} 0
node_cpu_guest_seconds_total{cpu="1",mode="nice"} 0
node_cpu_guest_seconds_total{cpu="1",mode="user"} 0
# HELP node_cpu_seconds_total Seconds the CPUs spent in each mode.
# TYPE node_cpu_seconds_total counter
node_cpu_seconds_total{cpu="0",mode="idle"} 360.82
node_cpu_seconds_total{cpu="0",mode="iowait"} 1.12
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 0
node_cpu_seconds_total{cpu="0",mode="softirq"} 0.04
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 2.1
node_cpu_seconds_total{cpu="0",mode="user"} 1.04
node_cpu_seconds_total{cpu="1",mode="idle"} 359.41
node_cpu_seconds_total{cpu="1",mode="iowait"} 0.83
node_cpu_seconds_total{cpu="1",mode="irq"} 0
node_cpu_seconds_total{cpu="1",mode="nice"} 0
node_cpu_seconds_total{cpu="1",mode="softirq"} 0.05
node_cpu_seconds_total{cpu="1",mode="steal"} 0
node_cpu_seconds_total{cpu="1",mode="system"} 1.83
node_cpu_seconds_total{cpu="1",mode="user"} 1.32
root@vagrant:~#
``````
RAM
``````
root@vagrant:~# curl -s http://localhost:9100/metrics | grep "node_memory" | grep -v "HELP" | grep -v "TYPE"
node_memory_Active_anon_bytes 5.7659392e+07
node_memory_Active_bytes 1.77860608e+08
node_memory_Active_file_bytes 1.20201216e+08
node_memory_AnonHugePages_bytes 0
node_memory_AnonPages_bytes 7.1467008e+07
node_memory_Bounce_bytes 0
node_memory_Buffers_bytes 4.1017344e+07
node_memory_Cached_bytes 2.819072e+08
node_memory_CmaFree_bytes 0
node_memory_CmaTotal_bytes 0
node_memory_CommitLimit_bytes 4.120973312e+09
node_memory_Committed_AS_bytes 5.16358144e+08
node_memory_DirectMap2M_bytes 4.158652416e+09
node_memory_DirectMap4k_bytes 1.36249344e+08
node_memory_Dirty_bytes 0
node_memory_FileHugePages_bytes 0
node_memory_FilePmdMapped_bytes 0
node_memory_HardwareCorrupted_bytes 0
node_memory_HugePages_Free 0
node_memory_HugePages_Rsvd 0
node_memory_HugePages_Surp 0
node_memory_HugePages_Total 0
node_memory_Hugepagesize_bytes 2.097152e+06
node_memory_Hugetlb_bytes 0
node_memory_Inactive_anon_bytes 131072
node_memory_Inactive_bytes 1.97455872e+08
node_memory_Inactive_file_bytes 1.973248e+08
node_memory_KReclaimable_bytes 3.4537472e+07
node_memory_KernelStack_bytes 2.408448e+06
node_memory_Mapped_bytes 7.9765504e+07
node_memory_MemAvailable_bytes 3.740962816e+09
node_memory_MemFree_bytes 3.614089216e+09
node_memory_MemTotal_bytes 4.127342592e+09
node_memory_Mlocked_bytes 1.8972672e+07
node_memory_NFS_Unstable_bytes 0
node_memory_PageTables_bytes 1.728512e+06
node_memory_Percpu_bytes 1.163264e+06
node_memory_SReclaimable_bytes 3.4537472e+07
node_memory_SUnreclaim_bytes 4.562944e+07
node_memory_ShmemHugePages_bytes 0
node_memory_ShmemPmdMapped_bytes 0
node_memory_Shmem_bytes 999424
node_memory_Slab_bytes 8.0166912e+07
node_memory_SwapCached_bytes 0
node_memory_SwapFree_bytes 2.057302016e+09
node_memory_SwapTotal_bytes 2.057302016e+09
node_memory_Unevictable_bytes 1.8972672e+07
node_memory_VmallocChunk_bytes 0
node_memory_VmallocTotal_bytes 3.5184372087808e+13
node_memory_VmallocUsed_bytes 2.7455488e+07
node_memory_WritebackTmp_bytes 0
node_memory_Writeback_bytes 0
root@vagrant:~#

``````
HDD
``````
root@vagrant:~# curl -s http://localhost:9100/metrics | grep "node_disk" | grep -v "HELP" | grep -v "TYPE"
node_disk_discard_time_seconds_total{device="dm-0"} 0
node_disk_discard_time_seconds_total{device="sda"} 0
node_disk_discarded_sectors_total{device="dm-0"} 0
node_disk_discarded_sectors_total{device="sda"} 0
node_disk_discards_completed_total{device="dm-0"} 0
node_disk_discards_completed_total{device="sda"} 0
node_disk_discards_merged_total{device="dm-0"} 0
node_disk_discards_merged_total{device="sda"} 0
node_disk_info{device="dm-0",major="253",minor="0"} 1
node_disk_info{device="sda",major="8",minor="0"} 1
node_disk_io_now{device="dm-0"} 0
node_disk_io_now{device="sda"} 0
node_disk_io_time_seconds_total{device="dm-0"} 6.344
node_disk_io_time_seconds_total{device="sda"} 6.492
node_disk_io_time_weighted_seconds_total{device="dm-0"} 29.66
node_disk_io_time_weighted_seconds_total{device="sda"} 11.856
node_disk_read_bytes_total{device="dm-0"} 2.24080896e+08
node_disk_read_bytes_total{device="sda"} 2.3350272e+08
node_disk_read_time_seconds_total{device="dm-0"} 28.492
node_disk_read_time_seconds_total{device="sda"} 16.882
node_disk_reads_completed_total{device="dm-0"} 7995
node_disk_reads_completed_total{device="sda"} 5760
node_disk_reads_merged_total{device="dm-0"} 0
node_disk_reads_merged_total{device="sda"} 2542
node_disk_write_time_seconds_total{device="dm-0"} 1.168
node_disk_write_time_seconds_total{device="sda"} 1.478
node_disk_writes_completed_total{device="dm-0"} 903
node_disk_writes_completed_total{device="sda"} 594
node_disk_writes_merged_total{device="dm-0"} 0
node_disk_writes_merged_total{device="sda"} 348
node_disk_written_bytes_total{device="dm-0"} 1.1313152e+07
node_disk_written_bytes_total{device="sda"} 1.132544e+07
``````
LAN
``````
root@vagrant:~# curl -s http://localhost:9100/metrics | grep "node_network" | grep -v "HELP" | grep -v "TYPE"
node_network_address_assign_type{device="eth0"} 0
node_network_address_assign_type{device="lo"} 0
node_network_carrier{device="eth0"} 1
node_network_carrier{device="lo"} 1
node_network_carrier_changes_total{device="eth0"} 2
node_network_carrier_changes_total{device="lo"} 0
node_network_carrier_down_changes_total{device="eth0"} 1
node_network_carrier_down_changes_total{device="lo"} 0
node_network_carrier_up_changes_total{device="eth0"} 1
node_network_carrier_up_changes_total{device="lo"} 0
node_network_device_id{device="eth0"} 0
node_network_device_id{device="lo"} 0
node_network_dormant{device="eth0"} 0
node_network_dormant{device="lo"} 0
node_network_flags{device="eth0"} 4099
node_network_flags{device="lo"} 9
node_network_iface_id{device="eth0"} 2
node_network_iface_id{device="lo"} 1
node_network_iface_link{device="eth0"} 2
node_network_iface_link{device="lo"} 1
node_network_iface_link_mode{device="eth0"} 0
node_network_iface_link_mode{device="lo"} 0
node_network_info{address="00:00:00:00:00:00",broadcast="00:00:00:00:00:00",device="lo",duplex="",ifalias="",operstate="unknown"} 1
node_network_info{address="08:00:27:b1:28:5d",broadcast="ff:ff:ff:ff:ff:ff",device="eth0",duplex="full",ifalias="",operstate="up"} 1
node_network_mtu_bytes{device="eth0"} 1500
node_network_mtu_bytes{device="lo"} 65536
node_network_net_dev_group{device="eth0"} 0
node_network_net_dev_group{device="lo"} 0
node_network_protocol_type{device="eth0"} 1
node_network_protocol_type{device="lo"} 772
node_network_receive_bytes_total{device="eth0"} 193341
node_network_receive_bytes_total{device="lo"} 181670
node_network_receive_compressed_total{device="eth0"} 0
node_network_receive_compressed_total{device="lo"} 0
node_network_receive_drop_total{device="eth0"} 243
node_network_receive_drop_total{device="lo"} 0
node_network_receive_errs_total{device="eth0"} 0
node_network_receive_errs_total{device="lo"} 0
node_network_receive_fifo_total{device="eth0"} 0
node_network_receive_fifo_total{device="lo"} 0
node_network_receive_frame_total{device="eth0"} 0
node_network_receive_frame_total{device="lo"} 0
node_network_receive_multicast_total{device="eth0"} 242
node_network_receive_multicast_total{device="lo"} 0
node_network_receive_packets_total{device="eth0"} 914
node_network_receive_packets_total{device="lo"} 114
node_network_speed_bytes{device="eth0"} 1.25e+08
node_network_transmit_bytes_total{device="eth0"} 30783
node_network_transmit_bytes_total{device="lo"} 181670
node_network_transmit_carrier_total{device="eth0"} 0
node_network_transmit_carrier_total{device="lo"} 0
node_network_transmit_colls_total{device="eth0"} 0
node_network_transmit_colls_total{device="lo"} 0
node_network_transmit_compressed_total{device="eth0"} 0
node_network_transmit_compressed_total{device="lo"} 0
node_network_transmit_drop_total{device="eth0"} 0
node_network_transmit_drop_total{device="lo"} 0
node_network_transmit_errs_total{device="eth0"} 0
node_network_transmit_errs_total{device="lo"} 0
node_network_transmit_fifo_total{device="eth0"} 0
node_network_transmit_fifo_total{device="lo"} 0
node_network_transmit_packets_total{device="eth0"} 149
node_network_transmit_packets_total{device="lo"} 114
node_network_transmit_queue_length{device="eth0"} 1000
node_network_transmit_queue_length{device="lo"} 1000
node_network_up{device="eth0"} 1
node_network_up{device="lo"} 0
root@vagrant:~#
``````
3. Установите в свою виртуальную машину Netdata. 

Установка:
``````
root@vagrant:~# aptitude install netdata
The following NEW packages will be installed:
  fonts-font-awesome{a} fonts-glyphicons-halflings{a} freeipmi-common{a} libc-ares2{a}
  libfreeipmi17{a} libipmimonitoring6{a} libjs-bootstrap{a} libjudydebian1{a} libnetfilter-acct1{a}
  libnode64{a} netdata netdata-core{a} netdata-plugins-bash{a} netdata-plugins-nodejs{a}
  netdata-plugins-python{a} netdata-web{a} nodejs{a} nodejs-doc{a}
0 packages upgraded, 18 newly installed, 0 to remove and 1 not upgraded.
Need to get 10.5 MB of archives. After unpacking 47.3 MB will be used.
Do you want to continue? [Y/n/?] y
.......
root@vagrant:~# 
``````
Проверка запуска
``````
root@vagrant:~# systemctl status netdata
● netdata.service - netdata - Real-time performance monitoring
     Loaded: loaded (/lib/systemd/system/netdata.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2022-02-16 20:43:25 UTC; 6s ago
       Docs: man:netdata
             file:///usr/share/doc/netdata/html/index.html
             https://github.com/netdata/netdata
   Main PID: 2124 (netdata)
      Tasks: 19 (limit: 4658)
     Memory: 21.3M
     CGroup: /system.slice/netdata.service
             ├─2124 /usr/sbin/netdata -D
             ├─2176 /usr/lib/netdata/plugins.d/nfacct.plugin 1
             ├─2179 /usr/lib/netdata/plugins.d/apps.plugin 1
             └─2202 bash /usr/lib/netdata/plugins.d/tc-qos-helper.sh 1

Feb 16 20:43:25 vagrant systemd[1]: Started netdata - Real-time performance monitoring.
Feb 16 20:43:25 vagrant netdata[2124]: SIGNAL: Not enabling reaper
Feb 16 20:43:25 vagrant netdata[2124]: 2022-02-16 20:43:25: netdata INFO  : MAIN : SIGNAL: Not enabling r>
root@vagrant:~# 
``````
Прописывать настройки сети в Vagrand не стал, так как у меня настройки сети на вертульной машине выставлены в режим
сетевого моста.

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/HW_3.4/dashboard.JPG)

4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе 
виртуализации?
``````
Команда dmesg используется для проверки содержимого или управления буфером кольца ядра.В результате вывода команды dmesg\
ядро выводит сообщение о KVM, значит ответ "Да, осознает".
root@vagrant:~# sudo dmesg | grep "Hypervisor detected"
[    0.000000] Hypervisor detected: KVM
``````
5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой 
существующий лимит не позволит достичь такого числа (ulimit --help)?
``````
fs.nr_open - сообщает какое максимальное количество файловых дискриптеров возможно открыть

    The default value fs.nr_open is 1024*1024 = 1048576.
    The maximum value of fs.nr_open is limited to sysctl_nr_open_max in kernel, which is 2147483584 on x86_64.

Note: The value of "Max open files"(ulimit -n) is limited to fs.nr_open value.*
``````
6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном
неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном
задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.
``````
nsenter - run program in different namespaces
Создаем процесс 
root@vagrant:~# unshare --fork --pid --mount-proc sleep 1h
root@vagrant:~# ps -ef | grep sleep
root        1573    1536  0 21:31 pts/1    00:00:00 unshare --fork --pid --mount-proc sleep 1h
root        1574    1573  0 21:31 pts/1    00:00:00 sleep 1h
root        1663    1647  0 21:31 pts/0    00:00:00 grep --color=auto sleep

заходим в namespaсe процесса и видим что sleep под PID1
root@vagrant:~# nsenter -t 1574 -p -m
root@vagrant:/# ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 21:31 pts/1    00:00:00 sleep 1h
root           2       0  0 21:32 pts/0    00:00:00 -bash
root          13       2  0 21:32 pts/0    00:00:00 ps -ef
root@vagrant:/#
``````
7. Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant
с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего
(минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации.
Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?
``````
:() создается функция с названием ":"
{ } описано ее поведение (тело)
:|:& вызов себя и вызов себя повторно через логическое ИЛИ; 
& запуск в фоновом режиме
; конец описания функции
: вызов функции ":"

после запуска вывел сообщения о достижении лимита:

: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable
-bash: fork: retry: Resource temporarily unavailable

в журнале dmesg видим запись о том, что помог механизм cgroup

[27806.034979] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-24.scope
``````


