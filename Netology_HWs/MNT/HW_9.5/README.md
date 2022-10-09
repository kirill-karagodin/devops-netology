# devops-netology
### performed by Kirill Karagodin
#### HW 9.5 Teamcity.

### Подготовка:

1. В Ya.Cloud создайте новый инстанс (4CPU4RAM) на основе образа jetbrains/teamcity-server 
2. Дождитесь запуска teamcity, выполните первоначальную настройку 
3. Создайте ещё один инстанс(2CPU4RAM) на основе образа jetbrains/teamcity-agent. Пропишите к нему переменную окружения 
SERVER_URL: "http://<teamcity_url>:8111"
4. Авторизуйте агент 
5. Сделайте fork репозитория 
6. Создать VM (2CPU4RAM) и запустить playbook

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/vms.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/nexus.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/master.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/agent.JPG)

### Основная часть

1. Создайте новый проект в teamcity на основе fork 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/project.JPG)

2. Сделайте autodetect конфигурации
3. Сохраните необходимые шаги, запустите первую сборку master'a 
4. Поменяйте условия сборки: если сборка по ветке master, то должен происходит mvn clean deploy, иначе mvn clean test
5. Для deploy будет необходимо загрузить settings.xml в набор конфигураций maven у teamcity, предварительно записав туда
креды для подключения к nexus 
6. В pom.xml необходимо поменять ссылки на репозиторий и nexus
7. Запустите сборку по master, убедитесь что всё прошло успешно, артефакт появился в nexus 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/build1.JPG)

9. Мигрируйте build configuration в репозиторий 
10. Создайте отдельную ветку feature/add_reply в репозитории
11. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово hunter 
12. Дополните тест для нового метода на поиск слова hunter в новой реплике 
13. Сделайте push всех изменений в новую ветку в репозиторий 
14. Убедитесь что сборка самостоятельно запустилась, тесты прошли успешно

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/test1.JPG)

15. Внесите изменения из произвольной ветки feature/add_reply в master через Merge 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/test2.JPG)


16. Убедитесь, что нет собранного артефакта в сборке по ветке master 
17. Настройте конфигурацию так, чтобы она собирала .jar в артефакты сборки 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/target.JPG)

18. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/test3.JPG)
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.5/img/nexus1.JPG)

19. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity 
20. В ответ предоставьте ссылку на репозиторий

[Ретозиторий](https://github.com/kirill-karagodin/example-teamcity/tree/master/.teamcity)