# Установка производится на ОС Linux или встроенную Ubuntu 20 в Windows 10
```
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get install ansible
```

# Ошибки
## Убрать ошибку "Are you sure you want to continue connecting (yes/no/[fingerprint])? null_resource.squid: Still creating... [10s elapsed]". https://ask-dev.ru/info/81968/how-to-ignore-ansible-ssh-authenticity-checking
Если Вы работали с сервером по ssh, то наверняка знаете о такой штуке как known hosts. Это та самая штука, которая запоминает отпечатки (fingerprint) всех серверов, которые Вы посещаете и не поволяет сливать пароли и секретные ключи, если отпечаток не совпал. Она просто Вас не пустит дальше, обьясняя это тем, что Вас пытаются обмануть. (аутентичная проверка подлинности SSH), можно убрать эту проверку создав в папке с ansible файл ansible.cfg с параметрами:
```
[defaults]
host_key_checking = False
```
или https://adment.org.ua/admin/79-ssh-known-hosts-removal
Можно стереть запись про этот сервер на клиенте. Проще всего это сделать командой (Но это удалит данные про все сервера. Расположение файла может быть и другим, если в конфиге ssh указано это директивой UserKnownHostsFile):

`$ rm ~/.ssh/known_hosts`

Если же Вам нужно удалить конкретный хост, то почему бы не открыть файл в текстовом редакторе и не удалить нужную строчку. Ну что, логично и так можно сделать, если у Вас на клиенте не включена опция HashKnownHosts. Если же она включена, то найти нужную строчку будет проблематично.

Но удалить запись всё-таки можно, командой:
`$ ssh-keygen -R host.com`