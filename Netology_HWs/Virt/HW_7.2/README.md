# devops-netology
### performed by Kirill Karagodin
#### HW7.2 Облачные провайдеры и синтаксис Terraform.

1. Регистрация в ЯО и знакомство с основами 
![](https://github.com/kirill-karagodin/devops-netology/blob/main/Netology_HWs/Virt/HW_7.2/yo.JPG)
````bash
root@vb-micrapc:~# yc config list
token: XXXXXXXXXXXXXXXXXXXXXXXX
cloud-id: b1g60ss3hrn8qqmiode2
folder-id: b1gfege9gjopte1c9qa1
compute-default-zone: ru-central1-a
root@vb-micrapc:~#
````

2. Создание yandex_compute_instance через терраформ.
````bash
root@vb-micrapc:/opt/terraform# terraform plan
data.yandex_compute_image.ubuntu: Reading...
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8qps171vp141hl7g9l]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.vm will be created
  + resource "yandex_compute_instance" "vm" {
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
          + cores         = 2
          + memory        = 2
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

Plan: 3 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + yandex_ip_private = (known after apply)
  + yandex_vpc_subnet = (known after apply)
  + yandex_zone       = (known after apply)

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
root@vb-micrapc:/opt/terraform#

````
При помощи какого инструмента (из разобранных на прошлом занятии) можно создать свой образ ami? 
[Packer](https://www.packer.io/)

Ссылку на репозиторий с исходной конфигурацией терраформа
[terraform](https://github.com/kirill-karagodin/devops-netology/tree/main/Netology_HWs/Virt/HW_7.2/src)