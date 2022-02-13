# devops-netology
### performed by Kirill Karagodin
#### HW3.3 Операционные системы, лекция 1.
1. Какой системный вызов делает команда cd? 
``````
Выполнив команду /bin/bash -c 'cd /tmp' получаем полный список системных вызовов, в котором наблюдается вывод 
chdir("/tmp"), которая подразумевает переход в каталог /tmp (cd /tmp)

root@vagrant:~# strace /bin/bash -c 'cd /tmp' 2>test
root@vagrant:~# cat test
execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffc16462990 /* 24 vars */) = 0
brk(NULL)                               = 0x560fddf80000
arch_prctl(0x3001 /* ARCH_??? */, 0x7fffad6951b0) = -1 EINVAL (Invalid argument)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=26207, ...}) = 0
mmap(NULL, 26207, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f01d857d000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libtinfo.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\346\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=192032, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f01d857b000
mmap(NULL, 194944, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f01d854b000
mmap(0x7f01d8559000, 61440, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xe000) = 0x7f01d8559000
mmap(0x7f01d8568000, 57344, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1d000) = 0x7f01d8568000
mmap(0x7f01d8576000, 20480, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2a000) = 0x7f01d8576000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0 \22\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=18816, ...}) = 0
mmap(NULL, 20752, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f01d8545000
mmap(0x7f01d8546000, 8192, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1000) = 0x7f01d8546000
mmap(0x7f01d8548000, 4096, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f01d8548000
mmap(0x7f01d8549000, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0x7f01d8549000
close(3)                                = 0
openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360q\2\0\0\0\0\0"..., 832) = 832
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0", 32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"..., 68, 880) = 68
fstat(3, {st_mode=S_IFREG|0755, st_size=2029224, ...}) = 0
pread64(3, "\6\0\0\0\4\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0@\0\0\0\0\0\0\0"..., 784, 64) = 784
pread64(3, "\4\0\0\0\20\0\0\0\5\0\0\0GNU\0\2\0\0\300\4\0\0\0\3\0\0\0\0\0\0\0", 32, 848) = 32
pread64(3, "\4\0\0\0\24\0\0\0\3\0\0\0GNU\0\t\233\222%\274\260\320\31\331\326\10\204\276X>\263"..., 68, 880) = 68
mmap(NULL, 2036952, PROT_READ, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x7f01d8353000
mprotect(0x7f01d8378000, 1847296, PROT_NONE) = 0
mmap(0x7f01d8378000, 1540096, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x25000) = 0x7f01d8378000
mmap(0x7f01d84f0000, 303104, PROT_READ, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x19d000) = 0x7f01d84f0000
mmap(0x7f01d853b000, 24576, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e7000) = 0x7f01d853b000
mmap(0x7f01d8541000, 13528, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f01d8541000
close(3)                                = 0
mmap(NULL, 12288, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f01d8350000
arch_prctl(ARCH_SET_FS, 0x7f01d8350740) = 0
mprotect(0x7f01d853b000, 12288, PROT_READ) = 0
mprotect(0x7f01d8549000, 4096, PROT_READ) = 0
mprotect(0x7f01d8576000, 16384, PROT_READ) = 0
mprotect(0x560fdd47c000, 16384, PROT_READ) = 0
mprotect(0x7f01d85b1000, 4096, PROT_READ) = 0
munmap(0x7f01d857d000, 26207)           = 0
openat(AT_FDCWD, "/dev/tty", O_RDWR|O_NONBLOCK) = 3
close(3)                                = 0
brk(NULL)                               = 0x560fddf80000
brk(0x560fddfa1000)                     = 0x560fddfa1000
openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=3035952, ...}) = 0
mmap(NULL, 3035952, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f01d806a000
close(3)                                = 0
openat(AT_FDCWD, "/usr/lib/x86_64-linux-gnu/gconv/gconv-modules.cache", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=27002, ...}) = 0
mmap(NULL, 27002, PROT_READ, MAP_SHARED, 3, 0) = 0x7f01d857d000
close(3)                                = 0
getuid()                                = 0
getgid()                                = 0
geteuid()                               = 0
getegid()                               = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
ioctl(-1, TIOCGPGRP, 0x7fffad695004)    = -1 EBADF (Bad file descriptor)
sysinfo({uptime=358, loads=[160, 5472, 3872], totalram=4127342592, freeram=3622481920, sharedram=1003520, bufferram=42639360, totalswap=2057302016, freeswap=2057302016, procs=142, totalhigh=0, freehigh=0, mem_unit=1}) = 0
rt_sigaction(SIGCHLD, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGCHLD, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f01d8399210}, 8) = 0
rt_sigaction(SIGINT, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGINT, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, 8) = 0
rt_sigaction(SIGQUIT, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGQUIT, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, 8) = 0
rt_sigaction(SIGTSTP, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGTSTP, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, 8) = 0
rt_sigaction(SIGTTIN, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGTTIN, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, 8) = 0
rt_sigaction(SIGTTOU, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=0}, 8) = 0
rt_sigaction(SIGTTOU, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, 8) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigaction(SIGQUIT, {sa_handler=SIG_IGN, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER, sa_restorer=0x7f01d8399210}, 8) = 0
uname({sysname="Linux", nodename="vagrant", ...}) = 0
stat("/root", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
stat(".", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
stat("/root", {st_mode=S_IFDIR|0700, st_size=4096, ...}) = 0
stat("/", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
getpid()                                = 1435
getppid()                               = 1432
getpid()                                = 1435
getpgrp()                               = 1432
ioctl(2, TIOCGPGRP, 0x7fffad694ec4)     = -1 ENOTTY (Inappropriate ioctl for device)
rt_sigaction(SIGCHLD, {sa_handler=0x560fdd3c2aa0, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f01d8399210}, {sa_handler=SIG_DFL, sa_mask=[], sa_flags=SA_RESTORER|SA_RESTART, sa_restorer=0x7f01d8399210}, 8) = 0
ioctl(2, TIOCGPGRP, 0x7fffad694ea4)     = -1 ENOTTY (Inappropriate ioctl for device)
prlimit64(0, RLIMIT_NPROC, NULL, {rlim_cur=15528, rlim_max=15528}) = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
chdir("/tmp")                           = 0
rt_sigprocmask(SIG_BLOCK, [CHLD], [], 8) = 0
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
exit_group(0)                           = ?
+++ exited with 0 +++

``````
2. Попробуйте использовать команду file на объекты разных типов на файловой системе.
``````
Файл базы типов - /usr/share/misc/magic.mgc
из справочника по утилитам: "...Команда file позволяет определить тип файла посредством проверки соответствия начальных 
символов файла определенному "магическому" числу (помимо прочих проверок). В файле /usr/share/misc/magic указаны 
"магические" числа для проверки, сообщение, которое будет выведено в случае обнаружения конкретного "магического" числа,
а также дополнительная информация, извлекаемая из файла..."
в тексте вывода комады strace /bin/bash -c 'file /dev/tty' (например):
openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
Так же ищет пользовательские файлы:
stat("/root/.magic.mgc", 0x7ffe9384bf60) = -1 ENOENT (No such file or directory)
stat("/root/.magic", 0x7ffe9384bf60)    = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
``````
3. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла 
(чтобы освободить место на файловой системе)
``````
root@vagrant:~# ping 8.8.8.8 > ping_log
root@vagrant:~# ps aux | grep ping
root        1543  0.0  0.0   7092   936 pts/0    S+   13:44   0:00 ping 8.8.8.8
root        1610  0.0  0.0   6300   736 pts/1    S+   13:47   0:00 grep --color=auto ping
root@vagrant:~# lsof -p 1543
ping    1543 root    1w   REG  253,0    11417 1703967 /root/ping_log
root@vagrant:~# rm ping_log
root@vagrant:~# lsof -p 1543
ping    1543 root    1w   REG  253,0    11417 1703967 /root/ping_log (deleted)
root@vagrant:~# ps aux | grep ping
root        1543  0.0  0.0   7092   936 pts/0    S+   13:44   0:00 ping 8.8.8.8
root        1610  0.0  0.0   6300   736 pts/1    S+   13:47   0:00 grep --color=auto ping
root@vagrant:~# rm ping_log
root@vagrant:~# lsof -p 1543
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
.........
ping    1543 root    1w   REG  253,0    11417 1703967 /root/ping_log (deleted)
..........
root@vagrant:~# echo '' > /proc/1543/fd/1
root@vagrant:~# cat /dev/null > /proc/1543/fd/1
root@vagrant:~# > /proc/1543/fd/1
root@vagrant:~# truncate -s 0 /proc/1543/fd/1
root@vagrant:~# lsof -p 1543
COMMAND  PID USER   FD   TYPE DEVICE SIZE/OFF    NODE NAME
..........
ping    1543 root    1w   REG  253,0    25081 1703967 /root/ping_log (deleted)
..........
root@vagrant:~# ls -l
total 92
-rw-r--r-- 1 root root 90112 Feb  1 18:24 history
-rw-r--r-- 1 root root     0 Feb  6 19:29 new_file
drwxr-xr-x 3 root root  4096 Dec 19 19:42 snap
root@vagrant:~# cat /proc/1543/fd/1
64 bytes from 8.8.8.8: icmp_seq=436 ttl=58 time=13.3 ms
64 bytes from 8.8.8.8: icmp_seq=437 ttl=58 time=14.5 ms
64 bytes from 8.8.8.8: icmp_seq=438 ttl=58 time=13.4 ms
64 bytes from 8.8.8.8: icmp_seq=439 ttl=58 time=13.6 ms
64 bytes from 8.8.8.8: icmp_seq=440 ttl=58 time=13.4 ms

При проверке df -h место не менятется 
``````
4. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
``````
"Зомби" процессы, в отличии от "сирот" освобождают свои ресурсы, но не освобождают запись в таблице процессов.
``````
5. В iovisor BCC есть утилита opensnoop. На какие файлы вы увидели вызовы группы open за первую секунду работы утилиты? 
``````
За первые секунды работы утилиты наблюдаются вызовы к следующим файлам: utmp (Этот файл содержит информацию 
о пользователях, которые в настоящее время вошли в систему), а например через систему dbus-daemon 
(система межпроцессного взаимодействия, которая позволяет приложениям в операционной системе сообщаться друг с другом) 
лежит путь /usr/local/share/dbus-1/system-services это стандартный директорий для установки файлов.service.
root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
/usr/sbin/opensnoop-bpfcc
root@vagrant:~# /usr/sbin/opensnoop-bpfcc
PID    COMM               FD ERR PATH
382    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.procs
382    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.threads
636    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
636    dbus-daemon        19   0 /usr/share/dbus-1/system-services
636    dbus-daemon        -1   2 /lib/dbus-1/system-services
636    dbus-daemon        19   0 /var/lib/snapd/dbus-1/system-services/
866    vminfo              5   0 /var/run/utmp
``````
6. Какой системный вызов использует uname -a?
``````
uname -a представляет вызов результата всех ключей all (-a) по которым предоставляется информация о названии ядра 
системы, версии, релизе ядра системы, типе операционной системы
Альтернативное местоположение системого вызова находится: / proc / sys / ядро/ {osrelease, version}
``````
7. Чем отличается последовательность команд через ; и через && в bash? 
``````
азница в том, что при исполнении команд через ";" они исполняются последовательно и следующая команда исполнится в любом
 случае в не зависимости от успешного /неуспешного завершения предыдущей.
При исполнении команд через "&&" каждая последующая команда будет исполняться только в случае успешного завершения 
предыдущей. Kоманда set -e прерывает процесс исполнения программы, даже если оболочка возвращает ненулевой статус имеет 
смысл, если исполнится вместе через ";"
``````
8. Из каких опций состоит режим bash set -euxo pipefail и почему его хорошо было бы использовать в сценариях?
``````
-e прерывает выполнение исполнения при ошибке любой команды кроме последней в последовательности 
-x вывод трейса простых команд 
-u неустановленные/не заданные параметры и переменные считаются как ошибки, с выводом в stderr текста ошибки и выполнит 
завершение неинтерактивного вызова
-o pipefail возвращает код возврата набора/последовательности команд, ненулевой при последней команды или 0 для 
успешного выполнения команд.

Для сценария хорошо тем, что отслеживает ошибки и прерывает исполнение сценария при ошибке любой команды кроме последней
``````
9. Используя -o stat для ps, определите, какой наиболее часто встречающийся статус у процессов в системе.
В man ps ознакомьтесь (/PROCESS STATE CODES) что значат дополнительные к основной заглавной буквы статуса процессов.
Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
``````
root@vagrant:~# ps -o stat
STAT
Ss - спящий процесс в лидирующей сессии
R+ -  выполняемый процесс, который находится в основной группе процессов
root@vagrant:~# man ps
PROCESS STATE CODES
       Here are the different values that the s, stat and state output specifiers (header "STAT" or "S") will display to describe the state of a process:

               D    uninterruptible sleep (usually IO)
               I    Idle kernel thread
               R    running or runnable (on run queue)
               S    interruptible sleep (waiting for an event to complete)
               T    stopped by job control signal
               t    stopped by debugger during the tracing
               W    paging (not valid since the 2.6.xx kernel)
               X    dead (should never be seen)
               Z    defunct ("zombie") process, terminated but not reaped by its parent

       For BSD formats and when the stat keyword is used, additional characters may be displayed:

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group

Дополнительные символы к основной букве выводят расширенную информацию о процессе (например приоритет процесса)
``````
