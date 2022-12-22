resource "local_file" "prod" {
  content = <<-DOC
# ## Configure 'ip' variable to bind kubernetes services on a
# ## different ip than the default iface
# ## We should set etcd_member_name for etcd cluster. The node that is not a etcd member do not need to set the value, or can set the empty string value.
[all]
node1 ansible_host=${yandex_compute_instance.node01.network_interface.0.nat_ip_address}  ip=${yandex_compute_instance.node01.network_interface.0.ip_address} ansible_user=centos
node2 ansible_host=${yandex_compute_instance.node02.network_interface.0.nat_ip_address}  ip=${yandex_compute_instance.node02.network_interface.0.ip_address} ansible_user=centos
cp1 ansible_host=${yandex_compute_instance.cp01.network_interface.0.nat_ip_address}  ip=${yandex_compute_instance.cp01.network_interface.0.ip_address} etcd_member_name=etcd1 ansible_user=centos

# ## configure a bastion host if your nodes are not directly reachable
# [bastion]
# bastion ansible_host=x.x.x.x ansible_user=some_user

[kube_control_plane]
cp1

[etcd]
cp1

[kube_node]
node1
node2

[calico_rr]

[k8s_cluster:children]
kube_control_plane
kube_node
calico_rr

    DOC
  filename = "../inventory/netology-cluster/inventory.ini"

  depends_on = [
    yandex_compute_instance.cp01,
    yandex_compute_instance.node01,
    yandex_compute_instance.node02,
  ]
}
