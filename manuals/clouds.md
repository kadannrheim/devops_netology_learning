# Yandex cloud
https://cloud.yandex.ru/docs/cli/quickstart

или 

* Скрипт установит CLI и добавит путь до исполняемого файла в переменную окружения PATH:
```
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
* yc --version - проверка версии, нужно пеерлогиниться после установки.
* [https://oauth.yandex.ru/authorize?response_type=token&client_id=b1gsgr4keg8cp3dtm059 ](https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token)-получить токен в браузере.
* yc init -настройка профиля CLI и ввести полученный токен
* ### Инициализация сети
yc vpc network create \
--name net \
--labels my-label=netology \
--description "my first network via yc"
* yc iam service-account list

### Инициализация подсети
yc vpc subnet create \
--name my-subnet-a \
--zone ru-central1-a \
--range 10.1.2.0/24 \
--network-name net \
--description "my first subnet via yc"

* yc config list

### 
yc config set token [токен CLI яндекса]
yc config profile create sa-profile
yc config set service-account-key key.json
yc config list