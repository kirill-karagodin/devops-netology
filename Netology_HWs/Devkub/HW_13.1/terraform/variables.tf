# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = ""
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = ""
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
 variable "centos-7-base" {
  default = "fd88d14a6790do254kj7"
 }

variable "instance_cores_cp01" {
  default = "4"
}

variable "instance_cores_nodes" {
  default = "2"
}

variable "instance_memory_cp01" {
  default = "4"
}

variable "instance_memory_nodes" {
  default = "2"
}

variable "instance_hdd" {
  default = "51"
}

variable "ipv4_internals_cp01" {
  default = "192.168.101.11"
}

variable "ipv4_internals_node01" {
  default = "192.168.101.12"
}

variable "ipv4_internals_node02" {
  default = "192.168.101.13"
}
