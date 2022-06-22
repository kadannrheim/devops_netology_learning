# Примеры настройки
## postgres 
docker pull postgres:14
docker volume create vol1  #путь /var/lib/docker/vol1
docker volume create vol2  #путь /var/lib/docker/vol2
docker run --rm --name pg-docker -e POSTGRES_PASSWORD=postgres -ti -p 5432:5432 -v vol1:/var/lib/postgresql/data -v vol2:/var/lib/postgresql/data2 postgres:12

> или через compose пример почти аналогичный:
```
version: '3.6'

volumes:
  data: {}
  backup: {}

services:

  postgres:
    image: postgres:14
    container_name: psql14
    ports:
      - "0.0.0.0:5433:5433"
    volumes:
      - data:/var/lib/postgresql/data14
      - backup:/media/postgresql/backup14
    environment:
      POSTGRES_USER: "test"
      POSTGRES_PASSWORD: "test123"
      POSTGRES_DB: "test_db"
    restart: always
```