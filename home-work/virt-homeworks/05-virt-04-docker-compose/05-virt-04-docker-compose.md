# Задача 1
Создать собственный образ операционной системы с помощью Packer.

Для получения зачета, вам необходимо предоставить:

Скриншот страницы, как на слайде из презентации (слайд 37).

## Решение задачи 1
### Установка PACKER
https://www.packer.io/downloads
```
* curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
* sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
* sudo apt-get update && sudo apt-get install packer
```
* packer --version -просмотр версии

### Установка TERRAFORM
* [Мануал](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  
 или
* sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
* curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
* sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
* sudo apt-get update && sudo apt-get install terraform
* terraform --version

### Установка YC
https://cloud.yandex.ru/docs/cli/quickstart
или 
* Скрипт установит CLI и добавит путь до исполняемого файла в переменную окружения PATH:
```
curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash
```
* yc --version - проверка версии, нужно пеерлогиниться после установки.
```
heim@crow:~$ yc --version
Yandex Cloud CLI 0.89.0 linux/amd64
```
```
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src$ (main)yc init
Welcome! This command will take you through the configuration process.
Pick desired action:
 [1] Re-initialize this profile 'netology' with new settings
 [2] Create a new profile
 [3] Switch to and re-initialize existing profile: 'default'
Please enter your numeric choice: 1
Please go to https://oauth.yandex.ru/authorize?response_type=token&client_id=1a6990aa636648e9b2ef855fa7bec2fb in order to obtain OAuth token.

Please enter OAuth token: [AQAAAAAhN*********************BFmg_1gzs] AQAA##############dNufpU9enUBFmg_1gzs
You have one cloud available: 'cloud-alifanovea' (id = b1gsgr4keg8cp3dtm059). It is going to be used by default.
Please choose folder to use:
 [1] default (id = b1gnobiebevf7he8kdau)
 [2] Create a new folder
Please enter your numeric choice: 2
Please enter a folder name: netology
Your current folder has been set to 'netology' (id = b1germtpul6t5a784q42).
Do you want to configure a default Compute zone? [Y/n] 1
Please enter 'yes' or 'no': yes
Which zone do you want to use as a profile default?
 [1] ru-central1-a
 [2] ru-central1-b
 [3] ru-central1-c
 [4] Don't set default zone
Please enter your numeric choice: 1
Your profile default Compute zone has been set to 'ru-central1-a'.
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src$ (main)yc vpc network create \
> --name net \
> --labels my-label=netology \
> --description "my first network via yc"
id: enpmc19qubjjo7as01eg
folder_id: b1germtpul6t5a784q42
created_at: "2022-04-06T19:30:35Z"
name: net
description: my first network via yc
labels:
  my-label: netology

heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src$ (main)yc vpc subnet create \
> --name my-subnet-a \
> --zone ru-central1-a \
> --range 10.1.2.0/24 \
> --network-name net \
> --description "my first subnet via yc"
id: e9b8h4b7k5dgeur3pv58
folder_id: b1germtpul6t5a784q42
created_at: "2022-04-06T19:30:44Z"
name: my-subnet-a
description: my first subnet via yc
network_id: enpmc19qubjjo7as01eg
zone_id: ru-central1-a
v4_cidr_blocks:
- 10.1.2.0/24

heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/packer$ (main)yc config list
token: AQAAAA############dNufpU9enUBFmg_1gzs
cloud-id: b1gsgr4keg8cp3dtm059
folder-id: b1germtpul6t5a784q42
compute-default-zone: ru-central1-a
```
редактирую файл centos-7-base.json
```
packer validate centos-7-base.json
packer build centos-7-base.json
```
### просмотр доступных образов
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/packer$ (main)yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd8np3p8c3ci2vginsr6 | centos-7-base | centos | f2esd9f5o5i9p7pkkk8k | READY  |
+----------------------+---------------+--------+----------------------+--------+

[Итоговый скриншот](https://github.com/kadannrheim/devops-netology/blob/314b3c833564d20c3431e1bdc3343e1c96dfbc22/home-work/virt-homeworks/screenshots/05-virt-04-docker-compose-packer1.png)
# Задача 2
Создать вашу первую виртуальную машину в Яндекс.Облаке.

Для получения зачета, вам необходимо предоставить:

Скриншот страницы свойств созданной ВМ, как на примере ниже:

## Решение задачи 2
```
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)ls
network.tf  node01.tf  output.tf  provider.tf  variables.tf
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.73.0...

- Installed yandex-cloud/yandex v0.73.0 (self-signed, key ID E40F590B50BB8E40)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc compute image list
+----------------------+---------------+--------+----------------------+--------+
|          ID          |     NAME      | FAMILY |     PRODUCT IDS      | STATUS |
+----------------------+---------------+--------+----------------------+--------+
| fd8np3p8c3ci2vginsr6 | centos-7-base | centos | f2esd9f5o5i9p7pkkk8k | READY  |
+----------------------+---------------+--------+----------------------+--------+

heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc iam service-account create --name my-robot \
>   --description "this is my favorite service account"
id: ajet68j1sgtpbn9e5gnm
folder_id: b1germtpul6t5a784q42
created_at: "2022-04-07T19:36:52.694803192Z"
name: my-robot
description: this is my favorite service account

heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc iam service-account list
+----------------------+----------+
|          ID          |   NAME   |
+----------------------+----------+
| ajet68j1sgtpbn9e5gnm | my-robot |
+----------------------+----------+

heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc iam key create --service-account-name my-robot --output key.json
id: ajefn7nkkp3o487ol7bv
service_account_id: ajet68j1sgtpbn9e5gnm
created_at: "2022-04-07T19:38:12.575404302Z"
key_algorithm: RSA_2048

heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc config profile create sa-profile
Profile 'sa-profile' created and activated
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc config set service-account-key key.json
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc config list
service-account-key:
  id: ajefn7nkkp3o487ol7bv
  service_account_id: ajet68j1sgtpbn9e5gnm
  created_at: "2022-04-07T19:38:12.575404302Z"
  key_algorithm: RSA_2048
  public_key: |
    -----BEGIN PUBLIC KEY-----
    ...
    -----END PUBLIC KEY-----
  private_key: |
    -----BEGIN PRIVATE KEY-----
    MIIEvQIBADANBgkqhk...
    -----END PRIVATE KEY-----
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc config set cloud-id b1gsgr4keg8cp3dtm059
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)yc config set folder-id b1germtpul6t5a784q42
heim@crow:/mnt/d/gitvscode/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/terraform$ (main)terraform plan

Terraform used the selected providers to generate the following execution plan.
Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.node01 will be created
  + resource "yandex_compute_instance" "node01" {
      + allow_stopping_for_update = true
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "node01.netology.cloud"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                centos:ssh-rsa ...
            EOT
        }
      + name                      = "node01"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8ft6norj68lo29qlpi"
              + name        = "root-node01"
              + size        = 50
              + snapshot_id = (known after apply)
              + type        = "network-nvme"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 8
          + memory        = 8
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.default will be created
  + resource "yandex_vpc_network" "default" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.default will be created
  + resource "yandex_vpc_subnet" "default" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "192.168.101.0/24",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_node01_yandex_cloud = (known after apply)
  + internal_ip_address_node01_yandex_cloud = (known after apply)

────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.

...
yandex_vpc_network.default: Creating...
yandex_vpc_network.default: Creation complete after 2s [id=enps71cg6u1q8e9gkj2j]
yandex_vpc_subnet.default: Creating...
yandex_vpc_subnet.default: Creation complete after 1s [id=e9bomlb5dddn21v1plnu]
yandex_compute_instance.node01: Creating...
yandex_compute_instance.node01: Still creating... [10s elapsed]
yandex_compute_instance.node01: Still creating... [20s elapsed]
yandex_compute_instance.node01: Still creating... [30s elapsed]
yandex_compute_instance.node01: Still creating... [40s elapsed]
yandex_compute_instance.node01: Creation complete after 45s [id=fhmuqhmf2kh4rakpa0l7]

Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01_yandex_cloud = "51.250.70.143"
internal_ip_address_node01_yandex_cloud = "192.168.101.25"
```
[итоговый скриншот](https://github.com/kadannrheim/devops-netology/blob/7380828f5ab486097978bdd583a494d6a531298c/home-work/virt-homeworks/screenshots/05-virt-04-docker-compose-tarraform1.png)
[Итоговый скриншот вторая сборка](https://github.com/kadannrheim/devops-netology/blob/97299c9f3d63e4be5b7a7fe1310330e9b26a5b61/home-work/virt-homeworks/screenshots/05-virt-04-docker-compose-tarraform2.png)
# Задача 3
Создать ваш первый готовый к боевой эксплуатации компонент мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить:

Скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже

## Решение задачи 3
```
kadannr@wcrow:~/git/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/ansible(main)$ ansible-playbook provision.yml

PLAY [nodes] *****************************************************************************************************************************

TASK [Gathering Facts] *******************************************************************************************************************
ok: [node01.netology.cloud]

TASK [Create directory for ssh-keys] *****************************************************************************************************
ok: [node01.netology.cloud]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] **************************************************************************************
ok: [node01.netology.cloud]

TASK [Checking DNS] **********************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Installing tools] ******************************************************************************************************************
changed: [node01.netology.cloud] => (item=git)
ok: [node01.netology.cloud] => (item=curl)

TASK [Add docker repository] *************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Installing docker package] *********************************************************************************************************
changed: [node01.netology.cloud] => (item=docker-ce)
ok: [node01.netology.cloud] => (item=docker-ce-cli)
ok: [node01.netology.cloud] => (item=containerd.io)

TASK [Enable docker daemon] **************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Install docker-compose] ************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Synchronization] *******************************************************************************************************************
changed: [node01.netology.cloud]

TASK [Pull all images in compose] ********************************************************************************************************
changed: [node01.netology.cloud]

TASK [Up all services in compose] ********************************************************************************************************
changed: [node01.netology.cloud]

PLAY RECAP *******************************************************************************************************************************
node01.netology.cloud      : ok=12   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

kadannr@wcrow:~/git/devops-netology/home-work/virt-homeworks/05-virt-04-docker-compose/src/ansible(main)$ cat inventory
[nodes:children]
manager

[manager]
node01.netology.cloud ansible_host=51.250.84.52
```
[итоговый скриншот](https://github.com/kadannrheim/devops-netology/blob/97299c9f3d63e4be5b7a7fe1310330e9b26a5b61/home-work/virt-homeworks/screenshots/05-virt-04-docker-compose-ansible1.png)
