resource "yandex_compute_instance" "cp01" {
  name                      = "cp01"
  zone                      = "ru-central1-a"
  hostname                  = "cp01.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = "${var.instance_cores_cp01}"
    memory = "${var.instance_memory_cp01}"
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-base}"
      name        = "root-cp01"
      type        = "network-nvme"
      size        = "${var.instance_hdd}"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default.id}"
    nat       = true
    ip_address = "${var.ipv4_internals_cp01}" 
 }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}



