# devops-netology
### performed by Kirill Karagodin
#### HW3.6 Компьютерные сети (лекция 1).
1. Работа c HTTP через телнет.
``````
root@VB-micraPC:/# telnet stackoverflow.com 80
Trying 151.101.193.69...
Connected to stackoverflow.com.
Escape character is '^]'.
GET /questions HTTP/1.0
HOST: stackoverflow.com

HTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 486fea76-0bdd-42f4-ac6a-ee3270a063a6
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Fri, 25 Feb 2022 14:28:21 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-bma1646-BMA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1645799302.575932,VS0,VE101
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=3a6f48b3-b0ce-f0f8-07aa-6e7f11b6a609; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly

Connection closed by foreign host.
root@VB-micraPC:/#

HTTP/1.1 301 Moved Permanently - означает что эта страница перемещена и переброс будет произведен 
по https://stackoverflow.com/questions. Данная страница не кэшируется и кэш расчитывается заново при каждом соединении.
``````
2. Повторите задание 1 в браузере, используя консоль разработчика F12.

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/HW_3.5/net.JPG)
``````
Дольше всего обробатывается GET апрос 301 (редирект)
``````
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/HW_3.5/net-1.jpg)

3. Какой IP адрес у вас в интернете?
``````
95.31.185.56
``````
4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой whois
``````
IP адрес пренадлежит Би-Лайн (бывшая Carbina Telecom)
AS8402
root@VB-micraPC:/# whois -l 95.31.185.56

inetnum:        95.31.152.0 - 95.31.255.255
netname:        BEELINE-BROADBAND
descr:          Dynamic IP Pool for Broadband Customers
country:        RU
admin-c:        CORB1-RIPE
tech-c:         CORB1-RIPE
status:         ASSIGNED PA
mnt-by:         RU-CORBINA-MNT
created:        2011-08-31T11:43:56Z
last-modified:  2011-10-24T07:18:07Z
source:         RIPE

role:           CORBINA TELECOM Network Operations
address:        PAO Vimpelcom - CORBINA TELECOM/Internet Network Operations
address:        111250 Russia Moscow Krasnokazarmennaya, 12
phone:          +7 495 755 5648
fax-no:         +7 495 787 1990
remarks:        -----------------------------------------------------------
remarks:        Feel free to contact Corbina Telecom NOC to
remarks:        resolve networking problems related to Corbina
remarks:        -----------------------------------------------------------
remarks:        User support, general questions: support@corbina.net
remarks:        Routing, peering, security: ipnoc@corbina.net
remarks:        Report spam and abuse: abuse@beeline.ru
remarks:        Mail and news: postmaster@corbina.net
remarks:        DNS: hostmaster@corbina.net
remarks:        Engineering Support ES@beeline.ru
remarks:        -----------------------------------------------------------
admin-c:        SVNT1-RIPE
tech-c:         SVNT2-RIPE
nic-hdl:        CORB1-RIPE
mnt-by:         RU-CORBINA-MNT
abuse-mailbox:  abuse-b2b@beeline.ru
created:        1970-01-01T00:00:00Z
last-modified:  2021-04-12T10:52:26Z
source:         RIPE # Filtered

% Information related to '95.31.185.0/24AS8402'

route:          95.31.185.0/24
descr:          RU-CORBINA-BROADBAND-POOL10
origin:         AS8402
mnt-by:         RU-CORBINA-MNT
created:        2011-09-26T15:02:18Z
last-modified:  2011-09-26T15:02:18Z
source:         RIPE # Filtered
``````
5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS?
Воспользуйтесь утилитой traceroute
``````
root@VB-micraPC:/# traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (10.0.62.1)  0.746 ms  0.753 ms  0.500 ms
 2  100.119.0.1 (100.119.0.1)  1.127 ms  0.826 ms  0.842 ms
 3  * * *
 4  85.21.224.191 (85.21.224.191)  13.522 ms  13.250 ms  12.977 ms
 5  108.170.250.130 (108.170.250.130)  2.407 ms  2.133 ms 108.170.250.83 (108.170.250.83)  1.563 ms
 6  142.251.71.194 (142.251.71.194)  15.001 ms 142.251.49.24 (142.251.49.24)  15.459 ms *
 7  72.14.238.168 (72.14.238.168)  29.569 ms 172.253.65.82 (172.253.65.82)  14.589 ms 108.170.232.251 (108.170.232.251)  16.090 ms
 8  216.239.63.129 (216.239.63.129)  16.764 ms 216.239.62.107 (216.239.62.107)  19.412 ms 142.250.238.181 (142.250.238.181)  18.647 ms
 9  * * *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  dns.google (8.8.8.8)  15.488 ms  14.840 ms  15.627 ms

``````
6. Повторите задание 5 в утилите mtr. На каком участке наибольшая задержка - delay?
``````
На между 7-м и 8-м хопами фиксируется самое высокое среднее время задержки (AVG 18.4 - 20.6)
                             My traceroute  [v0.93]
VB-micraPC (10.0.62.248)                               2022-02-25T16:46:25+0300
Keys:  Help   Display mode   Restart statistics   Order of fields   quit
                                       Packets               Pings
 Host                                Loss%   Snt   Last   Avg  Best  Wrst StDev
 1. _gateway                          0.0%    11    0.8   0.8   0.7   0.8   0.0
 2. 100.119.0.1                       0.0%    11    1.3   1.3   1.1   1.7   0.1
 3. (waiting for reply)
 4. 85.21.224.191                     0.0%    10    5.9   2.1   1.6   5.9   1.3
 5. 108.170.250.113                   0.0%    10    8.0   3.0   1.7   8.0   2.1
 6. 216.239.51.32                    60.0%    10   17.4  19.5  17.3  25.8   4.2
 7. 172.253.66.110                    0.0%    10   18.1  18.4  18.1  19.7   0.5
 8. 74.125.253.147                    0.0%    10   20.9  20.6  19.7  21.1   0.5
 9. (waiting for reply)
10. (waiting for reply)
11. (waiting for reply)
12. (waiting for reply)
13. (waiting for reply)
14. (waiting for reply)
15. (waiting for reply)
16. (waiting for reply)
17. (waiting for reply)
18. dns.google                       30.0%    10   19.2  18.4  16.6  19.4   1.3
``````
7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой dig
``````
root@VB-micraPC:/# dig dns.google A NS
;; Warning, extra type option

; <<>> DiG 9.16.1-Ubuntu <<>> dns.google A NS
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 60917
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;dns.google.                    IN      NS

;; ANSWER SECTION:
dns.google.             7136    IN      NS      ns4.zdns.google.
dns.google.             7136    IN      NS      ns1.zdns.google.
dns.google.             7136    IN      NS      ns3.zdns.google.
dns.google.             7136    IN      NS      ns2.zdns.google.

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Пт фев 25 16:51:11 MSK 2022
;; MSG SIZE  rcvd: 116

``````
8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой dig
``````
dig -x 216.239.32.114 ns1.zdns.google.
dig -x 216.239.36.114 ns3.zdns.google.
dig -x 216.239.38.114 ns4.zdns.google.
dig -x 216.239.34.114 ns2.zdns.google.

root@VB-micraPC:/# dig -x 216.239.32.114 ns1.zdns.google.

; <<>> DiG 9.16.1-Ubuntu <<>> -x 216.239.32.114 ns1.zdns.google.
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 41998
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;114.32.239.216.in-addr.arpa.   IN      PTR

;; ANSWER SECTION:
114.32.239.216.in-addr.arpa. 7028 IN    PTR     ns1.zdns.google.

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Пт фев 25 17:20:14 MSK 2022
;; MSG SIZE  rcvd: 85

;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 531
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;ns1.zdns.google.               IN      A

;; ANSWER SECTION:
ns1.zdns.google.        7028    IN      A       216.239.32.114

;; Query time: 0 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Пт фев 25 17:20:14 MSK 2022
;; MSG SIZE  rcvd: 60


``````