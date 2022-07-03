provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id                 = "b1g60ss3hrn8qqmiode2"
  folder_id                = "b1gfege9gjopte1c9qa1"
  zone                     = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2004-lts"
}

resource "yandex_vpc_network" "net" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet"
  network_id     = resource.yandex_vpc_network.net.id
  v4_cidr_blocks = ["10.2.0.0/16"]
  zone           = "ru-central1-a"
}

resource "yandex_compute_instance" "ec2_netology" {
  name        = "netology"
  hostname    = "netology.local"
  platform_id = "standard-v1"
  count       = local.web_instance_count_map[terraform.workspace]

  lifecycle {
    create_before_destroy = true
  }

  resources {
    cores         = local.cores[terraform.workspace]
    memory        = local.memory[terraform.workspace]
    core_fraction = 100
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      type     = "network-hdd"
      size     = local.size[terraform.workspace]
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet.id
    nat       = true
    ipv6      = false
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

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

