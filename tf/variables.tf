variable "infra_name" {
  type = string 
}

variable "instance_count" {
  description = "Number of instances to create"
  type = number
  default = 1
}

variable "flavor_name" {
  type = string
}

variable "image_name" {
  type = string
}

variable "root_disk_size" {
  type = number
  default = 30
}

variable "logs_disk_size" {
  type = number
  default = 30
}

variable "data_disk_size" { 
  type = number
  default = 30
}

variable "internal_network_cidr" {
  type = string
  default = "10.0.0.0/24"
}

variable "preferred_ip_address" {
  type = string
  default = "10.0.0.4"
}

variable "router_id" {
  type = string
}

variable "network_id" {
  type = string
}

variable "security_group_ssh_id" {
  type = string
}

variable "default_ssh_user" {
  type = string
  default = "ubuntu"
}
