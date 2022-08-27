# настройка клиента ubuntu 20.04
- `sudo apt install wireguard`
# Установить resolvconf для wg
`sudo apt install wireguard resolvconf`
# Для того, чтобы пакеты перенаправлялись туда, куда надо, нужно разрешить перенаправление сетевых пакетов на уровне ядра. Для этого откройте файл /etc/sysctl.conf и добавьте в конец такие строки:
 - `sudo nano /etc/sysctl.conf`
 ```
 net.ipv4.ip_forward = 1
net.ipv6.conf.default.forwarding = 1
net.ipv6.conf.all.forwarding = 1
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.proxy_arp = 0
net.ipv4.conf.default.send_redirects = 1
net.ipv4.conf.all.send_redirects = 0
 ```
# Затем необходимо выполнить команду sysctl -p чтобы система перечитала конфигурацию:
- `sysctl -p`
# Конфигурационный файл клиента
- `sudo nano /etc/wireguard/wg0.conf` -wg0 произволльное имя
```
[Interface]
PrivateKey = (приватный ключ клиента, сгенерированный ранее)
Address = 10.66.66.22/24 (IP адрес интерфейса wg0 клиента)
DNS = 8.8.8.8,8.8.4.4
[Peer]
PublicKey = (публичный ключ сервера, к которому надо подключится))
Endpoint = (здесь надо указать IP адрес сервера, на котором установлен WireGuard и порт)
AllowedIPs = 0.0.0.0/0,::/0 -IP адреса, трафик с которых будет перенаправляться в сеть VPN, в данном примере выбраны все адреса.
```
# Программа использует UDP, нужно разрешить подключение к этому порту
sudo ufw allow 63665/udp
sudo ufw status
# Запуск сервера
`sudo wg-quick up wg0`
# Gосмотреть статистику по подключению с помощью команды
`sudo wg show`
# Отключить соединение
`sudo wg-quick down wg0`


# Автоматический с web интерфейсом по скрипту
bash <(curl -Ls https://github.com/firezone/firezone/raw/master/scripts/install.sh)

