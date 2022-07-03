# devops-netology
### performed by Kirill Karagodin
#### HW7.3 Основы и принцип работы Терраформ.

Инициализируем проект и создаем воркспейсы.

1. Выполните `terraform init`
````bash
root@vb-micrapc:/opt/terraform# terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.70.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
root@vb-micrapc:/opt/terraform# 
````
2. Создайте два воркспейса `stage` и `prod`.
````bash
root@vb-micrapc:/opt/terraform# terraform workspace new stage
Created and switched to workspace "stage"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
root@vb-micrapc:/opt/terraform# terraform workspace new prod
Created and switched to workspace "prod"!

You're now on a new, empty workspace. Workspaces isolate their state,
so if you run "terraform plan" Terraform will not see any existing state
for this configuration.
root@vb-micrapc:/opt/terraform# terraform workspace select prod
root@vb-micrapc:/opt/terraform# terraform workspace list
  default
* prod
  stage

root@vb-micrapc:/opt/terraform#
````
3. В уже созданный instance добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
````bash
resource "yandex_compute_instance" "ec2_netology" {
  name        = "netology"
  hostname    = "netology.local"
  platform_id = "standard-v1"
  count       = local.web_instance_count_map[terraform.workspace]

  lifecycle {
    create_before_destroy = true
  }
````
4. При желании поэкспериментируйте с другими параметрами и рессурсами.
Блок `Locals`
````bash
locals {
  web_instance_count_map = {
    stage = 1
    prod = 2
  }
  cores ={
    stage = 2
    prod = 4
  }
  memory = {
    stage = 2
    prod = 4
  }
  size = {
    stage = 10
    prod = 20
  }
}
````
5. Вывод команды `terraform plan` для воркспейса `prod`.

Проверяем что выбран `prod` и выполняем `terraform plan`
````bash
root@vb-micrapc:/opt/terraform# terraform workspace list
  default
* prod
  stage

root@vb-micrapc:/opt/terraform# terraform plan
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8qps171vp141hl7g9l]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.ec2_netology[0] will be created
  + resource "yandex_compute_instance" "ec2_netology" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "netology.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5fv0bnsSvpCop92ETbhAlblg3XMcKH3H75ntZK81f1mjzR9GLjiF0ZSMSVvts+SR3F40j2sGS8QUR/+Tbt3nmrBF5GCHN8pGF1OwUgpNpBfVD0c7wqOeDWuGQdnSiVz4JY5bOHg3ROGQwFX71pKa0XZ3QNHMsuwTpxv8aajPQlBdVDB3D0C1rdJABNqgECdHBVCCc0pDjpleC46m6KFpp91sA8Tr4KHEb25tD5DcZ3lIO+uMVdBBeYRHupwa6743LiAJYlJHbwVWSLKrryxZG/PkseXwD91BuFpTyrlW4QPHWi7RQskGdPiMjgiPDkTPp5e4M2K+ncJNTvKoGqmsb root@vb-micrapc
            EOT
        }
      + name                      = "netology"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8qps171vp141hl7g9l"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.ec2_netology[1] will be created
  + resource "yandex_compute_instance" "ec2_netology" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = "netology.local"
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC5fv0bnsSvpCop92ETbhAlblg3XMcKH3H75ntZK81f1mjzR9GLjiF0ZSMSVvts+SR3F40j2sGS8QUR/+Tbt3nmrBF5GCHN8pGF1OwUgpNpBfVD0c7wqOeDWuGQdnSiVz4JY5bOHg3ROGQwFX71pKa0XZ3QNHMsuwTpxv8aajPQlBdVDB3D0C1rdJABNqgECdHBVCCc0pDjpleC46m6KFpp91sA8Tr4KHEb25tD5DcZ3lIO+uMVdBBeYRHupwa6743LiAJYlJHbwVWSLKrryxZG/PkseXwD91BuFpTyrlW4QPHWi7RQskGdPiMjgiPDkTPp5e4M2K+ncJNTvKoGqmsb root@vb-micrapc
            EOT
        }
      + name                      = "netology"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = (known after apply)

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd8qps171vp141hl7g9l"
              + name        = (known after apply)
              + size        = 20
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = false
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + placement_group_id = (known after apply)
        }

      + resources {
          + core_fraction = 100
          + cores         = 4
          + memory        = 4
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_vpc_network.net will be created
  + resource "yandex_vpc_network" "net" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "net"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.subnet will be created
  + resource "yandex_vpc_subnet" "subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.2.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 4 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
root@vb-micrapc:/opt/terraform#

````
Ссылку на репозиторий конфигурацией терраформа
[terraform](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Virt/HW_7.3/src)

