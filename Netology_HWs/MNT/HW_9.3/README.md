# devops-netology
### performed by Kirill Karagodin
#### HW 9.3 Процессы CI/CD.

### Подготовка:

Создаем виртуальные машины

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/img/vms.JPG)

Запускаем playbook? ждем окончания работы

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/img/sonar.JPG)

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/img/nexus.JPG)


### Знакомоство с SonarQube
 
1. Создаём новый проект, название произвольное

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/img/sonar-project.JPG)

2. Скачиваем пакет `sonar-scanner`, который нам предлагает скачать сам sonarqube 
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам 
способ)
````bash
root@vb-micrapc:/opt/src_9.3/infrastructure# cd ../sonar-scanner-4.7.0.2747-linux/
root@vb-micrapc:/opt/src_9.3/sonar-scanner-4.7.0.2747-linux# cd bin/
root@vb-micrapc:/opt/src_9.3/sonar-scanner-4.7.0.2747-linux/bin# export PATH=$PATH:$(pwd)
````
4. Проверяем `sonar-scanner --version` 
````bash
root@vb-micrapc:/opt/src_9.3/sonar-scanner-4.7.0.2747-linux/bin# sonar-scanner --version
INFO: Scanner configuration file: /opt/src_9.3/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
INFO: Linux 5.15.0-39-generic amd64
root@vb-micrapc:/opt/src_9.3/sonar-scanner-4.7.0.2747-linux/bin#

````
5. Запускаем анализатор против кода из директории example с дополнительным ключом -Dsonar.coverage.exclusions=fail.py 
````bash
root@vb-micrapc:/opt/src_9.3/example# sonar-scanner \
  -Dsonar.projectKey=netology \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://178.154.207.225:9000 \
  -Dsonar.login=29e91790aa6fe2de71f2f603a3daf0589d147a23
INFO: Scanner configuration file: /opt/src_9.3/sonar-scanner-4.7.0.2747-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.7.0.2747
INFO: Java 11.0.14.1 Eclipse Adoptium (64-bit)
.....................
INFO: ANALYSIS SUCCESSFUL, you can browse http://178.154.207.225:9000/dashboard?id=netology
INFO: Note that you will be able to access the updated dashboard once the server has processed the submitted analysis report
INFO: More about the report processing at http://178.154.207.225:9000/api/ce/task?id=AYOJqa3UZrjPlK8Cac4b
INFO: Analysis total time: 5.601 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 22.298s
INFO: Final Memory: 7M/27M
INFO: ------------------------------------------------------------------------
root@vb-micrapc:/opt/src_9.3/example# 
````
6. Смотрим результат в интерфейсе 

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/img/netology1.JPG)

7. Исправляем ошибки, которые он выявил(включая warnings)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно 
9. Делаем скриншот успешного прохождения анализа, прикладываем к решению ДЗ

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/img/netology2.JPG)

### Знакомство с Nexus

1. В репозиторий maven-releases загружаем артефакт с GAV параметрами
2. В него же загружаем такой же артефакт, но с version: 8_102
3. Проверяем, что все файлы загрузились успешно

![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/img/nexus1.JPG)

4. В ответе присылаем файл `maven-metadata.xml` для этого артефекта

[maven-metadata.xml](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/src/maven-metadata.xml)

### Знакомство с Maven

#### Подготовка к выполнению

1. Скачиваем дистрибутив с maven
2. Разархивируем, делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой 
другой удобный вам способ)
````bash
root@vb-micrapc:/opt/src_9.3/apache-maven-3.8.6/bin# export PATH=$PATH:$(pwd)
root@vb-micrapc:/opt/src_9.3/apache-maven-3.8.6/bin#
````
3. Удаляем из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем http соединение( раздел 
mirrors->id: my-repository-http-blocker)
4. Проверяем `mvn --version`
````bash
root@vb-micrapc:/opt/src_9.3/apache-maven-3.8.6/conf# mvn --version
Apache Maven 3.8.6 (84538c9988a25aec085021c365c560670ad80f63)
Maven home: /opt/src_9.3/apache-maven-3.8.6
Java version: 11.0.14.1, vendor: Ubuntu, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: ru_RU, platform encoding: UTF-8
OS name: "linux", version: "5.15.0-39-generic", arch: "amd64", family: "unix"
root@vb-micrapc:/opt/src_9.3/apache-maven-3.8.6/conf#
````
5. Забираем директорию mvn с pom

#### Основная часть

1. Меняем в `pom.xml` блок с зависимостями под наш артефакт из первого пункта задания для Nexus (java с версией 8_282)
````bash
root@vb-micrapc:/opt/src_9.3/mvn# cat pom.xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.netology.app</groupId>
  <artifactId>simple-app</artifactId>
  <version>1.0-SNAPSHOT</version>
   <repositories>
    <repository>
      <id>my-repo</id>
      <name>maven-releases</name>
      <url>http://178.154.205.179:8081/repository/maven-releases/</url>
    </repository>
  </repositories>
  <dependencies>
    <dependency>
      <groupId>netology</groupId>
      <artifactId>java</artifactId>
      <version>8_282</version>
      <classifier>distrib</classifier>
      <type>tar.gz</type>
    </dependency>
  </dependencies>
</project>
root@vb-micrapc:/opt/src_9.3/mvn#
````
2. Запускаем команду `mvn package` в директории с `pom.xml`, ожидаем успешного окончания
````bash
root@vb-micrapc:/opt/src_9.3/mvn# mvn package
...........
[INFO] Building jar: /opt/src_9.3/mvn/target/simple-app-1.0-SNAPSHOT.jar
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  11.550 s
[INFO] Finished at: 2022-09-29T17:27:43Z
[INFO] ------------------------------------------------------------------------
root@vb-micrapc:/opt/src_9.3/mvn#
````
3. Проверяем директорию `~/.m2/repository/`, находим наш артефакт
````bash
root@vb-micrapc:/opt/src_9.3/mvn# ls -lha ~/.m2/repository/netology/java/8_282/
total 440K
drwxr-xr-x 2 root root 4,0K сен 29 17:27 .
drwxr-xr-x 3 root root 4,0K сен 29 17:27 ..
-rw-r--r-- 1 root root 418K сен 29 17:27 java-8_282-distrib.tar.gz
-rw-r--r-- 1 root root   40 сен 29 17:27 java-8_282-distrib.tar.gz.sha1
-rw-r--r-- 1 root root  398 сен 29 17:27 java-8_282.pom.lastUpdated
-rw-r--r-- 1 root root  175 сен 29 17:27 _remote.repositories
root@vb-micrapc:/opt/src_9.3/mvn#
````
4. В ответе присылаем исправленный файл `pom.xml`

[pom.xml](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/MNT/HW_9.3/src/mvn/pom.xml)