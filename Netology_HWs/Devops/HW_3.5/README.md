# devops-netology
### performed by Kirill Karagodin
#### HW3.5 Файловые системы.

1. Узнайте о sparse (разряженных) файлах.
``````
Разряженные файлы - это такие файлы которые не позволяют ФС занимать свободное дисковое пространство носителя, когда 
разделы не заполнены. Пустая информация в виде нулей, будет хранится в блоке метаданных ФС. Поэтому, разреженные файлы 
изначально занимают меньший объем носителя, чем их реальный объем.
``````
2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
``````
Нет, они имеют одинаковые права доступа к файлу, т.к. жесткая ссылка и файл имеют один и тот же inode. Жесткая ссылка 
это синоним файла. inode - это индекс нода дескриптер (уникальный указатель на файл)
``````
3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Devops/HW_3.5/vagrand_conf.JPG)
``````
root@vagrant:/home/vagrant# fdisk -l
Disk /dev/loop0: 55.45 MiB, 58130432 bytes, 113536 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop1: 70.32 MiB, 73728000 bytes, 144000 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop3: 55.52 MiB, 58204160 bytes, 113680 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop4: 43.6 MiB, 45703168 bytes, 89264 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop5: 61.93 MiB, 64917504 bytes, 126792 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/loop6: 67.25 MiB, 70508544 bytes, 137712 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: B4F1CD46-1589-455C-BA21-5171874A019C

Device       Start       End   Sectors Size Type
/dev/sda1     2048      4095      2048   1M BIOS boot
/dev/sda2     4096   2101247   2097152   1G Linux filesystem
/dev/sda3  2101248 134215679 132114432  63G Linux filesystem


Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/ubuntu--vg-ubuntu--lv: 31.51 GiB, 33822867456 bytes, 66060288 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
root@vagrant:/home/vagrant#
``````
4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.
``````
root@vagrant:/home/vagrant# fdisk /dev/sdb

Welcome to fdisk (util-linux 2.34).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

Device does not contain a recognized partition table.
Created a new DOS disklabel with disk identifier 0xc62c9acd.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc62c9acd

Command (m for help): n
Partition type
   p   primary (0 primary, 0 extended, 4 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (1-4, default 1):
First sector (2048-5242879, default 2048):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G

Created a new partition 1 of type 'Linux' and of size 2 GiB.

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2):
First sector (4196352-5242879, default 4196352):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879): +510M

Created a new partition 2 of type 'Linux' and of size 510 MiB.

Command (m for help): p
Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xc62c9acd

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdb1          2048 4196351 4194304    2G 83 Linux
/dev/sdb2       4196352 5240831 1044480  510M 83 Linux

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
``````
5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.
``````
root@vagrant:/home/vagrant# sfdisk -d /dev/sdb|sfdisk /dev/sdc
Checking that no-one is using this disk right now ... OK

Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
Disk model: VBOX HARDDISK
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Script header accepted.
>>> Created a new DOS disklabel with disk identifier 0xc62c9acd.
/dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
/dev/sdc2: Created a new partition 2 of type 'Linux' and of size 510 MiB.
/dev/sdc3: Done.

New situation:
Disklabel type: dos
Disk identifier: 0xc62c9acd

Device     Boot   Start     End Sectors  Size Id Type
/dev/sdc1          2048 4196351 4194304    2G 83 Linux
/dev/sdc2       4196352 5240831 1044480  510M 83 Linux

The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
``````
6. Соберите mdadm RAID1 на паре разделов 2 Гб.
``````
root@vagrant:/home/vagrant# mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=0.90
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md1 started.
root@vagrant:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  510M  0 part
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  510M  0 part
root@vagrant:/home/vagrant#
``````
7. Соберите mdadm RAID0 на второй паре маленьких разделов.
``````
root@vagrant:/home/vagrant# mdadm --create /dev/md0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
root@vagrant:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  510M  0 part
  └─md0                     9:0    0 1016M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  510M  0 part
  └─md0                     9:0    0 1016M  0 raid0
``````
8. Создайте 2 независимых PV на получившихся md-устройствах.
``````
root@vagrant:/home/vagrant# pvcreate /dev/md0 /dev/md1
  Physical volume "/dev/md0" successfully created.
  Physical volume "/dev/md1" successfully created.
``````
9. Создайте общую volume-group на этих двух PV.
``````
root@vagrant:/home/vagrant# vgcreate vg1 /dev/md0 /dev/md1
  Volume group "vg1" successfully created
root@vagrant:/home/vagrant# vgdisplay
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <63.00 GiB
  PE Size               4.00 MiB
  Total PE              16127
  Alloc PE / Size       8064 / 31.50 GiB
  Free  PE / Size       8063 / <31.50 GiB
  VG UUID               aK7Bd1-JPle-i0h7-5jJa-M60v-WwMk-PFByJ7

  --- Volume group ---
  VG Name               vg1
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               2.98 GiB
  PE Size               4.00 MiB
  Total PE              764
  Alloc PE / Size       0 / 0
  Free  PE / Size       764 / 2.98 GiB
  VG UUID               i9DcAC-acZN-Vd0v-JGVH-xyEt-BBDO-vsON8D
``````
10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.
``````
root@vagrant:/home/vagrant# lvcreate -L 100M vg1 /dev/md0
  Logical volume "lvol0" created.
root@vagrant:/home/vagrant# vgs
  VG        #PV #LV #SN Attr   VSize   VFree
  ubuntu-vg   1   1   0 wz--n- <63.00g <31.50g
  vg1         2   1   0 wz--n-   2.98g  <2.89g
root@vagrant:/home/vagrant# lvs
  LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  ubuntu-lv ubuntu-vg -wi-ao----  31.50g                                         
  lvol0     vg1       -wi-a----- 100.00m
``````
11. Создайте mkfs.ext4 ФС на получившемся LV.
``````
root@vagrant:/home/vagrant# mkfs.ext4 /dev/vg1/lvol0
mke2fs 1.45.5 (07-Jan-2020)
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done
Writing inode tables: done
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done
``````
12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.
``````
root@vagrant:/home/vagrant# mkdir /tmp/test
root@vagrant:/home/vagrant# mount /dev/vg1/lvol0 /tmp/test/
root@vagrant:/home/vagrant# mount
.......
/dev/mapper/vg1-lvol0 on /tmp/test type ext4 (rw,relatime,stripe=256)
root@vagrant:/home/vagrant#
``````
13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.
``````
root@vagrant:/home/vagrant# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/test/test.gz
--2022-02-21 12:43:33--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 22315112 (21M) [application/octet-stream]
Saving to: ‘/tmp/test/test.gz’

/tmp/test/test.gz    100%[===================>]  21.28M  8.04MB/s    in 2.6s

2022-02-21 12:43:36 (8.04 MB/s) - ‘/tmp/test/test.gz’ saved [22315112/22315112
root@vagrant:/home/vagrant# ls -l /tmp/test/
total 21812
drwx------ 2 root root    16384 Feb 21 12:41 lost+found
-rw-r--r-- 1 root root 22315112 Feb 21 09:42 test.gz
root@vagrant:/home/vagrant#
``````
14. Прикрепите вывод lsblk.
``````
root@vagrant:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdb2                      8:18   0  510M  0 part
  └─md0                     9:0    0 1016M  0 raid0
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/test
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
└─sdc2                      8:34   0  510M  0 part
  └─md0                     9:0    0 1016M  0 raid0
    └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/test
root@vagrant:/home/vagrant#
``````
15. Протестируйте целостность файла
``````
root@vagrant:/home/vagrant# gzip -t /tmp/test/test.gz
root@vagrant:/home/vagrant# echo $?
0
``````
16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.
``````
root@vagrant:/home/vagrant# pvmove /dev/md0
  /dev/md0: Moved: 12.00%
  /dev/md0: Moved: 100.00%
root@vagrant:/home/vagrant# lsblk
NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
loop0                       7:0    0 55.4M  1 loop  /snap/core18/2128
loop1                       7:1    0 70.3M  1 loop  /snap/lxd/21029
loop3                       7:3    0 55.5M  1 loop  /snap/core18/2284
loop4                       7:4    0 43.6M  1 loop  /snap/snapd/14978
loop5                       7:5    0 61.9M  1 loop  /snap/core20/1328
loop6                       7:6    0 67.2M  1 loop  /snap/lxd/21835
sda                         8:0    0   64G  0 disk
├─sda1                      8:1    0    1M  0 part
├─sda2                      8:2    0    1G  0 part  /boot
└─sda3                      8:3    0   63G  0 part
  └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm   /
sdb                         8:16   0  2.5G  0 disk
├─sdb1                      8:17   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/test
└─sdb2                      8:18   0  510M  0 part
  └─md0                     9:0    0 1016M  0 raid0
sdc                         8:32   0  2.5G  0 disk
├─sdc1                      8:33   0    2G  0 part
│ └─md1                     9:1    0    2G  0 raid1
│   └─vg1-lvol0           253:1    0  100M  0 lvm   /tmp/test
└─sdc2                      8:34   0  510M  0 part
  └─md0                     9:0    0 1016M  0 raid0
root@vagrant:/home/vagrant#

``````
17. Сделайте --fail на устройство в вашем RAID1 md.
``````
root@vagrant:/home/vagrant# mdadm /dev/md1 --fail /dev/sdb1
mdadm: set /dev/sdb1 faulty in /dev/md1
root@vagrant:/home/vagrant# mdadm -D /dev/md1
/dev/md1:
           Version : 1.2
     Creation Time : Mon Feb 21 12:26:20 2022
        Raid Level : raid1
        Array Size : 2094080 (2045.00 MiB 2144.34 MB)
     Used Dev Size : 2094080 (2045.00 MiB 2144.34 MB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Mon Feb 21 12:49:58 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

Consistency Policy : resync

              Name : vagrant:1  (local to host vagrant)
              UUID : 1267c744:94371704:88a2d8b4:1067eaf5
            Events : 19

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1

       0       8       17        -      faulty   /dev/sdb1
root@vagrant:/home/vagrant#

``````
18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.
``````
root@vagrant:/home/vagrant# dmesg |grep md1
[ 1152.830849] md/raid1:md1: not clean -- starting background reconstruction
[ 1152.830850] md/raid1:md1: active with 2 out of 2 mirrors
[ 1152.830859] md1: detected capacity change from 0 to 2144337920
[ 1152.831611] md: resync of RAID array md1
[ 1163.284793] md: md1: resync done.
[ 2570.236610] md/raid1:md1: Disk failure on sdb1, disabling device.
               md/raid1:md1: Operation continuing on 1 devices.
root@vagrant:/home/vagrant#
``````
19. Протестируйте целостность файла, несмотря на "сбойный" диск.
``````
root@vagrant:/home/vagrant# gzip -t /tmp/test/test.gz
root@vagrant:/home/vagrant# echo $?
0
``````
20. Погасите тестовый хост, vagrant destroy
``````
PS F:\WM_netology_work\VagrantVM> vagrant destroy
    default: Are you sure you want to destroy the 'default' VM? [y/N] y
==> default: Forcing shutdown of VM...
==> default: Destroying VM and associated drives...
PS F:\WM_netology_work\VagrantVM>
``````