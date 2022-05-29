# snap пакеты в ubuntu 20.04
## Пути: /snap/bin/ или /var/lib/snapd/snap/bin/
## оф. документация https://snapcraft.io/docs/snapshots
## установка snap ubuntu 20.04 https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-nextcloud-on-ubuntu-18-04-ru
## Основные команды

# Скрипт установки nextcloud snap в ubuntu 20.04. Где [заменить на своё]. Подрорбное описание в "установка snap ubuntu 20.04".
```
#!/bin/sh
### System Setup ###
apt update
sudo apt install -y snapd
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install nextcloud
sudo nextcloud.manual-install [name]] [password]
sudo nextcloud.occ config:system:set trusted_domains 1 --value=[domen-name]]
sudo nextcloud.occ config:system:get trusted_domains
snap changes nextcloud
sudo ufw allow 80,443/tcp
sudo nextcloud.enable-https lets-encrypt
```

`service snapd status` -проверка службы



`sudo apt install snapd` -установить менеджер пакетов snap
`sudo ln -s /var/lib/snapd/snap /snap` -После установки для включения возможности установки классических приложений через snap надо создать символическую ссылку на /var/lib/snapd/snap в корне:
`sudo snap install snap-store` -установить магазин приложений snap-store
`snap find chromium` -Чтобы найти нужный пакет или посмотреть есть ли он в магазине приложений snap используйте команду find
`snap info chromium` -посмотреть информацию о пакете
`sudo snap install chromium` -установить snap пакет
`snap connections chromium` -По умолчанию приложение может получить доступ только к тем частям системы, к которым у него подключены интерфейсы. Эти подключения устанавливаются автоматически во время установки пакета. Посмотреть их можно командой connections
`sudo snap install --classic atom` -Иногда для приложений недостаточно такого уровня доступа. Тогда для них используется уровень безопасности classic. В этом режиме приложение получает доступ к системным ресурсам как любые другие системные программы. Для установки таких программ надо использовать опцию --classic, иначе установить их не получится
`sudo snap remove chromium` -Удалить snap пакет 
`snap list` -посмотреть все пакеты, установленные в системе
`snap list --all opera` -Многие из программ Ubuntu и Gnome уже поставляются в виде snap и их уже нельзя установить из обычных репозиториев. С помощью опции --all можно посмотреть все доступные версии определённого пакета
`snap changes` -посмотреть историю изменений, внесенных, в систему с помощью этого пакетного менеджера
`sudo snap refresh opera` -обновить пакет snap, до более новой версии
`sudo snap refresh` -обновления всех пакетов
`sudo snap revert opera` -Если обновление вам не понравилось, вы можете откатить версию всех пакетов или одного из них до предыдущей

# save
sudo snap save [имя] -создать точку восстановления
`sudo snap saved` -показать сохраненные точки сохранения
`snap list` -показать установленные пакеты
`snap set system snapshots.automatic.retention=30h` -таймер удаления точек восстановления чеерз указанное время.
`snap forget [number point]` -удалить точку по номеру