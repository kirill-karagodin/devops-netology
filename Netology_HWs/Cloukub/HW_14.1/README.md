# devops-netology
### performed by Kirill Karagodin
#### HW 14.1 Создание и использование секретов

#### Задача 1: Работа с секретами через утилиту kubectl в установленном minikube

Выполните приведённые ниже команды в консоли, получите вывод команд. Сохраните задачу 1 как справочный материал.

Как создать секрет?
````bash
openssl genrsa -out cert.key 4096
openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
kubectl create secret tls domain-cert --cert=certs/cert.crt --key=certs/cert.key
````
Как просмотреть список секретов?
````bash
kubectl get secrets
kubectl get secret
````
Как просмотреть секрет?
````bash
kubectl get secret domain-cert
kubectl describe secret domain-cert
````
Как получить информацию в формате YAML и/или JSON?
````bash
kubectl get secret domain-cert -o yaml
kubectl get secret domain-cert -o json
````
Как выгрузить секрет и сохранить его в файл?
````bash
kubectl get secrets -o json > secrets.json
kubectl get secret domain-cert -o yaml > domain-cert.yml
````
Как удалить секрет?
````bash
kubectl delete secret domain-cert
````
Как загрузить секрет из файла?
````bash
kubectl apply -f domain-cert.yml
````
#### Ответ

- Создание секрета
````bash
mojnovse@mojno-vseMacBook HW_14.1 % openssl genrsa -out cert.key 4096
Generating RSA private key, 4096 bit long modulus
......................................................................++
.............................................................................................................................++
e is 65537 (0x10001)
mojnovse@mojno-vseMacBook HW_14.1 % openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
mojnovse@mojno-vseMacBook HW_14.1 % kubectl create secret tls domain-cert --cert=certs/cert.crt --key=certs/cert.key
error: Cannot read file certs/cert.crt, open certs/cert.crt: no such file or directory
mojnovse@mojno-vseMacBook HW_14.1 % kubectl create secret tls domain-cert --cert=cert.crt --key=cert.key
secret/domain-cert created
mojnovse@mojno-vseMacBook HW_14.1 % ls -la
total 16
drwxr-xr-x   5 mojnovse  staff   160 Jan 30 20:51 .
drwxr-xr-x  10 mojnovse  staff   320 Jan 30 20:41 ..
-rw-r--r--   1 mojnovse  staff  1805 Jan 30 20:46 cert.crt
-rw-r--r--   1 mojnovse  staff  3243 Jan 30 20:46 cert.key
mojnovse@mojno-vseMacBook HW_14.1 %

````
- Просмотр списка секретов
````bash
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secrets
NAME              TYPE                                  DATA   AGE
developer-token   kubernetes.io/service-account-token   3      62d
domain-cert       kubernetes.io/tls                     2      20s
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secret
NAME              TYPE                                  DATA   AGE
developer-token   kubernetes.io/service-account-token   3      62d
domain-cert       kubernetes.io/tls                     2      28s
mojnovse@mojno-vseMacBook HW_14.1 %
````
- Просмотр секрета
````bash
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secret domain-cert
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      52s
mojnovse@mojno-vseMacBook HW_14.1 % kubectl describe secret domain-cert
Name:         domain-cert
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  kubernetes.io/tls

Data
====
tls.key:  3243 bytes
tls.crt:  1805 bytes
mojnovse@mojno-vseMacBook HW_14.1 %
````
- Получение информации в формате YAML и/или JSON

[**YAML**]((https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_14.1/src/domain-cert.yaml))
````bash
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secret domain-cert -o yaml
apiVersion: v1
data:
  tls.crt: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZDRENDQXZBQ0NRQ3RwVEhWSS9TQWx6QU5CZ2txaGtpRzl3MEJBUXNGQURCR01Rc3dDUVlEVlFRR0V3SlMKVlRFUE1BMEdBMVVFQ0F3R1RXOXpZMjkzTVE4d0RRWURWUVFIREFaTmIzTmpiM2N4RlRBVEJnTlZCQU1NREhObApjblpsY2k1c2IyTmhiREFlRncweU16QXhNekF4TnpRMk1qaGFGdzB6TXpBeE1qY3hOelEyTWpoYU1FWXhDekFKCkJnTlZCQVlUQWxKVk1ROHdEUVlEVlFRSURBWk5iM05qYjNjeER6QU5CZ05WQkFjTUJrMXZjMk52ZHpFVk1CTUcKQTFVRUF3d01jMlZ5ZG1WeUxteHZZMkZzTUlJQ0lqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FnOEFNSUlDQ2dLQwpBZ0VBdjQzbnh3K0lySlViRlZKTG1CR09XUHJQc3lybFZTTmhXeGF0SG9POUl1WG9lYm5Pbjh6a2VoSDIwTE53CmVTNmoyOXphRTF3bFM0QVVyenExZEZpdlJ0all6WncxVllTZHlQbDdMbFBnVmIrZjFxZE5qbVNPenk1ZzF4OVEKZ25VTlZSTHBZWjJBK28vcS9NTHMxTXg5RGJ0LytnM3VEOUxXanByenpybk9BbVR5cmw5WE4zRngvaFBMWDl1dAppcG5jNXNtMGl5blA5cGhiVnhOa0VGYWwzWXlvcE0zVTNscUtzUEhpS1dqMW84S2hnRWNvcmZDeDViRkllcC9vCnh6dk43cmt2M2lBMlJRUmJ1RHpIODhJTDFQbUNnaGxTZWh3THJrZEV3Nmk4QnF5ZnFZTG0raG5ic3NHaUErWDYKa3pFYmxHRmMwd2grSVErek9TQ09WcmNFWkpYelZPQlFaR28rM3lsbGQycTFlVGJKMlZyOG1HR2J6eWgzSWhMNAowQ05KK0xEYi9wZlp1N1pMOGxXTUlIbWw5T0ttdXNjY1o4ZE9wUUlNS0VoT05yM2JLN3dXT1dub3BONjJBb1F0Ci9MSFpGVU5nbEF2RkdPZlhxb2diZ2NENzZjclF2ZTNKWkZEakg2amJZekFuTTVCNmplRGQrdVFOTFBNWjVrMkYKSGZCZU9CNXdYd1Ewd3doYWFrT2N3aWlFQU8rckdoVWg0QllmcU5INzN3aUJyTWNnanZhcWZLNU5zeCtPNEtVRQpTaXR5WGE5NHNPd0NNMTQxYUI3aW9WcVk1RDdlVENGcnRRbjlCcldyai92Y0ZSNm9rc0FVeHJhbXpVSXcvRmI5ClVOM3NiRHZwa0laYTNNQ2ZPbVpuYzJ4OEV5a3I1djVPbkxYbTlER015UjZhclprQ0F3RUFBVEFOQmdrcWhraUcKOXcwQkFRc0ZBQU9DQWdFQWVnNmdJVXJWdWIxY2pCL24wRGQyQkEyMHpCY2xxMkx2OFNCRTQ1blBLV1o4ZzdUMgpNYWNXczk5NitIcTJ0RVVPN0d6NUtjNzJpakZpb3dYY1BYM1pBZ1RYYmhTVW5ITHpmQStmMVhVOFR4eDVLRjNpClBKM2ptbXdjS3FrZ0hhUmF0WlhZdGxMQTBGUVlxS3RKbTlVN0wyMGZCZlE5VGN0a3UxTXBmZFJDSkJxbWJnckQKRnpWYTlVQVZWV3JRRWdVVW5lR2V2enZTMDZlZ2NiTFNIU0RBQmFxYjhJeVJwOU5saWdWMHEvaUFrS3orcjB5RgpTaDc3Qk1veVR5c2c1dFZnSkp1dDIyNWY2Zm1OWlJBRFdHTGlLUDRQMDFsdVJSL2J0eEMxR3d2emFEZ25XdFo1CitiVlhvTnpqc2hpTytnT1MwVGNXNlFZc3JkNVExdUhkT0Y4dnBzSS85dmhJSi9WSG85ZnZKaE5NUVJNUW9kWVMKWVI0Y2piS0V1dU1rNkNOM3VrMEhia01kRG42d0d1QkRrbTgvUytRNVc1T0xrdmRmK2E5dHV2eng2OFhzYkJjTwpPNHI3S1dUYkZBdDFUVm1oenMrK1lXc2FvSzRBZkxZUVVpTG1kMElLaGFwUDI1RjRZTVFTTjdxVnNlMFlEWEIwCnd5Z250WS9PYnhBTVVHY0ViTGxBSkIzeS9ETDVxVTNEQWV3VE9qeHFadzlTaVhmSnltNUFVa3ltZUtqVW45SXkKNTIvQlcreHNCbCszOUJuR1YveDk0ZDZubWY1Z3haQVRxSUpXLzRjUXZ6NHhZUzZXZUdwYzNhRWlUQUJBLzhZNwpBMHN2OWlUd2RKR1hndk11SkJUcnliblkwcGRBbzBCUjRUTG1MRXByc21TZC9OL2xlRjdFQ05CUWF2WT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
  tls.key: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBdjQzbnh3K0lySlViRlZKTG1CR09XUHJQc3lybFZTTmhXeGF0SG9POUl1WG9lYm5PCm44emtlaEgyMExOd2VTNmoyOXphRTF3bFM0QVVyenExZEZpdlJ0all6WncxVllTZHlQbDdMbFBnVmIrZjFxZE4Kam1TT3p5NWcxeDlRZ25VTlZSTHBZWjJBK28vcS9NTHMxTXg5RGJ0LytnM3VEOUxXanByenpybk9BbVR5cmw5WApOM0Z4L2hQTFg5dXRpcG5jNXNtMGl5blA5cGhiVnhOa0VGYWwzWXlvcE0zVTNscUtzUEhpS1dqMW84S2hnRWNvCnJmQ3g1YkZJZXAvb3h6dk43cmt2M2lBMlJRUmJ1RHpIODhJTDFQbUNnaGxTZWh3THJrZEV3Nmk4QnF5ZnFZTG0KK2huYnNzR2lBK1g2a3pFYmxHRmMwd2grSVErek9TQ09WcmNFWkpYelZPQlFaR28rM3lsbGQycTFlVGJKMlZyOAptR0dienloM0loTDQwQ05KK0xEYi9wZlp1N1pMOGxXTUlIbWw5T0ttdXNjY1o4ZE9wUUlNS0VoT05yM2JLN3dXCk9Xbm9wTjYyQW9RdC9MSFpGVU5nbEF2RkdPZlhxb2diZ2NENzZjclF2ZTNKWkZEakg2amJZekFuTTVCNmplRGQKK3VRTkxQTVo1azJGSGZCZU9CNXdYd1Ewd3doYWFrT2N3aWlFQU8rckdoVWg0QllmcU5INzN3aUJyTWNnanZhcQpmSzVOc3grTzRLVUVTaXR5WGE5NHNPd0NNMTQxYUI3aW9WcVk1RDdlVENGcnRRbjlCcldyai92Y0ZSNm9rc0FVCnhyYW16VUl3L0ZiOVVOM3NiRHZwa0laYTNNQ2ZPbVpuYzJ4OEV5a3I1djVPbkxYbTlER015UjZhclprQ0F3RUEKQVFLQ0FnRUFpMGorTGdxbmtRWml5U0FzQTRsUWZuYnhyQkFXN2M5cUxUZlI3Z3hRN1IxTDY2Y21EYUNJeWhKaAo2K051ZDA5b3FxaHVrZ0ZBeFNOKzV1UERxYlFLejNOQ1FrL0JvRXRzQ0FVUWd1Rk9rRXRrU0VzaTQ5Vk8ybXVZCjB4UGNFT0JZTDNJdTdXSC90VElNNW5vK2g0V2hzT2lUNkJsVTc0Q1pydHdSU0ZKbTcrckRZL1BEa1hjV01tL20KUSsrU3d1T2FjdDVjUDR6SndUK0x1MGRJVFhFVDdvTW01WjhkbUFreUsvUFdSZElpTzA5ODY2L1NicGhFWXdhRAo4MVp2aHQ5L29JUmJ3Q0tnRTVOVnRpUE1LUDBDYVh4OFgybFdSYUE3QmlDZ2FiMDU2NGgrR0Y0czRkTUhvM1dVCi8weXM1WGFoM1VUbW9EVGVzZCtlckgxMXdxd1ZybU8wWTcxZDQ1WHZxNmRoQ3RRVXYxTUsxQW5yblA4UVdKOTEKdTRLblBmanFBTkpxQ3h2b3h1cjRIT25Bdk14a1Ayb1AvdFpsWm11T2VJZWdlWWRBeWZRa25iKzhyNXVhcGxOOApqWkN4TDFURVErUE1OaHBnUzFPN2s0a1BMVHJFenBsNC9ueHd4N0ZZKzVOaEZGRWltQVRWUzdOUFJObHZ1UzlOCjQ5OFVJbjJHQ3pLdVJYbjhlbG1Ya2V6QXIwaUxIVGcvbU9WSVV0TUZHNVYxQXBhRmpRVXc2RjBvY3d3ZEhaeVcKbXY0NjZHb2VBTSt2cXUzWlFJeFJ3YlBOTk5RYWp1Q3Y1dzZwQWg5dHZ5NkxJTHJzdTVGWVhDUUpRdFdMT1VSeQpVVVlMRzRPY1ZtZzAvUFBoMWdhSUdWNmlPajRQTVdFU2p0YWtOZzhRMFdFeDc0L0hON2tDZ2dFQkFPbDBDVzJDClJqVGhrTllIMGdLSUl4SFZxWkc1Nnc5ZHEvMS8vS1BlMVFQQmpKaHlLNlJvbGhtdjZ0TUpIOVhMM240N0lzZUsKZVdQaFpiQ21MZjdpcmtqVTh3YUpzb2Y3UGhZdDN5VDEya29NeG1DQ011TWNROXRMcTNmZlQ0WWE3Zy9DNkpLNApVZDFVQ09LT1BoRHFxUHRQRDFORkprZndjdlNZdlVncDdkTUgzT05KOE5FZGh5d1NZZnJsZUZKZXJTd3FrUzl6Cm8zMDdzbnlqYnkvbFNvQWJjU0JmMkhyODdSZkxFcDFDTVljZC8xQzBYVnRsYXh0Uk56U0t3N0pPdUQ4UGIwRHgKaEFxU2k4L09CbXZnMzlPQmhldEFrTnl0K3dBekpmaFdWR0FSQzNwZUJzZEhhOTlMRkhBT084MTJEcmR2SG1xYwpjZ1NSZkxrSHdnWkdsNGNDZ2dFQkFOSU44b0tPMmY2NVVoellyOFRickhhMGVxQXFoUE8xYzlNdklPdGRKbGlOClVxN3NTdGhDamxZRDN6QVljejNQTnlqL2JZdlZTdHViQ2MwT3hiSWhaeVUyeGxZUVM5VFJjaGlkR3VOZUt4NkQKditjNE1LcmdRMEJSWVdFZnJnWWl3eDVTTXN6aURod3ZKbG9FeGpmVjZ3a2lnbWd4QitCKzArU0h2WFRXUzl1VQptcGlQOHBPUCtYQ2k4NThTNmY0TzNNN3JMM2dkeUJIeDNLUWp2SjJIT3krMHBVRnFzS09jdENTWjFHM25LN1VMCmo4QjE1dDZKM0Jqa0dDR1FKcC9XWUpYQ2JDaEhwWm5xd0RJbG5ONkxqWDNYK2VpcWNYemFON3phVEIrUGtRWnYKMmN2YUY4SGx2R2pLTWNRaDkyRnVOMyszUXZJcHp6aWhPSlhka041TG1kOENnZ0VCQUxUOGVMS2xaTGhxaDFibgpDVEZkU1pMeUNsd252c3hTMnB2Vk5ZLzFtVDhvTmsrWmM2d3FTUFB4SmlRbDFzQnhKVFRIczlidXk5MWJTUE1DClluWlFWcjJ3R2hqZmQ4RmtUbVh6ZWlPMVZsNUNPU2xveHZxN1Z3QVVVZ0xFNVdvYVJxV0JmYjBCbUxYMkNFMWIKNlZKRUdtMTZoVzhSRlBTQXZSNVRxNnJlbHJvY1Jtc1BUOXRQQVJSeHkvUXZJbkQ1WlZmd1NFNTVZQzRlc2VsZQo2encranR0eWF1bW1aTFkwajdyNmZKdmVUWGRyRWgwSE43azdqeVhHZVA0SzlseXVHcmtJeGorYS9ic1VrYit4CkFkbHdwUlhjUEc1OXg5RE9NT0dleGJrWmRLQmxsbmh2bk9HeHhUZC9oWUM2Q0RMcGE4OWFIa0tZdHV4RHZtWFUKVmQ5M3F0RUNnZ0VBRVhPeE0yRzFBUEhhdmFUUExiYm1wRklvWWdoR1ZZMDgyMDN1R1QvN0FKNTFRUzFHcHFNWQorbEtHQjVQd2R6RXhMd25SeXkxa2M4eDB5d0d3TVRXUFFVdEV2VC9MWFJvdHRaZlA5UllNMVJNekxYM0FwV0hPCmxKaHVVOGh6Qi9WNWFwcC91QUFNRmhGZ3lWZmVOQ05rekxSK1N6UFBxTHBBMXBya2hjR01PZWtsMHdrYXFXSHIKNG96WFd0OFNhOVpHU0RiSUVkMi9rcVlhbzlTSVJqcEhFNWFacUU2NThFNER0WXJHV0g4OVpXUlpoQzhIaUhQQgp3cHVvMlprRmJJQStOQk1jTTFpSWpMb3hUN2xLU0Q4bCtVK3Bac2hLZDRvVjJXMzFweVdoY2Z4M0J2WE94WUJWCjRBcjBpWXdjNW81bXRBakEyaWZaSEtaZ2Npc2ZieWl1MXdLQ0FRQXl5cGUyU2ZuZDVOVy9McnFXZE40akhWWnoKbWpZL0RCV3pVL2dUbkMvS2VTS0s5L092S2Jkbk55NkF3cHJSUklCM2d2TitQZW1oRldpMXFiN2kyQWJXbWtPTgpSTlZWbUw4bDZMK2cxTWFON1ZIV1g1cWo4SCtXUzdCWFp0N21JNVVJb3hHZEE3bzArUUw4ZHgvdDlKK0RoMXNrClRqbjIwVnJtdEtMU0RKRmJCdUdQUC9seUFFd2Z2UGY4TkpKQ3JqYXV2TFZqRTJ5ZE1pNTM5bE9sbFp6YW9hb3UKbkFaK2g2alFrSElRanU1ODBpbnZ6dVAxUVpwWGRvQWlCOHFueWsyUTZwOURINmFkOTdpb0dFbXVHdWFCM1ZSRwptelVEdnZsd0I1V0VYSjlPMTNUSGUxc2hpQThWVElLK3M0a29QbktHQ2FvMXdoVGxFQlNmdUhYUGlQZ2gKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K
kind: Secret
metadata:
  creationTimestamp: "2023-01-30T17:47:48Z"
  name: domain-cert
  namespace: default
  resourceVersion: "7408"
  uid: 480fdfd2-99f0-497d-9fd2-5e9583349c3d
type: kubernetes.io/tls
mojnovse@mojno-vseMacBook HW_14.1 %
````
[**JSON**](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_14.1/src/secret.json)
````bash
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secret domain-cert -o json
{
    "apiVersion": "v1",
    "data": {
        "tls.crt": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZDRENDQXZBQ0NRQ3RwVEhWSS9TQWx6QU5CZ2txaGtpRzl3MEJBUXNGQURCR01Rc3dDUVlEVlFRR0V3SlMKVlRFUE1BMEdBMVVFQ0F3R1RXOXpZMjkzTVE4d0RRWURWUVFIREFaTmIzTmpiM2N4RlRBVEJnTlZCQU1NREhObApjblpsY2k1c2IyTmhiREFlRncweU16QXhNekF4TnpRMk1qaGFGdzB6TXpBeE1qY3hOelEyTWpoYU1FWXhDekFKCkJnTlZCQVlUQWxKVk1ROHdEUVlEVlFRSURBWk5iM05qYjNjeER6QU5CZ05WQkFjTUJrMXZjMk52ZHpFVk1CTUcKQTFVRUF3d01jMlZ5ZG1WeUxteHZZMkZzTUlJQ0lqQU5CZ2txaGtpRzl3MEJBUUVGQUFPQ0FnOEFNSUlDQ2dLQwpBZ0VBdjQzbnh3K0lySlViRlZKTG1CR09XUHJQc3lybFZTTmhXeGF0SG9POUl1WG9lYm5Pbjh6a2VoSDIwTE53CmVTNmoyOXphRTF3bFM0QVVyenExZEZpdlJ0all6WncxVllTZHlQbDdMbFBnVmIrZjFxZE5qbVNPenk1ZzF4OVEKZ25VTlZSTHBZWjJBK28vcS9NTHMxTXg5RGJ0LytnM3VEOUxXanByenpybk9BbVR5cmw5WE4zRngvaFBMWDl1dAppcG5jNXNtMGl5blA5cGhiVnhOa0VGYWwzWXlvcE0zVTNscUtzUEhpS1dqMW84S2hnRWNvcmZDeDViRkllcC9vCnh6dk43cmt2M2lBMlJRUmJ1RHpIODhJTDFQbUNnaGxTZWh3THJrZEV3Nmk4QnF5ZnFZTG0raG5ic3NHaUErWDYKa3pFYmxHRmMwd2grSVErek9TQ09WcmNFWkpYelZPQlFaR28rM3lsbGQycTFlVGJKMlZyOG1HR2J6eWgzSWhMNAowQ05KK0xEYi9wZlp1N1pMOGxXTUlIbWw5T0ttdXNjY1o4ZE9wUUlNS0VoT05yM2JLN3dXT1dub3BONjJBb1F0Ci9MSFpGVU5nbEF2RkdPZlhxb2diZ2NENzZjclF2ZTNKWkZEakg2amJZekFuTTVCNmplRGQrdVFOTFBNWjVrMkYKSGZCZU9CNXdYd1Ewd3doYWFrT2N3aWlFQU8rckdoVWg0QllmcU5INzN3aUJyTWNnanZhcWZLNU5zeCtPNEtVRQpTaXR5WGE5NHNPd0NNMTQxYUI3aW9WcVk1RDdlVENGcnRRbjlCcldyai92Y0ZSNm9rc0FVeHJhbXpVSXcvRmI5ClVOM3NiRHZwa0laYTNNQ2ZPbVpuYzJ4OEV5a3I1djVPbkxYbTlER015UjZhclprQ0F3RUFBVEFOQmdrcWhraUcKOXcwQkFRc0ZBQU9DQWdFQWVnNmdJVXJWdWIxY2pCL24wRGQyQkEyMHpCY2xxMkx2OFNCRTQ1blBLV1o4ZzdUMgpNYWNXczk5NitIcTJ0RVVPN0d6NUtjNzJpakZpb3dYY1BYM1pBZ1RYYmhTVW5ITHpmQStmMVhVOFR4eDVLRjNpClBKM2ptbXdjS3FrZ0hhUmF0WlhZdGxMQTBGUVlxS3RKbTlVN0wyMGZCZlE5VGN0a3UxTXBmZFJDSkJxbWJnckQKRnpWYTlVQVZWV3JRRWdVVW5lR2V2enZTMDZlZ2NiTFNIU0RBQmFxYjhJeVJwOU5saWdWMHEvaUFrS3orcjB5RgpTaDc3Qk1veVR5c2c1dFZnSkp1dDIyNWY2Zm1OWlJBRFdHTGlLUDRQMDFsdVJSL2J0eEMxR3d2emFEZ25XdFo1CitiVlhvTnpqc2hpTytnT1MwVGNXNlFZc3JkNVExdUhkT0Y4dnBzSS85dmhJSi9WSG85ZnZKaE5NUVJNUW9kWVMKWVI0Y2piS0V1dU1rNkNOM3VrMEhia01kRG42d0d1QkRrbTgvUytRNVc1T0xrdmRmK2E5dHV2eng2OFhzYkJjTwpPNHI3S1dUYkZBdDFUVm1oenMrK1lXc2FvSzRBZkxZUVVpTG1kMElLaGFwUDI1RjRZTVFTTjdxVnNlMFlEWEIwCnd5Z250WS9PYnhBTVVHY0ViTGxBSkIzeS9ETDVxVTNEQWV3VE9qeHFadzlTaVhmSnltNUFVa3ltZUtqVW45SXkKNTIvQlcreHNCbCszOUJuR1YveDk0ZDZubWY1Z3haQVRxSUpXLzRjUXZ6NHhZUzZXZUdwYzNhRWlUQUJBLzhZNwpBMHN2OWlUd2RKR1hndk11SkJUcnliblkwcGRBbzBCUjRUTG1MRXByc21TZC9OL2xlRjdFQ05CUWF2WT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=",
        "tls.key": "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS1FJQkFBS0NBZ0VBdjQzbnh3K0lySlViRlZKTG1CR09XUHJQc3lybFZTTmhXeGF0SG9POUl1WG9lYm5PCm44emtlaEgyMExOd2VTNmoyOXphRTF3bFM0QVVyenExZEZpdlJ0all6WncxVllTZHlQbDdMbFBnVmIrZjFxZE4Kam1TT3p5NWcxeDlRZ25VTlZSTHBZWjJBK28vcS9NTHMxTXg5RGJ0LytnM3VEOUxXanByenpybk9BbVR5cmw5WApOM0Z4L2hQTFg5dXRpcG5jNXNtMGl5blA5cGhiVnhOa0VGYWwzWXlvcE0zVTNscUtzUEhpS1dqMW84S2hnRWNvCnJmQ3g1YkZJZXAvb3h6dk43cmt2M2lBMlJRUmJ1RHpIODhJTDFQbUNnaGxTZWh3THJrZEV3Nmk4QnF5ZnFZTG0KK2huYnNzR2lBK1g2a3pFYmxHRmMwd2grSVErek9TQ09WcmNFWkpYelZPQlFaR28rM3lsbGQycTFlVGJKMlZyOAptR0dienloM0loTDQwQ05KK0xEYi9wZlp1N1pMOGxXTUlIbWw5T0ttdXNjY1o4ZE9wUUlNS0VoT05yM2JLN3dXCk9Xbm9wTjYyQW9RdC9MSFpGVU5nbEF2RkdPZlhxb2diZ2NENzZjclF2ZTNKWkZEakg2amJZekFuTTVCNmplRGQKK3VRTkxQTVo1azJGSGZCZU9CNXdYd1Ewd3doYWFrT2N3aWlFQU8rckdoVWg0QllmcU5INzN3aUJyTWNnanZhcQpmSzVOc3grTzRLVUVTaXR5WGE5NHNPd0NNMTQxYUI3aW9WcVk1RDdlVENGcnRRbjlCcldyai92Y0ZSNm9rc0FVCnhyYW16VUl3L0ZiOVVOM3NiRHZwa0laYTNNQ2ZPbVpuYzJ4OEV5a3I1djVPbkxYbTlER015UjZhclprQ0F3RUEKQVFLQ0FnRUFpMGorTGdxbmtRWml5U0FzQTRsUWZuYnhyQkFXN2M5cUxUZlI3Z3hRN1IxTDY2Y21EYUNJeWhKaAo2K051ZDA5b3FxaHVrZ0ZBeFNOKzV1UERxYlFLejNOQ1FrL0JvRXRzQ0FVUWd1Rk9rRXRrU0VzaTQ5Vk8ybXVZCjB4UGNFT0JZTDNJdTdXSC90VElNNW5vK2g0V2hzT2lUNkJsVTc0Q1pydHdSU0ZKbTcrckRZL1BEa1hjV01tL20KUSsrU3d1T2FjdDVjUDR6SndUK0x1MGRJVFhFVDdvTW01WjhkbUFreUsvUFdSZElpTzA5ODY2L1NicGhFWXdhRAo4MVp2aHQ5L29JUmJ3Q0tnRTVOVnRpUE1LUDBDYVh4OFgybFdSYUE3QmlDZ2FiMDU2NGgrR0Y0czRkTUhvM1dVCi8weXM1WGFoM1VUbW9EVGVzZCtlckgxMXdxd1ZybU8wWTcxZDQ1WHZxNmRoQ3RRVXYxTUsxQW5yblA4UVdKOTEKdTRLblBmanFBTkpxQ3h2b3h1cjRIT25Bdk14a1Ayb1AvdFpsWm11T2VJZWdlWWRBeWZRa25iKzhyNXVhcGxOOApqWkN4TDFURVErUE1OaHBnUzFPN2s0a1BMVHJFenBsNC9ueHd4N0ZZKzVOaEZGRWltQVRWUzdOUFJObHZ1UzlOCjQ5OFVJbjJHQ3pLdVJYbjhlbG1Ya2V6QXIwaUxIVGcvbU9WSVV0TUZHNVYxQXBhRmpRVXc2RjBvY3d3ZEhaeVcKbXY0NjZHb2VBTSt2cXUzWlFJeFJ3YlBOTk5RYWp1Q3Y1dzZwQWg5dHZ5NkxJTHJzdTVGWVhDUUpRdFdMT1VSeQpVVVlMRzRPY1ZtZzAvUFBoMWdhSUdWNmlPajRQTVdFU2p0YWtOZzhRMFdFeDc0L0hON2tDZ2dFQkFPbDBDVzJDClJqVGhrTllIMGdLSUl4SFZxWkc1Nnc5ZHEvMS8vS1BlMVFQQmpKaHlLNlJvbGhtdjZ0TUpIOVhMM240N0lzZUsKZVdQaFpiQ21MZjdpcmtqVTh3YUpzb2Y3UGhZdDN5VDEya29NeG1DQ011TWNROXRMcTNmZlQ0WWE3Zy9DNkpLNApVZDFVQ09LT1BoRHFxUHRQRDFORkprZndjdlNZdlVncDdkTUgzT05KOE5FZGh5d1NZZnJsZUZKZXJTd3FrUzl6Cm8zMDdzbnlqYnkvbFNvQWJjU0JmMkhyODdSZkxFcDFDTVljZC8xQzBYVnRsYXh0Uk56U0t3N0pPdUQ4UGIwRHgKaEFxU2k4L09CbXZnMzlPQmhldEFrTnl0K3dBekpmaFdWR0FSQzNwZUJzZEhhOTlMRkhBT084MTJEcmR2SG1xYwpjZ1NSZkxrSHdnWkdsNGNDZ2dFQkFOSU44b0tPMmY2NVVoellyOFRickhhMGVxQXFoUE8xYzlNdklPdGRKbGlOClVxN3NTdGhDamxZRDN6QVljejNQTnlqL2JZdlZTdHViQ2MwT3hiSWhaeVUyeGxZUVM5VFJjaGlkR3VOZUt4NkQKditjNE1LcmdRMEJSWVdFZnJnWWl3eDVTTXN6aURod3ZKbG9FeGpmVjZ3a2lnbWd4QitCKzArU0h2WFRXUzl1VQptcGlQOHBPUCtYQ2k4NThTNmY0TzNNN3JMM2dkeUJIeDNLUWp2SjJIT3krMHBVRnFzS09jdENTWjFHM25LN1VMCmo4QjE1dDZKM0Jqa0dDR1FKcC9XWUpYQ2JDaEhwWm5xd0RJbG5ONkxqWDNYK2VpcWNYemFON3phVEIrUGtRWnYKMmN2YUY4SGx2R2pLTWNRaDkyRnVOMyszUXZJcHp6aWhPSlhka041TG1kOENnZ0VCQUxUOGVMS2xaTGhxaDFibgpDVEZkU1pMeUNsd252c3hTMnB2Vk5ZLzFtVDhvTmsrWmM2d3FTUFB4SmlRbDFzQnhKVFRIczlidXk5MWJTUE1DClluWlFWcjJ3R2hqZmQ4RmtUbVh6ZWlPMVZsNUNPU2xveHZxN1Z3QVVVZ0xFNVdvYVJxV0JmYjBCbUxYMkNFMWIKNlZKRUdtMTZoVzhSRlBTQXZSNVRxNnJlbHJvY1Jtc1BUOXRQQVJSeHkvUXZJbkQ1WlZmd1NFNTVZQzRlc2VsZQo2encranR0eWF1bW1aTFkwajdyNmZKdmVUWGRyRWgwSE43azdqeVhHZVA0SzlseXVHcmtJeGorYS9ic1VrYit4CkFkbHdwUlhjUEc1OXg5RE9NT0dleGJrWmRLQmxsbmh2bk9HeHhUZC9oWUM2Q0RMcGE4OWFIa0tZdHV4RHZtWFUKVmQ5M3F0RUNnZ0VBRVhPeE0yRzFBUEhhdmFUUExiYm1wRklvWWdoR1ZZMDgyMDN1R1QvN0FKNTFRUzFHcHFNWQorbEtHQjVQd2R6RXhMd25SeXkxa2M4eDB5d0d3TVRXUFFVdEV2VC9MWFJvdHRaZlA5UllNMVJNekxYM0FwV0hPCmxKaHVVOGh6Qi9WNWFwcC91QUFNRmhGZ3lWZmVOQ05rekxSK1N6UFBxTHBBMXBya2hjR01PZWtsMHdrYXFXSHIKNG96WFd0OFNhOVpHU0RiSUVkMi9rcVlhbzlTSVJqcEhFNWFacUU2NThFNER0WXJHV0g4OVpXUlpoQzhIaUhQQgp3cHVvMlprRmJJQStOQk1jTTFpSWpMb3hUN2xLU0Q4bCtVK3Bac2hLZDRvVjJXMzFweVdoY2Z4M0J2WE94WUJWCjRBcjBpWXdjNW81bXRBakEyaWZaSEtaZ2Npc2ZieWl1MXdLQ0FRQXl5cGUyU2ZuZDVOVy9McnFXZE40akhWWnoKbWpZL0RCV3pVL2dUbkMvS2VTS0s5L092S2Jkbk55NkF3cHJSUklCM2d2TitQZW1oRldpMXFiN2kyQWJXbWtPTgpSTlZWbUw4bDZMK2cxTWFON1ZIV1g1cWo4SCtXUzdCWFp0N21JNVVJb3hHZEE3bzArUUw4ZHgvdDlKK0RoMXNrClRqbjIwVnJtdEtMU0RKRmJCdUdQUC9seUFFd2Z2UGY4TkpKQ3JqYXV2TFZqRTJ5ZE1pNTM5bE9sbFp6YW9hb3UKbkFaK2g2alFrSElRanU1ODBpbnZ6dVAxUVpwWGRvQWlCOHFueWsyUTZwOURINmFkOTdpb0dFbXVHdWFCM1ZSRwptelVEdnZsd0I1V0VYSjlPMTNUSGUxc2hpQThWVElLK3M0a29QbktHQ2FvMXdoVGxFQlNmdUhYUGlQZ2gKLS0tLS1FTkQgUlNBIFBSSVZBVEUgS0VZLS0tLS0K"
    },
    "kind": "Secret",
    "metadata": {
        "creationTimestamp": "2023-01-30T17:47:48Z",
        "name": "domain-cert",
        "namespace": "default",
        "resourceVersion": "7408",
        "uid": "480fdfd2-99f0-497d-9fd2-5e9583349c3d"
    },
    "type": "kubernetes.io/tls"
}
mojnovse@mojno-vseMacBook HW_14.1 %
````
- Выгрузить секрет и сохранить его в файл
````bash
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secrets -o json > src/secrets.json
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secret domain-cert -o yaml > src/domain-cert.yml
mojnovse@mojno-vseMacBook HW_14.1 % ls -la src
total 40
drwxr-xr-x  4 mojnovse  staff    128 Jan 30 20:52 .
drwxr-xr-x  5 mojnovse  staff    160 Jan 30 20:51 ..
-rw-r--r--  1 mojnovse  staff   6979 Jan 30 20:52 domain-cert.yml
-rw-r--r--  1 mojnovse  staff  11147 Jan 30 20:51 secrets.json
mojnovse@mojno-vseMacBook HW_14.1 %
````
- Удаление
````bash
mojnovse@mojno-vseMacBook HW_14.1 % kubectl delete secret domain-cert
secret "domain-cert" deleted
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secret domain-cert
Error from server (NotFound): secrets "domain-cert" not found
mojnovse@mojno-vseMacBook HW_14.1 %
````
- Загрузить секрет из файла
````bash
mojnovse@mojno-vseMacBook HW_14.1 % kubectl delete secret domain-cert
secret "domain-cert" deleted
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secret domain-cert
Error from server (NotFound): secrets "domain-cert" not found
mojnovse@mojno-vseMacBook HW_14.1 % kubectl apply -f src/domain-cert.yml
secret/domain-cert created
mojnovse@mojno-vseMacBook HW_14.1 % kubectl get secret domain-cert
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      2s
mojnovse@mojno-vseMacBook HW_14.1 %
````