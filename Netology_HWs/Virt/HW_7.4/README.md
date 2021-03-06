# devops-netology
### performed by Kirill Karagodin
#### HW7.4 Средства командной работы над инфраструктурой..

1. Написать серверный конфиг для атлантиса.

Смысл задания – познакомиться с документацией о серверной конфигурации и конфигурации уровня репозитория.

Создай server.yaml который скажет атлантису:
- Укажите, что атлантис должен работать только для репозиториев в вашем github (или любом другом) аккаунте. 
- На стороне клиентского конфига разрешите изменять workflow, то есть для каждого репозитория можно будет указать свои 
дополнительные команды. 
- В workflow используемом по-умолчанию сделайте так, что бы во время планирования не происходил lock состояния.

Создай atlantis.yaml который, если поместить в корень terraform проекта, скажет атлантису:
- Надо запускать планирование и аплай для двух воркспейсов stage и prod. 
- Необходимо включить автопланирование при изменении любых файлов *.tf.

В качестве результата приложите ссылку на файлы server.yaml и atlantis.yaml.
[atlantis config](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Virt/HW_7.4/src/atlantis)

2. Знакомство с каталогом модулей.
- В каталоге модулей найдите официальный модуль от aws для создания `ec2` инстансов.
- Изучите как устроен модуль. Задумайтесь, будете ли в своем проекте использовать этот модуль или непосредственно 
ресурс `instance` без помощи модуля?
- В рамках предпоследнего задания был создан ec2 при помощи ресурса `instance`. Создайте аналогичный инстанс при
помощи найденного модуля.

Для работы с Yandex Cloud используется Yandex Compute Cloud (YC2 или YCC в некототры статьях) в замен мудуля AWS ЕС2.
Описание модуля и включение его в конфигурационный файл было взято из статьи
[terraform-yandex-compute](https://github-com.translate.goog/glavk/terraform-yandex-compute?ysclid=l5cir832kz637649126&_x_tr_sl=auto&_x_tr_tl=ru&_x_tr_hl=ru&_x_tr_pto=op)
Ссылка на репозиторий с файлами терраформ
[terraform](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Virt/HW_7.4/src/terraform-module)