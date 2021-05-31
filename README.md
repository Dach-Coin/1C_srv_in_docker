# 1c-enterprise-server in Docker

## Порядок установки

1. Устанавливаем Docker (Docker Desktop для Windows или Docker для Linux)

2. В каталог `./1c_distrib` скачиваем deb-пакеты требуемого релиза платформы (скачать tar.gz, распаковать все .deb)

3. Создаем каталоги `./1c-server-home` и `./1c-server-logs`

4. При необходимости можно изменить порты в `Dockerfile` и в `docker-entrypoint.sh`

5. Также, при необходимости, меняем номер версии платформы и сервера, в файлах `Dockerfile` и `docker-compose.yml`

6. Собираем образ: `docker build -t ImageName ./`, например: `docker build -t server1c-8.3.18.1289 ./`

7. Указываем `ImageName` в docker-compose.yml, например: `image: server1c-8.3.18.1289:latest`

8. Компонуем контейнер:
    - `docker compose up -d` (команда для Windows)
    - `docker-compose up -d` (команда для linux, потребуется предварительная установка утилиты docker-compose, а также изменить тег `version` в docker-compose.yml: `version: "3.3"`)

### Примечание

Сервер 1С, поднятый в Docker - недоступен для подключения 1С-клиентов (или консоли msc), стартующих на том же хосте, что и docker-сервис.
Пояснение: https://github.com/1C-Company/docker_fresh/issues/7
