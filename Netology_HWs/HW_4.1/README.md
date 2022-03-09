# devops-netology
### performed by Kirill Karagodin
#### Домашнее задание к занятию "4.1. Командная оболочка Bash: Практические навыки"

## Обязательная задача 1

Есть скрипт:
```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c,d,e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | bash воспринимает это присвоение как текст |
| `d`  | 1+2  | bash воспринимает это присвоение как текст, подставив туда числовые значения переменнных |
| `e`  | 3  | bash производит вычисления, подставляя значения в переменную. $(($a+$b)) стандартный конструктив для обертки математических операций |


## Обязательная задача 2
На нашем локальном сервере упал сервис и мы написали скрипт, который постоянно проверяет его доступность, записывая дату
проверок до тех пор, пока сервис не станет доступным (после чего скрипт должен завершиться). В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на Жёстком Диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:
```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```
Ответ
```
-не написана строка ввода #!/bin/bash
-нет закрывающей скобки в конструктиве условия while, должно быть ((1==1))
```
### Ваш скрипт:
```bash
#!/bin/bash
while ((1==1))
do
        curl http://localhost:4346
        if (($? != 0))
        then
                date >> curl.log
        else
                break
        fi

done
```

## Обязательная задача 3
Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` 
по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:
```bash
echo "" > host.log
a=("192.168.0.1" "173.194.222.113" "87.250.250.242")
for i in ${a[@]}; do
  for j in {1..5}; do
    curl http://$i:80 -m 1
    if (($? != 0)); then
      echo "error " $i >>host.log
    else
      echo "OK " $i >>host.log
    fi
  done
done
```
Результат проверки:
```
root@VB-micraPC:/opt# ./test.sh
curl: (28) Connection timed out after 1000 milliseconds
curl: (28) Connection timed out after 1000 milliseconds
curl: (28) Connection timed out after 1000 milliseconds
curl: (28) Connection timed out after 1000 milliseconds
curl: (28) Connection timed out after 1001 milliseconds
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
root@VB-micraPC:/opt# ll
итого 16
drwxr-xr-x  2 root root 4096 мар 10 00:12 ./
drwxr-xr-x 20 root root 4096 фев 21 17:00 ../
-rw-r--r--  1 root root  291 мар 10 00:12 host.log
-rwxr-xr-x  1 root root  285 мар 10 00:06 test.sh*
root@VB-micraPC:/opt# cat host.log

error  192.168.0.1
error  192.168.0.1
error  192.168.0.1
error  192.168.0.1
error  192.168.0.1
OK  173.194.222.113
OK  173.194.222.113
OK  173.194.222.113
OK  173.194.222.113
OK  173.194.222.113
OK  87.250.250.242
OK  87.250.250.242
OK  87.250.250.242
OK  87.250.250.242
OK  87.250.250.242
root@VB-micraPC:/opt#

```
## Обязательная задача 4
Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется 
недоступным. Если любой из узлов недоступен - IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:
```bash
#!/bin/bash
echo "" > error.log
echo "" > up.log
a=("173.194.222.113" "87.250.250.242" "192.168.0.1")
while ((1 == 1)); do
 for i in ${a[@]}; do
    curl http://$i:80 -m 1
    if (($? != 0)); then
      echo "error " $i >>error.log
      break 2
    else
      echo "OK " $i >>up.log
    fi
 done
done

```
Результат прогона:
```
root@VB-micraPC:/opt# nano test_error.sh
root@VB-micraPC:/opt# ./test_error.sh
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>301 Moved</TITLE></HEAD><BODY>
<H1>301 Moved</H1>
The document has moved
<A HREF="http://www.google.com/">here</A>.
</BODY></HTML>
curl: (28) Connection timed out after 1002 milliseconds
root@VB-micraPC:/opt# ll
итого 28
drwxr-xr-x  2 root root 4096 мар 10 00:24 ./
drwxr-xr-x 20 root root 4096 фев 21 17:00 ../
-rw-r--r--  1 root root   20 мар 10 00:24 error.log
-rw-r--r--  1 root root  291 мар 10 00:12 host.log
-rwxr-xr-x  1 root root  302 мар 10 00:24 test_error.sh*
-rwxr-xr-x  1 root root  285 мар 10 00:06 test.sh*
-rw-r--r--  1 root root   40 мар 10 00:24 up.log
root@VB-micraPC:/opt# cat up.log

OK  173.194.222.113
OK  87.250.250.242
root@VB-micraPC:/opt# cat error.log

error  192.168.0.1
root@VB-micraPC:/opt#
```