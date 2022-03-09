# devops-netology
### performed by Kirill Karagodin
#### HW3.9 3.9. Элементы безопасности информационных систем

1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей. 
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/HW_3.9/bitwarden.JPG)
2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через
Google authenticator OTP. 
````
После включения двухфакторной авторизвции при заедении новой пары логи-пароль в Bitwarden появляется поля для ввода 
ОТР кода
````
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/HW_3.9/bitwarden2.JPG)
3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.
````
Генерация сертификата:
root@VB-micraPC:/home/micra# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=RU/ST=Moscow/L=Netology/O=DevSys_Karagodin/OU=Org/CN=10.0.62.248"
Generating a RSA private key
..........................+++++
......................................+++++
writing new private key to '/etc/ssl/private/apache-selfsigned.key'

````
````
root@VB-micraPC:~# cat /etc/apache2/sites-available/default-ssl.conf
<IfModule mod_ssl.c>
        <VirtualHost _default_:443>
                ServerAdmin karagodin.kirill.a@ya.ru
                ServerName 10.0.62.248
                DocumentRoot /var/www/html

                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined

                SSLEngine on

                SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

                <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                SSLOptions +StdEnvVars
                </FilesMatch>
                <Directory /usr/lib/cgi-bin>
                                SSLOptions +StdEnvVars
                </Directory>

        </VirtualHost>
</IfModule>
````
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/HW_3.9/web.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/HW_3.9/cert.JPG)

4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос,
РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).
````
root@VB-micraPC:/home/micra# ./testssl.sh -U --sneaky  https://pleer.ru

ATTENTION: No cipher mapping file found!
Please note from 2.9 on testssl.sh needs files in "$TESTSSL_INSTALL_DIR/etc/" to function correctly.

Type "yes" to ignore this warning and proceed at your own risk --> yes

ATTENTION: No TLS data file found -- needed for socket-based handshakes
Please note from 2.9 on testssl.sh needs files in "$TESTSSL_INSTALL_DIR/etc/" to function correctly.

Type "yes" to ignore this warning and proceed at your own risk --> yes


###########################################################
    testssl.sh       3.1dev from https://testssl.sh/dev/

      This program is free software. Distribution and
             modification under GPLv2 permitted.
      USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!

       Please file bugs @ https://testssl.sh/bugs/

###########################################################

 Using "OpenSSL 1.1.1f  31 Mar 2020" [~0 ciphers]
 on VB-micraPC:/usr/bin/openssl
 (built: "Nov 24 13:20:48 2021", platform: "debian-amd64")


 Start 2022-03-09 20:04:27        -->> 178.248.234.40:443 (pleer.ru) <<--

 rDNS (178.248.234.40):  --
 Testing with pleer.ru:443 only worked using /usr/bin/openssl.
 Test results may be somewhat better if the --ssl-native option is used.
 Type "yes" to proceed and accept false negatives or positives --> yes
 Service detected:       HTTP


 Testing vulnerabilities

 Heartbleed (CVE-2014-0160)                Error setting TLSv1.3 ciphersuites
139919253108032:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
 ROBOT                                     Error setting TLSv1.3 ciphersuites
140287192425792:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139887423579456:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139693529691456:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
140264475387200:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139666185643328:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139736533333312:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139644052264256:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139844549707072:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139858692592960:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139809226220864:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
Error setting TLSv1.3 ciphersuites
139662253241664:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     not vulnerable (OK)
 CRIME, TLS (CVE-2012-4929)                test failed (couldn't connect)
 BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK), no SSLv3 support
 TLS_FALLBACK_SCSV (RFC 7507)              test failed (couldn't connect)
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=C58194212B8EAB437678D9D8871E13B1584F9E96BCC0EB230100AE1513EA0A12 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no DH key detected with <= TLS 1.2
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     Error setting TLSv1.3 ciphersuites
140520092562752:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    Error setting TLSv1.3 ciphersuites
140309926282560:error:1426E0B9:SSL routines:ciphersuite_cb:no cipher match:../ssl/ssl_ciph.c:1294:
not vulnerable (OK) - ARIA, CHACHA or CCM ciphers found
 RC4 (CVE-2013-2566, CVE-2015-2808)        Local problem: No RC4 Ciphers configured in /usr/bin/openssl


 Done 2022-03-09 20:06:23 [ 121s] -->> 178.248.234.40:443 (pleer.ru) <<--


root@VB-micraPC:/home/micra#

````
5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер.
Подключитесь к серверу по SSH-ключу.
````
root@VB-micraPC:/home/micra# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa):
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:VHjFzAPQxQYk9mihjZodr9ysCtoVnwgC6eBySzCOojg root@VB-micraPC
The key's randomart image is:
+---[RSA 3072]----+
|        ===Xo    |
| .     =.*o B    |
|*     + =... .   |
|Bo   + =         |
|=++ + . S        |
|=+ o = =         |
|E o o = o        |
| + o   .         |
|. . ...          |
+----[SHA256]-----+
root@VB-micraPC:/home/micra# cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCx1JJbgwcfTEQWeDcDQBDrDchGssH9U52McrH4FFtVnas8jgHr05oBE6vmNM7lh57UYmmxQscgzBQZlOpFzPU2m1GHbP1nUvLUUek45lKxk0fi/g1Bhz7oAMm7KMSpzjk1XQfVPN7C8UGS/5owEqwB3JdK84Qh5IWR6AE165oETq6rIXVJ1bUkj1D75zMB52aM9tVckTJJaWv1lpbjcbLH185+0huFlgYn8NNTb9iy7XGrmNlAX3Q4roni8dzW+IZ4TjlRav3G9vsUk358mfH/yjbuJ9A1U7MRxHWsg2Kj4ROoM93VfIBhsMi7+FUclNnCIHHiKVHfTX0JG9LjKcn3eConRg+9mCo4fWhusd9MehejODrfg8Oy2cYUa6GDZ+CzudQTVypjz4IXxkSyC0LngKEWDF/VQS0JFpwaLzMwEnZ/R32X3DIv4naO9JkEKICcIN3iud0MyJmw1X/tiqajhKAKzcLja+lLJKT5OB5bg2hJQPeaqtVeNyt7YOKwQJk= root@VB-micraPC
root@VB-micraPC:/home/micra# ssh-copy-id root@VB-micraPC
/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/root/.ssh/id_rsa.pub"
The authenticity of host 'vb-micrapc (127.0.1.1)' can't be established.
ECDSA key fingerprint is SHA256:8J30d+xUyPtN9+nqL/paZwyT+5mY+/Zst4okzsRAIbg.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
root@vb-micrapc's password:

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'root@VB-micraPC'"
and check to make sure that only the key(s) you wanted were added.

root@VB-micraPC:/home/micra#

````
````
Пример входа на сервера с Windows
C:\Users\Mojno_Vse>ssh root@VB-micraPC
The authenticity of host 'vb-micrapc (fe80::c06a:a5f1:660:d341%6)' can't be established.
ECDSA key fingerprint is SHA256:8J30d+xUyPtN9+nqL/paZwyT+5mY+/Zst4okzsRAIbg.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added 'vb-micrapc,fe80::c06a:a5f1:660:d341%6' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.13.0-35-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

9 updates can be applied immediately.
Чтобы просмотреть дополнительные обновления выполните: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Wed Mar  9 21:45:34 2022 from 10.0.62.251
root@VB-micraPC:~#
````
6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный
сервер осуществлялся по имени сервера.
````
copy id_rsa key_key
````
Для входа на удаленный сервер по имени сервера (в моем случае ubuntu), создаем файл config на Windows машине
в директории C:\Users\[user]\.ssh\ c содержимым:
````
Host ubuntu
  HostName 10.0.62.248
  IdentityFile ~/.ssh/key_rsa
  User root
  Port 22
````
Проверяем вход:
````
C:\Users\Mojno_Vse>ssh ubuntu
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.13.0-35-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

9 updates can be applied immediately.
Чтобы просмотреть дополнительные обновления выполните: apt list --upgradable

Your Hardware Enablement Stack (HWE) is supported until April 2025.
Last login: Wed Mar  9 21:50:08 2022 from 10.0.62.251
root@VB-micraPC:~#
````
7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.
````
root@VB-micraPC:~# tcpdump -c 100 -i enp0s3
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on enp0s3, link-type EN10MB (Ethernet), capture size 262144 bytes
18:37:51.615882 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 802986837:802986965, ack 4246274874, win 501, length 128
18:37:51.616374 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 128:192, ack 1, win 501, length 64
18:37:51.616638 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 192, win 4103, length 0
18:37:51.616741 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 192:320, ack 1, win 501, length 128
18:37:51.617043 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 320:384, ack 1, win 501, length 64
18:37:51.617291 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 384, win 4103, length 0
18:37:51.618618 IP VB-micraPC.50256 > ns4.corbina.net.domain: 1439+ [1au] PTR? 251.62.0.10.in-addr.arpa. (53)
18:37:51.621147 IP ns4.corbina.net.domain > VB-micraPC.50256: 1439 NXDomain* 0/1/1 (112)
18:37:51.621240 IP VB-micraPC.50256 > ns4.corbina.net.domain: 1439+ PTR? 251.62.0.10.in-addr.arpa. (42)
18:37:51.623465 IP ns4.corbina.net.domain > VB-micraPC.50256: 1439 NXDomain* 0/1/0 (101)
18:37:51.623762 IP VB-micraPC.34122 > ns4.corbina.net.domain: 5213+ [1au] PTR? 248.62.0.10.in-addr.arpa. (53)
18:37:51.625996 IP ns4.corbina.net.domain > VB-micraPC.34122: 5213 NXDomain* 0/1/1 (112)
18:37:51.626091 IP VB-micraPC.34122 > ns4.corbina.net.domain: 5213+ PTR? 248.62.0.10.in-addr.arpa. (42)
18:37:51.628703 IP ns4.corbina.net.domain > VB-micraPC.34122: 5213 NXDomain* 0/1/0 (101)
18:37:51.629038 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 384:576, ack 1, win 501, length 192
18:37:51.629352 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 576:640, ack 1, win 501, length 64
18:37:51.629604 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 640, win 4102, length 0
18:37:51.629707 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 640:800, ack 1, win 501, length 160
18:37:51.629996 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 800:864, ack 1, win 501, length 64
18:37:51.630237 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 864, win 4101, length 0
18:37:51.630335 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 864:1008, ack 1, win 501, length 144
18:37:51.630625 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 1008:1072, ack 1, win 501, length 64
18:37:51.630864 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 1072, win 4106, length 0
18:37:51.630963 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 1072:1232, ack 1, win 501, length 160
18:37:51.631373 IP VB-micraPC.52559 > ns4.corbina.net.domain: 1048+ [1au] PTR? 5.192.21.85.in-addr.arpa. (53)
18:37:51.631688 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 1232:1488, ack 1, win 501, length 256
18:37:51.631930 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 1488, win 4104, length 0
18:37:51.633777 IP ns4.corbina.net.domain > VB-micraPC.52559: 1048 1/0/1 PTR ns4.corbina.net. (82)
18:37:51.634101 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 1488:3792, ack 1, win 501, length 2304
18:37:51.634360 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 3792, win 4106, length 0
18:37:51.634484 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 3792:4064, ack 1, win 501, length 272
18:37:51.634788 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 4064:4224, ack 1, win 501, length 160
18:37:51.635027 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 4224, win 4104, length 0
18:37:51.635136 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 4224:4480, ack 1, win 501, length 256
18:37:51.635441 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 4480:4640, ack 1, win 501, length 160
18:37:51.635681 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 4640, win 4102, length 0
18:37:51.635789 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 4640:4896, ack 1, win 501, length 256
18:37:51.636086 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 4896:5056, ack 1, win 501, length 160
18:37:51.636457 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 5056, win 4101, length 0
18:37:51.636569 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 5056:5312, ack 1, win 501, length 256
18:37:51.636865 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 5312:5472, ack 1, win 501, length 160
18:37:51.637105 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 5472, win 4106, length 0
18:37:51.637210 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 5472:5728, ack 1, win 501, length 256
18:37:51.637513 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 5728:5888, ack 1, win 501, length 160
18:37:51.637752 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 5888, win 4104, length 0
18:37:51.637857 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 5888:6144, ack 1, win 501, length 256
18:37:51.638152 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 6144:6304, ack 1, win 501, length 160
18:37:51.638392 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 6304, win 4103, length 0
18:37:51.638498 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 6304:6560, ack 1, win 501, length 256
18:37:51.638796 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 6560:6720, ack 1, win 501, length 160
18:37:51.639035 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 6720, win 4101, length 0
18:37:51.639140 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 6720:6976, ack 1, win 501, length 256
18:37:51.639464 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 6976:7136, ack 1, win 501, length 160
18:37:51.639703 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 7136, win 4106, length 0
18:37:51.639808 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 7136:7392, ack 1, win 501, length 256
18:37:51.640105 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 7392:7552, ack 1, win 501, length 160
18:37:51.640473 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 7552, win 4104, length 0
18:37:51.640600 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 7552:7808, ack 1, win 501, length 256
18:37:51.640914 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 7808:7968, ack 1, win 501, length 160
18:37:51.641167 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 7968, win 4103, length 0
18:37:51.641286 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 7968:8224, ack 1, win 501, length 256
18:37:51.641599 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 8224:8384, ack 1, win 501, length 160
18:37:51.641851 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 8384, win 4101, length 0
18:37:51.641852 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [P.], seq 1:161, ack 8384, win 4101, length 160
18:37:51.642252 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 8384:8800, ack 161, win 501, length 416
18:37:51.642563 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 8800:8976, ack 161, win 501, length 176
18:37:51.642812 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 8976, win 4106, length 0
18:37:51.642922 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 8976:9248, ack 161, win 501, length 272
18:37:51.643256 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 9248:9424, ack 161, win 501, length 176
18:37:51.643512 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 9424, win 4104, length 0
18:37:51.643625 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 9424:9696, ack 161, win 501, length 272
18:37:51.643930 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 9696:9872, ack 161, win 501, length 176
18:37:51.644187 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 9872, win 4102, length 0
18:37:51.644427 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 9872:10144, ack 161, win 501, length 272
18:37:51.644735 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 10144:10320, ack 161, win 501, length 176
18:37:51.645002 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 10320, win 4101, length 0
18:37:51.645170 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 10320:10592, ack 161, win 501, length 272
18:37:51.645512 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 10592:10768, ack 161, win 501, length 176
18:37:51.645761 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 10768, win 4106, length 0
18:37:51.645874 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 10768:11040, ack 161, win 501, length 272
18:37:51.646230 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 11040:11216, ack 161, win 501, length 176
18:37:51.646485 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 11216, win 4104, length 0
18:37:51.646596 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 11216:11488, ack 161, win 501, length 272
18:37:51.646901 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 11488:11664, ack 161, win 501, length 176
18:37:51.647150 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 11664, win 4102, length 0
18:37:51.647262 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 11664:11936, ack 161, win 501, length 272
18:37:51.647565 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 11936:12112, ack 161, win 501, length 176
18:37:51.647810 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 12112, win 4101, length 0
18:37:51.647918 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 12112:12384, ack 161, win 501, length 272
18:37:51.648223 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 12384:12560, ack 161, win 501, length 176
18:37:51.648707 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 12560, win 4106, length 0
18:37:51.648715 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 12560:12736, ack 161, win 501, length 176
18:37:51.649232 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 12736:13008, ack 161, win 501, length 272
18:37:51.649494 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 13008, win 4104, length 0
18:37:51.649609 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 13008:13280, ack 161, win 501, length 272
18:37:51.649929 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 13280:13456, ack 161, win 501, length 176
18:37:51.650188 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 13456, win 4102, length 0
18:37:51.650302 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 13456:13728, ack 161, win 501, length 272
18:37:51.650620 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 13728:13904, ack 161, win 501, length 176
18:37:51.650875 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 13904, win 4101, length 0
100 packets captured
100 packets received by filter
0 packets dropped by kernel
root@VB-micraPC:~#
````
Записываем в файл 0001.pcap
````
root@VB-micraPC:~# tcpdump -w 0001.pcap -i enp0s3
tcpdump: listening on enp0s3, link-type EN10MB (Ethernet), capture size 262144 bytes
^C116 packets captured
119 packets received by filter
0 packets dropped by kernel
root@VB-micraPC:~# tcpdump -r 0001.pcap
reading from file 0001.pcap, link-type EN10MB (Ethernet)
18:40:05.632257 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 803003829:803003893, ack 4246277658, win 501, length 64
18:40:05.632516 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 64:192, ack 1, win 501, length 128
18:40:05.632770 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 64, win 4101, length 0
18:40:05.632867 IP VB-micraPC.ssh > 10.0.62.251.49187: Flags [P.], seq 192:256, ack 1, win 501, length 64
18:40:05.633118 IP 10.0.62.251.49187 > VB-micraPC.ssh: Flags [.], ack 256, win 4100, length 0
18:40:06.295618 IP 10.0.62.251.54915 > 10.0.62.255.54915: UDP, length 263
18:40:07.293761 IP 10.0.62.251.54915 > 10.0.62.255.54915: UDP, length 263
18:40:07.396009 STP 802.1w, Rapid STP, Flags [Learn, Forward], bridge-id 8000.6c:3b:6b:07:cb:95.8003, length 43
18:40:08.291041 IP 10.0.62.251.54915 > 10.0.62.255.54915: UDP, length 263
18:40:09.290193 IP 10.0.62.251.54915 > 10.0.62.255.54915: UDP, length 263
18:40:09.398325 STP 802.1w, Rapid STP, Flags [Learn, Forward], bridge-id 8000.6c:3b:6b:07:cb:95.8003, length 43
18:40:10.288697 IP 10.0.62.251.54915 > 10.0.62.255.54915: UDP, length 263
18:40:11.297193 IP 10.0.62.251.54915 > 10.0.62.255.54915: UDP, length 263
18:40:11.404484 STP 802.1w, Rapid STP, Flags [Learn, Forward], bridge-id 8000.6c:3b:6b:07:cb:95.8003, length 43
18:40:12.295877 IP 10.0.62.251.54915 > 10.0.62.255.54915: UDP, length 263
18:40:13.295802 IP 10.0.62.251.54915 > 10.0.62.255.54915: UDP, length 263

````