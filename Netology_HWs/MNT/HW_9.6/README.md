# devops-netology
### performed by Kirill Karagodin
#### HW 9.6 Gitlab.

#### Подготовка к выполнению

1. Необходимо подготовить gitlab к работе по инструкции 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/vms.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/start.JPG)

2. Создайте свой новый проект 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/project.JPG)

3. Создайте новый репозиторий в gitlab, наполните его файлами

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/repo.JPG)

4. Проект должен быть публичным, остальные настройки по желанию

#### DevOps

В репозитории содержится код проекта на python. Проект - RESTful API сервис. Ваша задача автоматизировать сборку образа
с выполнением python-скрипта:

1. Образ собирается на основе centos:7 
2. Python версии не ниже 3.7 
3. Установлены зависимости: flask flask-restful 
4. Создана директория /python_api 
5. Скрипт из репозитория размещён в /python_api 
6. Точка вызова: запуск скрипта 
7. Если сборка происходит на ветке master: должен подняться pod kubernetes на основе образа python-api, иначе этот шаг нужно пропустить

Создан Dockerfile
````bash
FROM centos:7

RUN yum install python3 python3-pip -y
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt
WORKDIR /python_api
COPY python-api.py python-api.py
CMD ["python3", "python-api.py"]
````

Сборка в ветке `master ` прошла успешно

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/pipline.JPG)

#### Product Owner

Вашему проекту нужна бизнесовая доработка: необходимо поменять JSON ответа на вызов метода GET /rest/api/get_info, 
необходимо создать Issue в котором указать:

1. Какой метод необходимо исправить 
2. Текст с { "message": "Already started" } на { "message": "Running"} 
3. Issue поставить label: feature

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/issues.JPG)

#### Developer

Вам пришел новый Issue на доработку, вам необходимо:

1. Создать отдельную ветку, связанную с этим issue 
2. Внести изменения по тексту из задания 
3. Подготовить Merge Requst, влить необходимые изменения в master, проверить, что сборка прошла успешно

Сборка после внесения изменений

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/bild.JPG)

Merge в оснорвную ветку прошёл успешно

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/merge.JPG)

Задача закрыта

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/developer.JPG)

#### Tester

Разработчики выполнили новый Issue, необходимо проверить валидность изменений:

1. Поднять докер-контейнер с образом python-api:latest и проверить возврат метода на корректность 
2. Закрыть Issue с комментарием об успешности прохождения, указав желаемый результат и фактически достигнутый

Контейнер поднялся
ответ на `curl` в соответствии с поставленной задачей

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/curl.JPG)

Закрыл Issue

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.6/img/test.JPG)

Ссылка на [Gitlab](https://karagodin.gitlab.yandexcloud.net/micra/netology-test.git)