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
heim@crow2:~$ sudo vault server -dev
heim@crow2:~$ sudo nano /etc/vault.d/vault.hcl
heim@crow2:~$ cat /etc/vault.d/vault.hcl
---

# HTTP listener
listener "tcp" {
  address = "127.0.0.1:8210"
  tls_disable = 1
}

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8211"
  tls_cert_file = "/opt/vault/tls/tls.crt"
  tls_key_file  = "/opt/vault/tls/tls.key"
}


---
root@crow2:~# systemctl restart vault
root@crow2:~# export VAULT_ADDR=http://127.0.0.1:8210
root@crow2:~# vault status
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.9.3
Storage Type       file
HA Enabled         false
root@crow2:~# vault operator init
Unseal Key 1: yAYP/mCwotpHb7KOGXsg2wFgbMwUyOX4L4DzGUr+uv2k
Unseal Key 2: fPPGdX6xtBvtGNp1rUXpPRoMvLeflZF4okIL6PNDE/Hl
Unseal Key 3: JoSeThNF0P1uuM3gDb0LwhpBRFA4XjdX+gIAOvrq+x4s
Unseal Key 4: YgQJzryXo2ae83DB0RL9Ify8TYSlgKEfGVwXJBLab27/
Unseal Key 5: MztjRRe20W/AFStZ/nZfcTd5pq2BGi7KyxBh2Tcfx90j

Initial Root Token: s.4K4GqYZMAJYEkKGRHX6l6lub

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 keys to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
root@crow2:~# vault operator unseal
Unseal Key (will be hidden):
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    1/3
Unseal Nonce       3bf2a39d-f1d7-b690-c71e-26ff670ebc0b
Version            1.9.3
Storage Type       file
HA Enabled         false
root@crow2:~# vault operator unseal
Unseal Key (will be hidden):
Key                Value
---                -----
Seal Type          shamir
Initialized        true
Sealed             true
Total Shares       5
Threshold          3
Unseal Progress    2/3
Unseal Nonce       3bf2a39d-f1d7-b690-c71e-26ff670ebc0b
Version            1.9.3
Storage Type       file
HA Enabled         false
root@crow2:~# vault operator unseal
Unseal Key (will be hidden):
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.9.3
Storage Type    file
Cluster Name    vault-cluster-fa69170f
Cluster ID      914c1345-300e-53de-1620-8936674fd4e4
HA Enabled      false
