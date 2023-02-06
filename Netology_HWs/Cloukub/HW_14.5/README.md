# devops-netology
### performed by Kirill Karagodin
#### HW 14.5 SecurityContext, NetworkPolicies

#### Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль
````bash
kubectl apply -f 14.5/example-security-context.yml
````
Проверьте установленные настройки внутри контейнера
````bash
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
````
#### Ответ

Создаем модуль
````bash
mojnovse@mojno-vseMacBook src % kubectl apply -f example-security-context.yml
pod/security-context-demo created
mojnovse@mojno-vseMacBook src % kubectl get po -n default -o wide
NAME                         READY   STATUS             RESTARTS        AGE     IP            NODE       NOMINATED NODE   READINESS GATES
security-context-demo        0/1     CrashLoopBackOff   3 (20s ago)     74s     172.17.0.12   minikube   <none>           <none>
mojnovse@mojno-vseMacBook src %
````
Проверим настройки внутри контейнера
````bash
mojnovse@mojno-vseMacBook src % kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
mojnovse@mojno-vseMacBook src %
````
Идентификаторы пользователя и группы совпадают с теми, которые указаны в `securityContext` параметрах
````bash
mojnovse@mojno-vseMacBook src % cat example-security-context.yml
---
...
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000
mojnovse@mojno-vseMacBook src %
````
#### Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру и ко второму контейнеру.
Для второго модуля разрешите связь только с первым контейнером. Проверьте корректность настроек.

#### Ответ

Для проверки буду использовать 2 уже запущенных пода `14.2-netology-vault` и `db-0`
````bash
mojnovse@mojno-vseMacBook src % kubectl get pods  --namespace=default -o wide
NAME                  READY   STATUS    RESTARTS       AGE    IP           NODE       NOMINATED NODE   READINESS GATES
14.2-netology-vault   1/1     Running   1 (7d1h ago)   7d1h   172.17.0.5   minikube   <none>           <none>
db-0                  1/1     Running   0              68m    172.17.0.4   minikube   <none>           <none>
mojnovse@mojno-vseMacBook src %

````
Проверим доступность "соседа" и внешний ресурс на примере `ya.ru`
-**14.2-netology-vault**
````bash
mojnovse@mojno-vseMacBook src % kubectl exec 14.2-netology-vault -it -- sh
/ # ping 172.17.0.4
PING 172.17.0.4 (172.17.0.4): 56 data bytes
64 bytes from 172.17.0.4: seq=0 ttl=64 time=0.351 ms
64 bytes from 172.17.0.4: seq=1 ttl=64 time=0.113 ms
^C
--- 172.17.0.4 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.113/0.232/0.351 ms
/ # ping ya.ru
PING ya.ru (87.250.250.242): 56 data bytes
64 bytes from 87.250.250.242: seq=0 ttl=36 time=5.825 ms
64 bytes from 87.250.250.242: seq=1 ttl=36 time=5.744 ms
^C
--- ya.ru ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 5.744/5.784/5.825 ms
/ #
````
- **db-0**
````bash
mojnovse@mojno-vseMacBook src % kubectl exec db-0 -it -- sh
/ # ping 172.17.0.5
PING 172.17.0.5 (172.17.0.5): 56 data bytes
64 bytes from 172.17.0.5: seq=0 ttl=64 time=0.384 ms
64 bytes from 172.17.0.5: seq=1 ttl=64 time=0.133 ms
^C
--- 172.17.0.5 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.133/0.258/0.384 ms
/ # ping ya.ru
PING ya.ru (87.250.250.242): 56 data bytes
64 bytes from 87.250.250.242: seq=0 ttl=36 time=7.497 ms
64 bytes from 87.250.250.242: seq=1 ttl=36 time=8.869 ms
^C
--- ya.ru ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 7.497/8.183/8.869 ms
/ #
````
Создадим первое правило для `14.2-netology-vault` разрешим доступ и дикий интернет и на `db-0`

[**policy1.yaml**](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_14.5/src/policy1.yml)
````bash
mojnovse@mojno-vseMacBook src % cat policy1.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: voult-pod-network-policy
spec:
  podSelector:
    matchLabels:
      name: 14.2-netology-vault
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: db-0
mojnovse@mojno-vseMacBook src %
````
Применим и проверим доступы
````bash
mojnovse@mojno-vseMacBook src % kubectl apply -f policy1.yaml
networkpolicy.networking.k8s.io/voult-pod-network-policy created
mojnovse@mojno-vseMacBook src % kubectl exec 14.2-netology-vault -it -- sh
/ # ping 172.17.0.4
PING 172.17.0.4 (172.17.0.4): 56 data bytes
64 bytes from 172.17.0.4: seq=0 ttl=64 time=0.267 ms
64 bytes from 172.17.0.4: seq=1 ttl=64 time=0.293 ms
^C
--- 172.17.0.4 ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 0.267/0.280/0.293 ms
/ # ping ya.ru
PING ya.ru (87.250.250.242): 56 data bytes
64 bytes from 87.250.250.242: seq=0 ttl=36 time=5.984 ms
64 bytes from 87.250.250.242: seq=1 ttl=36 time=9.547 ms
^C
--- ya.ru ping statistics ---
2 packets transmitted, 2 packets received, 0% packet loss
round-trip min/avg/max = 5.984/7.765/9.547 ms
/ #
````
Создадим второе правило для `db-0` разрешим доступ на `14.2-netology-vault` и запретим дикий интернет

[**policy2.yaml**](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Cloukub/HW_14.5/src/policy2.yml)
````bash
mojnovse@mojno-vseMacBook src % cat policy2.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: db-0-pod-network-policy
spec:
  podSelector:
    matchLabels:
      name: db-0
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          name: 14.2-netology-vault
  egress:
  - to:
    - podSelector:
        matchLabels:
          name: 14.2-netology-vault
  - to:
    - namespaceSelector:
        matchLabels:
          namespace: default
    ports:
    - protocol: UDP
      port: 53
mojnovse@mojno-vseMacBook src %

````
Применим и проверим доступы
````bash
mojnovse@mojno-vseMacBook src % kubectl apply -f policy2.yaml
networkpolicy.networking.k8s.io/db-0-pod-network-policy configured
mojnovse@mojno-vseMacBook src % kubectl exec db-0 -it -- sh
/ # wget ya.ru
Connecting to ya.ru (87.250.250.242:80)
wget: can't connect to remote host (87.250.250.242): Connection refused
/ # ping 172.17.0.5
PING 172.17.0.5 (172.17.0.5): 56 data bytes
64 bytes from 172.17.0.5: seq=0 ttl=64 time=0.590 ms
64 bytes from 172.17.0.5: seq=1 ttl=64 time=0.210 ms
64 bytes from 172.17.0.5: seq=2 ttl=64 time=0.491 ms
^C
--- 172.17.0.5 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max = 0.210/0.430/0.590 ms
/ #
````
Удаляем политики
````bash
mojnovse@mojno-vseMacBook src % kubectl delete networkpolicies db-0-pod-network-policy
networkpolicy.networking.k8s.io "db-0-pod-network-policy" deleted
mojnovse@mojno-vseMacBook src % kubectl delete networkpolicies voult-pod-network-policy
networkpolicy.networking.k8s.io "voult-pod-network-policy" deleted
mojnovse@mojno-vseMacBook src %
````