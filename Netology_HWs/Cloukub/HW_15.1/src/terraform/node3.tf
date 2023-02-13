resource "yandex_compute_instance" "node3" {
  name                      = "${var.node3}"
  zone                      = "ru-central1-a"
  hostname                  = "${var.node3}.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = "${var.instance_cores}"
    memory = "${var.instance_memory}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.image_node3}"
      name        = "root-${var.node3}"
      type        = "network-nvme"
      size        = "${var.instance_hdd}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-2.id}"
    nat       = false
  }

  metadata = {
    ssh-keys = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
  }
}

