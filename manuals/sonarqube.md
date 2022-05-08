# Установка и настройка SonarQube -платформа с открытым исходным кодом для непрерывного анализа и измерения качества программного кода.

[Описаны все варианты установки](https://docs.sonarqube.org/latest/setup/install-server/) 
Пример на Docker:
1. Выполняем `docker pull sonarqube:8.7-community`
2. Выполняем `docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community`
3. Ждём запуск, смотрим логи через `docker logs -f sonarqube`
4. Проверяем готовность сервиса через [браузер](http://localhost:9000)
5. Заходим под admin\admin, меняем пароль на свой
   