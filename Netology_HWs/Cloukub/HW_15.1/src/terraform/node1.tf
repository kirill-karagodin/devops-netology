resource "yandex_compute_instance" "node1" {
  name                      = "${var.node1}"
  zone                      = "ru-central1-a"
  hostname                  = "${var.node1}.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = "${var.instance_cores}"
    memory = "${var.instance_memory}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.image_node1}"
      name        = "root-${var.node1}"
      type        = "network-nvme"
      size        = "${var.instance_hdd}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
    ip_address = "${var.ipv4_internals_node1}"
  }

  metadata = {
    ssh-keys = "${var.user}:${file("~/.ssh/id_rsa.pub")}"
  }
}
