# devops-netology
### performed by Kirill Karagodin
#### HW 9.1 Жизненный цикл ПО.

 - В рамках основной части необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. 
Задачи типа bug должны проходить следующий жизненный цикл:

1. Open -> On reproduce 
2. On reproduce -> Open, Done reproduce 
3. Done reproduce -> On fix 
4. On fix -> On reproduce, Done fix 
5. Done fix -> On test 
6. On test -> On fix, Done 
7. Done -> Closed, Open

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/bag.JPG)

Остальные задачи должны проходить по упрощённому workflow:

8. Open -> On develop 
9. On develop -> Open, Done develop 
10. Done develop -> On test 
11. On test -> On develop, Done 
12. Done -> Closed, Open

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/other.JPG)

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/WFs.JPG)
Создать задачу с типом bug, попытаться провести его по всему workflow до Done. 
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/bag_way.JPG)

 - Создать задачу с типом epic, к ней привязать несколько задач с типом task, провести их по всему workflow до Done. 
При проведении обеих задач по статусам использовать kanban.
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/epic1.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/epic2.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/epic0.JPG)

 - Вернуть задачи в статус Open. 
 - Перейти в scrum, запланировать новый спринт, состоящий из задач эпика и одного бага, стартовать спринт, 
провести задачи до состояния Closed. Закрыть спринт.
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/sprint1.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/sprint2.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/img/close.JPG)

Если всё отработало в рамках ожидания - выгрузить схемы workflow для импорта в XML. Файлы с workflow приложить к 
решению задания.

[bag workflow](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/bag.xml)

[other types of tasks](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.1/oher%20tasks.xml)