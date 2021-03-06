# devops-netology
### performed by Kirill Karagodin
#### HW6.1 Типы и структура СУБД.

1. Архитектор ПО решил проконсультироваться у вас, какой тип БД лучше выбрать для хранения определенных данных.
Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД: 
- Электронные чеки в json виде
````
Электронные чеки в json виде: Документо-ориентированная
````
- Склады и автомобильные дороги для логистической компании
````
Сетевая - иерархическая с множеством узлов, но в зависимости от целей, можно использовать графовую
````
- Генеалогические деревья
````
Иерархическая- класические деревья с одним родителем
````
- Кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации
````
NoSQL БД. Так как данная СУБД нет критичности хранения идентификаторов. Это кэш-система или
брокер-сообщений, где данные хранятся в оперативной памяти (быстрый доступ) и маркер ограничения времени жизни
(time-to-live).
````
- Отношения клиент-покупка для интернет-магазина
````
реляционный тип БД, т.к. нет прямого значения ключ-значение, к каждой покупке необходимо множество дополнительных
данных, которые должны распологаться в других таблицах. 
````

2. Вы создали распределенное высоконагруженное приложение и хотите классифицировать его согласно CAP-теореме. 
Какой классификации по CAP-теореме соответствует ваша система, если (каждый пункт - это отдельная реализация вашей 
системы и для каждого пункта надо привести классификацию):
- Данные записываются на все узлы с задержкой до часа (асинхронная запись)
- При сетевых сбоях, система может разделиться на 2 раздельных кластера
- Система может не прислать корректный ответ или сбросить соединение
А согласно PACELC-теореме, как бы вы классифицировали данные реализации?
````
- CA (консистентность и доступность) должна быть согласованность данных и доступность, т.к. данные записываются на все 
узлы, при этом устойчивость к разделению не важна, т.к. происходит асинхронная запись, PC/EL
````
*Данная система классифицируется по САР теореме как СА - данные согласованны и доступны, но система не устойчива
к разделению. Все данные на всех нодах не противоречят друг другу. Такая систекма зависима от надежности сети.
По теореме PACELC PC/EL - данная архитектура при разделении стремится оставаться консистентной, а в случае без сетевых 
разделений, фокусируется на скорости ответа, отводя консистентность на второй план. 
````
- AP (доступность и устойчивость к разделению) при сетевых сбоях система остается доступной т.к. делится на 2 кластера, 
при этом не важна согласованность данных, т.к. оба кластера работают как самостоятельные сущности, PA/EL
````
*По уловию данная система подходит под класс AP согласно CAP теореме, так как при сетевом сбое она разделиться на 2 
кластера, тем самым обеспечит досупность, но пожертвует целостностью данных 
Согласно теореме PACELC данная система подпадает под классификацию PA/EL - высокая доступность (A) при разделении (P) 
системы иначе (E) высокая скорость ответа (L).
````
- СP (консистентность данных, устойчивость к разделению), поскольку данные в системе должны быть согласованы, то система
может сбросить соединение при несогласовании, доступность при этом не обеспечивается. PA/EC
````
*Система, описанная в задании подходит под классофикацию CP согласно CAP теореме, так как в угоду устрочивости 
к разделению и целостности данных жертвует доступностью к БД (не кореректный ответ, сброс соединения)
Согласно теореме PACELC данная система подпадает под классификацию PA/EC - При наличии сетевого разделения системы 
ставка делается на доступность, а при отсутствии распределения – на консистентность

3. Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?
````
Не могут, так как принцип BASE прямо противоположен принципу ACID. Принцип ACID требует к СУБД надежность системы и 
предсказуемость, проектируя высоконадежные системы. BASE позволяет проектировать высокопроизводительные системы, 
жертвуя при этом надежностью.
````
4. Вам дали задачу написать системное решение, основой которого бы послужили:
- фиксация некоторых значений с временем жизни
- реакция на истечение таймаута
````
Cистемное решение может представлять БД на REDIS, она реализует возможность фиксации значений с временем жизни 
(Данным можно присваивать Time-To-Live), имеет встроенную систему Pub/Sub
````
Вы слышали о key-value хранилище, которое имеет механизм Pub/Sub. Что это за система? Какие минусы выбора данной 
системы?
```
Механизм Pub/Sub, представляет собой асинхронный метод связи между сервисами, используемый в бессерверных архитектурах
и архитектурах микросервисов. По сути, модель Pub / Sub включает в себя: издатель, который отправляет сообщение и
подписчик, который получает сообщение через брокера сообщений.
Минусы:
- Излишне сложен в простых (небольших) системах.
- Pub/Sub не подходит при работе с мультимедиа (аудио или видео), поскольку они требуют плавной синхронной
потоковой передачи между хостом и получателем. Поскольку он не поддерживает синхронную сквозную связь.
````
*Речь идет о БД REDIS ее рлюсы и минусы:
Плюсы:
- Скорость
- Поддержка широкого спектра данных
- Открытый исходный код
- Работа с общими типами данных
Минусы:
- Требуются достаточные ресурсы RAM(оперативной памяти) + нужно следить за достаточностью памяти 
- Отсутсвие поддержки языка SQL - проблема оперативного поиска данных 
- При отказе сервера все данные с последней синхронизации с диском будут утеряны
