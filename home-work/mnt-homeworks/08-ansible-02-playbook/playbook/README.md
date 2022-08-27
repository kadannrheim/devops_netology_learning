# Playbook 
## Что делает
Данный плейбук устанавливает java, elasticsearch и kibana 
## Параметры
Для работы плейбука потребуется:
- Запустить тестовую среду `docker compose up` ([docker-compose.yml](./docker-compose.yml))
- Загрузить [java](https://www.oracle.com/java/technologies/javase-jdk11-downloads.html) и расположить его в playbook/files/
- Указать версионность java в group_vars/all/vars.yml
- Указать версионность ELK в group_vars/elasticsearch/vars.yml
## Теги
- java
- elastic
- kibana
