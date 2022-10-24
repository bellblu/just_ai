Обязательная часть
1. Загрузил Java-приложения из репозитория, написал Dockerfile 
2. Сбилдил образ и и запушил его открытый репозиторий в https://hub.docker.com/repository/docker/mrandrbel/justai
3. Написал два docker-compose : docker-compose.yml использует образ из репозитория, .docker-compose.yml билдит.
4. Server A и Server B поднял в yandex cloud с помощью Terraform (terraform/main.tf),
    с созданием юзера test с правами root, и проброшенным ssh-key (terraform/user.yml)
5. В директории  ansible_1 находятся конфигурации и плейбук на настройку и запуск java приложения на сервере А
    5.1 setup_docker.yml включает в себя tasks для установки docker и docker-compose
    5.2 deploy_app.yml включает в себя копирование docker-compose.yml на сервер и его запуск
6. Подключившись на сервер A с запустил node-exporter:

wget https://github.com/prometheus/node_exporter/releases/download/v1.4.0/node_exporter-1.4.0.linux-amd64.tar.gz
tar xvfz node_exporter-1.4.0.linux-amd64.tar.gz
cd node_exporter-1.4.0.linux-amd64/
sudo cp node_exporter /usr/local/bin/node_exporter

создал service файл для запуска node exporter
sudo nano /etc/systemd/system/node_exporter.service

    [Unit]
    Description=Prometheus Node Exporter
    After=network.target

    [Service]
    Type=simple
    User=root
    Group=root

    ExecStart=/usr/local/bin/node_exporter
    Restart=always

    PrivateTmp=yes
    ProtectHome=yes
    NoNewPrivileges=yes

    ProtectSystem=strict
    ProtectControlGroups=true
    ProtectKernelModules=true
    ProtectKernelTunables=yes
    [Install]
    WantedBy=multi-user.target

запустил сервис 
      sudo  systemctl daemon-reload
      sudo service node_exporter start

7. по ssh подключился на server B
    7.1 установка Prometheus 
        sudo apt install prometheus
    7.2 установка Grafana
        sudo apt-get install libfontconfig1
        wget https://dl.grafana.com/oss/release/grafana_6.3.2_amd64.deb
        sudo dpkg -i grafana_6.3.2_amd64.deb

8. Настройка конфигаурации prometheus.yml

sudo nano /etc/prometheus/prometheus.yml

global:  
  scrape_interval:     15s 
  evaluation_interval: 15s

scrape_configs:
  - job_name: node
    static_configs:
      - targets:
        -  51.250.78.196:9100

  - job_name: app
    metrics_path: /actuator/prometheus
    static_configs:
      - targets:
        -  51.250.78.196:8080

 sudo systemctl reload prometheus

9. Настройка dashboard grafana
  Произвел импорт dashboard "10180"

Доступы:
  данные сервера были убиты с помощью terraform destroy для выполнения необязательной части тестового задания


Необязательная часть

1. Развернул облачный провайдер yandex cloud
2. Server A и Server B поднял в yandex cloud с помощью Terraform (terraform/main.tf),
    с созданием юзера test с правами root, и проброшенным ssh-key (terraform/user.yml)
3. В директории ansible_2 расположены конфигурации для настройки серверов. 
  
  Роль server_a включает в себя конфигурацию Server A:
    Реализована сборка docker образа через ansible.
    Конфигурация docker-compose по шаблону и запуск java и node-exportera с помощью docker-compose

  Роль server_b_doc_comp включает в себя конфигурацию Server B:
    установку docker и docker-compose на server B
    конфигурирование docker-compose prometheus.yml и по шаблону и запуск prometheus и grafana в docker
    С использование роли server_b_doc_comp не получилось настроить алерт. Была настроена dashbord (импорт dashboard "10180") в grafana
      для просмотра данных по метрикам node exporter
      данные сервера были удалины с помощью terraform destroy для дальнейшего конфигурирования server B с помощью роли server_b
  
  Роль server_b включает в себя конфигурацию Server B:
    установка и запуск prometheus, grafana и alertmanager на server B
    конфигурирование по шаблону prometheus.yml, alertmanager.yml () и alertmanager.service. Копирование на 
    сервер конфигурации условий оповещения rules.yml.
 
 4. Сервера для проверки предоставляю после конфигурации с использованием ролей server_a и server_b


