# Network
resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "subnet-1"   {
  name = "public"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "yandex_vpc_subnet" "subnet-2" {
  name = "private"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  route_table_id = "${yandex_vpc_route_table.private_table.id}"
  v4_cidr_blocks = ["192.168.20.0/24"]
}

resource "yandex_vpc_route_table" "private_table" {
  name       = "private_table"
  network_id = "${yandex_vpc_network.default.id}"
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "${var.ipv4_internals_node1}"
  }
}

