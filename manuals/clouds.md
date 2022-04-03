# Yandex cloud
https://cloud.yandex.ru/docs/cli/quickstart

или 

* Скрипт установит CLI и добавит путь до исполняемого файла в переменную окружения PATH:
```
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
* yc --version - проверка версии, нужно пеерлогиниться после установки.
* https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb -получить токен в браузере.
* yc init -настройка профиля CLI и ввести полученный токен