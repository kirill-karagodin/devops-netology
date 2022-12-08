resource "yandex_compute_instance" "node04" {
  name                      = "node04"
  zone                      = "ru-central1-a"
  hostname                  = "node04.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = "${var.instance_cores}"
    memory = "${var.instance_memory}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-base}"
      name        = "root-node04"
      type        = "network-nvme"
      size        = "${var.instance_hdd}"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
    nat        = true
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
