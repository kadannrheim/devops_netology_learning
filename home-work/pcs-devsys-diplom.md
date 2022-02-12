1.Создайте виртуальную машину Linux.
heim@crow2:~$ lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 20.04.3 LTS
Release:        20.04
Codename:       focal
heim@crow2:~$ uname -a
Linux crow2 5.4.0-94-generic #106-Ubuntu SMP Thu Jan 6 23:58:14 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux

'''
2.Установите ufw и разрешите к этой машине сессии на порты 22 и 443, при этом трафик на интерфейсе localhost (lo) должен ходить свободно на все порты.
heim@crow2:~$ sudo ufw allow 22
Rules updated
Rules updated (v6)
heim@crow2:~$ sudo ufw allow 443
Rules updated
Rules updated (v6)
heim@crow2:~$ sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup
heim@crow2:~$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
22                         ALLOW       Anywhere
443                        ALLOW       Anywhere
22/tcp (v6)                ALLOW       Anywhere (v6)
22 (v6)                    ALLOW       Anywhere (v6)
443 (v6)                   ALLOW       Anywhere (v6)

...
3.Установите hashicorp vault (инструкция по ссылке).
heim@crow2:~$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
heim@crow2:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Сущ:1 http://ru.archive.ubuntu.com/ubuntu focal InRelease
Пол:2 http://ru.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Пол:3 https://apt.releases.hashicorp.com focal InRelease [9 495 B]
Пол:4 http://ru.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Пол:5 https://apt.releases.hashicorp.com focal/main amd64 Packages [48,4 kB]
Пол:6 http://ru.archive.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Пол:7 http://ru.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1 572 kB]
Пол:8 http://ru.archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [902 kB]
Получено 2 868 kB за 4с (811 kB/s)
Чтение списков пакетов… Готово
heim@crow2:~$ sudo apt-get update && sudo apt-get install vault
Сущ:1 http://ru.archive.ubuntu.com/ubuntu focal InRelease
Сущ:2 http://ru.archive.ubuntu.com/ubuntu focal-updates InRelease
Сущ:3 http://ru.archive.ubuntu.com/ubuntu focal-backports InRelease
Сущ:4 http://ru.archive.ubuntu.com/ubuntu focal-security InRelease
Сущ:5 https://apt.releases.hashicorp.com focal InRelease
Чтение списков пакетов… Готово
Чтение списков пакетов… Готово
Построение дерева зависимостей
Чтение информации о состоянии… Готово
Следующие НОВЫЕ пакеты будут установлены:
  vault
Обновлено 0 пакетов, установлено 1 новых пакетов, для удаления отмечено 0 пакетов, и 44 пакетов не обновлено.
Необходимо скачать 69,4 MB архивов.
После данной операции объём занятого дискового пространства возрастёт на 188 MB.
Пол:1 https://apt.releases.hashicorp.com focal/main amd64 vault amd64 1.9.3 [69,4 MB]
Получено 69,4 MB за 36с (1 949 kB/s)
Выбор ранее не выбранного пакета vault.
(Чтение базы данных … на данный момент установлено 171245 файлов и каталогов.)
Подготовка к распаковке …/archives/vault_1.9.3_amd64.deb …
Распаковывается vault (1.9.3) …
Настраивается пакет vault (1.9.3) …
Generating Vault TLS key and self-signed certificate...
Generating a RSA private key
.....................................................................................................................................................................................................++++
.................................++++
writing new private key to 'tls.key'
-----
Vault TLS key and self-signed certificate have been generated in '/opt/vault/tls'.
heim@crow2:~$ systemctl status vault
● vault.service - "HashiCorp Vault - A tool for managing secrets"
     Loaded: loaded (/lib/systemd/system/vault.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
       Docs: https://www.vaultproject.io/docs/

...
4.Cоздайте центр сертификации по инструкции (ссылка) и выпустите сертификат для использования его в настройке веб-сервера nginx (срок жизни сертификата - месяц).

heim@crow2:~$ export VAULT_ADDR=http://127.0.0.1:8200
heim@crow2:~$ export VAULT_TOKEN=root
heim@crow2:~$ tee admin-policy.hcl <<EOF
> # Enable secrets engine
> path "sys/mounts/*" {
> capabilities = [ "create", "read", "update", "delete", "list" ]
> }
> # List enabled secrets engine
> path "sys/mounts" {
> capabilities = [ "read", "list" ]
> }
> # Work with pki secrets engine
> path "pki*" {
> capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
> }
> EOF
# Enable secrets engine
path "sys/mounts/*" {
capabilities = [ "create", "read", "update", "delete", "list" ]
}
# List enabled secrets engine
path "sys/mounts" {
capabilities = [ "read", "list" ]
}
# Work with pki secrets engine
path "pki*" {
capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}
heim@crow2:~$ vault policy write admin admin-policy.hcl
Success! Uploaded policy: admin
heim@crow2:~$ vault secrets enable pki
Success! Enabled the pki secrets engine at: pki/
heim@crow2:~$ vault secrets tune -max-lease-ttl=87600h pki
Success! Tuned the secrets engine at: pki/
heim@crow2:~$ vault write -field=certificate pki/root/generate/internal \
> common_name="example.com" \
> ttl=87600h > ca_cert.crt
heim@crow2:~$ vault write pki/config/urls \
> issuing_certificates="$VAULT_ADDR/v1/pki/ca" \
> crl_distribution_points="$VAULT_ADDR/v1/pki/crl"
Success! Data written to: pki/config/urls
heim@crow2:~$ vault secrets enable -path=pki_int pki
Success! Enabled the pki secrets engine at: pki_int/
heim@crow2:~$ vault secrets tune -max-lease-ttl=43800h pki_int
Success! Tuned the secrets engine at: pki_int/
heim@crow2:~$ vault write -format=json pki_int/intermediate/generate/internal \
> common_name="example.com Intermediate Authority" \
> | jq -r '.data.csr' > pki_intermediate.csr
heim@crow2:~$ vault write -format=json pki/root/sign-intermediate csr=@pki_intermediate.csr \
> format=pem_bundle ttl="43800h" \
> | jq -r '.data.certificate' > intermediate.cert.pem
heim@crow2:~$ vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem
Success! Data written to: pki_int/intermediate/set-signed
heim@crow2:~$ vault write pki_int/config/urls \
> issuing_certificates="$VAULT_ADDR/v1/pki_int/ca" \
> crl_distribution_points="$VAULT_ADDR/v1/pki_int/crl"
Success! Data written to: pki_int/config/urls
heim@crow2:~$ vault write pki_int/roles/example-dot-com \
> allowed_domains="example.com" \
> allow_subdomains=true \
> max_ttl="720h"
Success! Data written to: pki_int/roles/example-dot-com
heim@crow2:~$ json_crt=`vault write -format=json pki_int/issue/example-dot-com common_name="test.example.com" ttl="720h"`
heim@crow2:~$ echo $json_crt|jq -r '.data.certificate'>test.example.com.crt
heim@crow2:~$ echo $json_crt|jq -r '.data.private_key'>test.example.com.key
heim@crow2:~$ sudo cp ca_cert.crt /usr/local/share/ca-certificates/
heim@crow2:~$ sudo update-ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.

5.Установите корневой сертификат созданного центра сертификации в доверенные в хостовой системе.
heim@crow2:~$ sudo cp ca_cert.crt /usr/local/share/ca-certificates/
heim@crow2:~$ sudo update-ca-certificates
Updating certificates in /etc/ssl/certs...
1 added, 0 removed; done.
Running hooks in /etc/ca-certificates/update.d...
done.

6.Установите nginx.
heim@crow2:~$ sudo apt install nginx
heim@crow2:~$ sudo ufw app list
Available applications:
  Nginx Full
  Nginx HTTP
  Nginx HTTPS
  OpenSSH
heim@crow2:~$ sudo ufw allow 'Nginx Full'
Rule added
Rule added (v6)
heim@crow2:~$ systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset: enabled)
     Active: active (running) since Sat 2022-02-12 20:01:05 UTC; 30s ago
       Docs: man:nginx(8)
   Main PID: 102201 (nginx)
      Tasks: 2 (limit: 955)
     Memory: 3.9M
     CGroup: /system.slice/nginx.service
             ├─102201 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
             └─102202 nginx: worker process

фев 12 20:01:05 crow2 systemd[1]: Starting A high performance web server and a reverse proxy server.>
фев 12 20:01:05 crow2 systemd[1]: Started A high performance web server and a reverse proxy server.
lines 1-13/13 (END)

  
7.По инструкции (ссылка) настройте nginx на https, используя ранее подготовленный сертификат:
heim@crow2:~$ sudo mkdir /etc/nginx/ssl
heim@crow2:~$ sudo cp test.example.com.crt /etc/nginx/ssl
heim@crow2:~$ sudo cp test.example.com.key /etc/nginx/ssl
heim@crow2:~$ sudo nano /etc/nginx/sites-enabled/default
...
listen 443 ssl default_server;
server_name       test.example.com;
ssl_certificate     /etc/nginx/ssl/test.example.com.crt;
ssl_certificate_key /etc/nginx/ssl/test.example.com.key;
...

8.Откройте в браузере на хосте https адрес страницы, которую обслуживает сервер nginx.
Welcome to nginx!
If you see this page, the nginx web server is successfully installed and working. Further configuration is required.

For online documentation and support please refer to nginx.org.
Commercial support is available at nginx.com.

Thank you for using nginx.
![image](https://user-images.githubusercontent.com/67197701/153726783-5162fbb1-ac6c-412b-9f55-c4938d88170a.png)

9.Создайте скрипт, который будет генерировать новый сертификат в vault:
