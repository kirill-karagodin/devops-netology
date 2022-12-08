# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "[Указать свой]"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "[Указать свой]"
}

# Заменить на ID своего образа
# ID можно узнать с помощью команды yc compute image list
 variable "centos-7-base" {
  default = "fd88d14a6790do254kj7"
 }

variable "instance_cores" {
  default = "2"
}

variable "instance_memory" {
  default = "2"
}

variable "instance_hdd" {
  default = "10"
}