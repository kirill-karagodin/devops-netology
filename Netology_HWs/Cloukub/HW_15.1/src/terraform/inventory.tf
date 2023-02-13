resource "local_file" "host" {
  content = <<-DOC
# IP адресами созданных хостов
  hosts:
    ${var.node1}: ${yandex_compute_instance.node1.network_interface.0.nat_ip_address}
    ${var.node1}: ${yandex_compute_instance.node1.network_interface.0.ip_address}
    ${var.node2}: ${yandex_compute_instance.node2.network_interface.0.nat_ip_address}
    ${var.node2}: ${yandex_compute_instance.node2.network_interface.0.ip_address}
    ${var.node3}: ${yandex_compute_instance.node3.network_interface.0.nat_ip_address}
    ${var.node3}: ${yandex_compute_instance.node3.network_interface.0.ip_address}
        
    DOC
  filename = "hosts.txt"

  depends_on = [
    yandex_compute_instance.node1,
    yandex_compute_instance.node2,
  ]
}
