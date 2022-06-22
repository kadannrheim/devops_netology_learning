# Установка и настройка SonarQube -платформа с открытым исходным кодом для непрерывного анализа и измерения качества программного кода.
# ЗАПУСКАЙ sonar scanerпапке с sonar-project.properties
[sonar-scaner](https://binaries.sonarsource.com/?prefix=Distribution/sonar-scanner-cli/) - необходимо переименовать папку в sonarqube и добавить папку BIN в переменную $PATH обязательно (пример: `export PATH=$PATH:/mnt/c/sonarqube/bin`).
[Описаны все варианты установки](https://docs.sonarqube.org/latest/setup/install-server/) 
Должн стоять Java: `sudo apt-get install openjdk-11-jdk`
Ошибка "Could not find 'java' executable in JAVA_HOME or PATH."
Пример на Docker:
1. Выполняем `docker pull sonarqube:8.7-community`
2. Выполняем `docker run -d --name sonarqube -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true -p 9000:9000 sonarqube:8.7-community`
3. Ждём запуск, смотрим логи через `docker logs -f sonarqube`
4. Проверяем готовность сервиса через [браузер](http://localhost:9000)
5. Заходим под admin\admin, меняем пароль на свой
6. Создаём новый проект, название произвольное
2. Скачиваем пакет sonar-scanner, который нам предлагает скачать сам sonarqube
3. Делаем так, чтобы binary был доступен через вызов в shell (или меняем переменную PATH или любой другой удобный вам способ)
4. Проверяем `sonar-scanner --version`
5. Запускаем анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`
6. Смотрим результат в интерфейсе
7. Исправляем ошибки, которые он выявил(включая warnings)
8. Запускаем анализатор повторно - проверяем, что QG пройдены успешно

## Коротко
1. Создаём машину докер с sonarqube
2. Должна стоять Java
3. Скачан sonar-scaner
4. Прописан PATH для sonarscaner
5. Зайти на web интерфейс sonarqube, созжать проект/токен
6. Выполнить полученную строку для sonar-scaner в папке с тестируемым кодом, тоесть в этой папке лежит файл с программным кодом.
7. Исправлять код до отсутствия ошибок.
   