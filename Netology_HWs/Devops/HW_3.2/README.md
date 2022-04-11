# devops-netology
### performed by Kirill Karagodin
#### HW3.1 Работа в терминале, лекция 2.
1. Какого типа команда cd?
`````
Команда cd является встроенной (внутренней) командой оболочки, используется для изменения текущего рабочего каталога в 
Linux/Unix-подобных операционных системах и ОС семейсва Windows (DOS команда).
`````
2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? 
`````
grep -с <some_string> <some_file>
`````
3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?
`````
systemd - подсистема инициализации и управления службами в Linux
`````
4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?
`````
vagrant@vagrant:~$ who vagrant tty1
vagrant  pts/0        2022-02-06 19:03 (10.0.62.251)
ls /root 2>/dev/pts/0
`````
5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? 
`````
vagrant@vagrant:~$ echo new_line > test1
vagrant@vagrant:~$ cat test1
new_line
vagrant@vagrant:~$ cat test2
cat: test2: No such file or directory
vagrant@vagrant:~$  cat < test1 > test2
vagrant@vagrant:~$ cat test2
new_line
vagrant@vagrant:~$

`````
6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY?
Сможете ли вы наблюдать выводимые данные?
`````
root@vagrant:~# echo Hello World! > /dev/pts/1
root@vagrant:~#
---------------
vagrant@vagrant:~$ ps -a
    PID TTY          TIME CMD
   1101 pts/1    00:00:00 ps
vagrant@vagrant:~$ Hello World!
`````
7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5?
Почему так происходит?
`````
echo netology > /proc/$$/fd/5 netology
создастся файловый дескриптор 5, который будет выводиться в 1(консоль). Пишем слово netology в дескриптор 5, 
он выводит в &1 (консоль)
`````
8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение
stdout на pty? 
`````
vagrant@vagrant:~$ ls -l /root 9>&2 2>&1 1>&9 |grep denied -c
1
`````
9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?
`````
переменные системного окружения env
Так же получить результат можно с помощью printenv и env
`````
10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.
`````
/proc//cmdline - полный путь до исполняемого файла процесса [PID] (строка 231) 
/proc//exe - содержит ссылку до файла запущенного для процесса [PID], cat выведет содержимое запущенного файла, запуск 
этого файла, запустит еще одну копию 
самого файла (строка 285)
`````
11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.
`````
sse4_1 sse4_2
`````
12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. 
Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:
vagrant@netology1:~$ ssh localhost 'tty'
not a tty
Почитайте, почему так происходит, и как изменить поведение.
`````
vagrant@vagrant:~$ ssh localhost 'tty'
The authenticity of host 'localhost (127.0.0.1)' can't be established.
ECDSA key fingerprint is SHA256:RztZ38lZsUpiN3mQrXHa6qtsUgsttBXWJibL2nAiwdQ.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'localhost' (ECDSA) to the list of known hosts.
vagrant@localhost's password:
not a tty
vagrant@vagrant:~$

При задании такой команды tty по ssh не создается интерактивный сеанс (нет потоков stdin,stdout,stderr).
Принудително можно создать псевдотерминал внутри ssh сессии добавлением опции -t.
Более того, при добавлении параметра -t приходит ответ от закрытого удаленного сеанса stdout.

vagrant@vagrant:~$ ssh localhost -t 'tty'
vagrant@localhost's password:
/dev/pts/1
Connection to localhost closed.
vagrant@vagrant:~$

`````
13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это,
воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной
SSH-сессии.
`````
root@vagrant:~# ps -a
    PID TTY          TIME CMD
   2048 tty1     00:00:00 bash
   2510 pts/2    00:00:55 reptyr
   2514 pts/1    00:00:00 nano
   2519 pts/1    00:00:00 su
   2521 pts/1    00:00:00 bash
   2587 pts/3    00:00:00 su
   2589 pts/3    00:00:00 bash
   2597 pts/3    00:00:00 ping
   2598 pts/1    00:00:00 ps
root@vagrant:~# reptyr 2597
64 bytes from 8.8.8.8: icmp_seq=15 ttl=108 time=18.8 ms
64 bytes from 8.8.8.8: icmp_seq=16 ttl=108 time=19.0 ms
64 bytes from 8.8.8.8: icmp_seq=17 ttl=108 time=19.3 ms
64 bytes from 8.8.8.8: icmp_seq=18 ttl=108 time=16.8 ms
64 bytes from 8.8.8.8: icmp_seq=19 ttl=108 time=18.7 ms
64 bytes from 8.8.8.8: icmp_seq=20 ttl=108 time=16.9 ms

Для тестирования процесса был запущен ping в ssh сессии из под рут, далее была открыта
вторая ssh сессия и произведен перехват с помощью reptyr 2597.
При попытке перехватить процесс получаю ошибку " unable to attach to pid <pid>: permission denied"
При этом если из под обычного пользователя (vagrant) запустить nano, то данный процесс перехватывается сессией с root 
через reptyr -T <pid>, так же происходит перелогин с root в vagrant
`````
14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как
перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной 
проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте что делает команда tee и почему в
отличие от sudo echo команда с sudo tee будет работать.
`````
vagrant@vagrant:~$ sudo echo string > /root/new_file
bash: /root/new_file: Permission denied
vagrant@vagrant:~$ sudo echo string | sudo tee /root/new_file
string
vagrant@vagrant:~$ su
Password:
root@vagrant:/home/vagrant#  cat /root/new_file
string
root@vagrant:/home/vagrant#

Команда tee производит запись вывода любой команды из консоль и в один или несколько файлов.
В данном примере работает так как tee запущен с помощью sudo (права сууперпользователя), и у него есть права на запись 
в домашнюю директорию root-а.
`````