resource "yandex_compute_instance" "node2" {
  name                      = "${var.node2}"
  zone                      = "ru-central1-a"
  hostname                  = "${var.node2}.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = "${var.instance_cores}"
    memory = "${var.instance_memory}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.image_node2}"
      name        = "root-${var.node2}"
      type        = "network-nvme"
      size        = "${var.instance_hdd}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  metadata = {
    ssh-keys = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
  }
}
