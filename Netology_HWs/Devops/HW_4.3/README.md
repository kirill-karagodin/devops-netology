# devops-netology
### performed by Kirill Karagodin
#### HW4.3 Языки разметки JSON и YAML.
## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:
```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

Нарушен синтаксис написания json: 
- внутри массива элементы не разделены запятой
- внутри пары ключ-значения ("ip") потеряны кавычки
```python
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            },
            { "name" : "second",
            "type" : "proxy",
            "ip" : "71.78.22.43"
            }
        ]
  }
```


## Обязательная задача 2
В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3
import os.path
import socket
import json
import yaml


hosts = ["drive.google.com", "mail.google.com", "google.com"]
last_check_filepath = 'myfile.txt'
json_file = 'myfile.json'
yaml_file = 'myfile.yaml'
delimiter = ";"


def remove_file(filename):
    try:
        os.remove(filename)
    except OSError:
        pass


def load_last_check():
    ip_by_host = {}
    if os.path.isfile(last_check_filepath):
        file = open(last_check_filepath, 'r')
        lines = file.readlines()
        for line in lines:
            args = line.split(delimiter)
            ip_by_host[args[0]] = args[1].replace("\n", "")
    return ip_by_host


def write_to_file(ip_by_host):
    remove_file(last_check_filepath)
    fp = open(last_check_filepath, 'w')
    for (host, port) in ip_by_host.items():
        fp.write(host + delimiter + port + "\n")
    fp.close()

def write_to_json(ip_by_host):
    remove_file(json_file)
    fp = open(json_file, 'w')
    for (host, port) in ip_by_host.items():
        js = json.dumps({host : port})
        fp.write(js+"\n")
    fp.close()

def write_to_yaml(ip_by_host):
    remove_file(yaml_file)
    fp = open(yaml_file, 'w')
    for (host, port) in ip_by_host.items():
        ym = yaml.dump({host: port})
        fp.write("- "+ym)
    fp.close()


ip_by_host_last = load_last_check()
ip_by_host = {}

for host in hosts:
    ip = socket.gethostbyname(host)
    ip_by_host[host] = ip
    print(host + ' ' + ip)
    oldIp = ip_by_host_last.get(host)
    if oldIp and oldIp != ip:
        print("Error oldip[" + oldIp + "] != new ip[" + ip + "] for host " + host)

write_to_file(ip_by_host)
write_to_json(ip_by_host)
write_to_yaml(ip_by_host)
```

### Вывод скрипта при запуске при тестировании:
```
root@VB-micraPC:/opt/test# python3 work4.py
drive.google.com 173.194.73.194
mail.google.com 64.233.164.19
google.com 173.194.73.138
root@VB-micraPC:/opt/test# ll
итого 24
drwxr-xr-x 2 root root 4096 мар 26 17:30 ./
drwxr-xr-x 4 root root 4096 мар 22 17:19 ../
-rw-r--r-- 1 root root  109 мар 26 17:25 myfile.json
-rw-r--r-- 1 root root   88 мар 26 17:25 myfile.txt
-rw-r--r-- 1 root root   97 мар 26 17:25 myfile.yaml
-rw-r--r-- 1 root root 1701 мар 26 17:25 work4.py

```

### json-файл(ы), который(е) записал ваш скрипт:
```json
root@VB-micraPC:/opt/test# cat myfile.json
{"drive.google.com": "173.194.73.194"}
{"mail.google.com": "64.233.164.19"}
{"google.com": "173.194.73.138"}

```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
root@VB-micraPC:/opt/test# cat myfile.yaml
- drive.google.com: 173.194.73.194
- mail.google.com: 64.233.164.19
- google.com: 173.194.73.138
root@VB-micraPC:/opt/test#

```