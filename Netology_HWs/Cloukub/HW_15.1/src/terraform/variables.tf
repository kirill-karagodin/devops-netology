variable "yandex_cloud_id" {
  default = ""
}

variable "yandex_folder_id" {
  default = ""
}

# Image node 1 (NAT)
variable "image_node1" {
  default = "fd80mrhj8fl2oe87o4e1"
}

# Image node 2
variable "image_node2" {
  default = "fd88d14a6790do254kj7"
}

# Image node 3
variable "image_node3" {
  default = "fd88d14a6790do254kj7"
}


# Name node 1
variable "node1" {
  default = "nat"
}

# Name node 2
variable "node2" {
  default = "agent1"
}

# Name node 3
variable "node3" {
  default = "agent2"
}


# CPU core
variable "instance_cores" {
  default = "2"
}
# CPU ram (Gb)
variable "instance_memory" {
  default = "4"
}

# HDD space (Gb)
variable "instance_hdd" {
  default = "10"
}

# User
variable "user" {
  default = "cenos"
}

# IP adress for nat_node
variable "ipv4_internals_node1" {
  default = "192.168.10.254"
}
