variable "access_key" {}

variable "secret_key" {}

variable "region" {
  default = "ap-southeast-1"
}

variable "fw-vpc" {
  default = "FW-VPC"
}

variable "fw-vpc-cidr" {
  default = "10.88.0.0/16"
}

variable "fw1-vswitch-mgmt-cidr" {
  default = "10.88.0.0/24"
}

variable "fw1-vswitch-untrust-cidr" {
  default = "10.88.1.0/24"
}

variable "fw1-vswitch-trust-cidr" {
  default = "10.88.2.0/24"
}

variable "fw2-vswitch-mgmt-cidr" {
  default = "10.88.10.0/24"
}

variable "fw2-vswitch-untrust-cidr" {
  default = "10.88.11.0/24"
}

variable "fw2-vswitch-trust-cidr" {
  default = "10.88.12.0/24"
}

variable "server1-vswitch-cidr" {
  default = "10.88.3.0/24"
}

variable "server2-vswitch-cidr" {
  default = "10.88.13.0/24"
}

variable "instance-type" {
  default = "ecs.g5.xlarge"
}

variable "instance1-name" {
  default = "FW1-VM"
}

variable "instance2-name" {
  default = "FW2-VM"
}

variable "FW1-MGMT-IP" {
  default = "10.88.0.10"
}

variable "FW1-UNTRUST-IP" {
  default = "10.88.1.10"
}

variable "FW1-TRUST-IP" {
  default = "10.88.2.10"
}

variable "FW2-MGMT-IP" {
  default = "10.88.10.10"
}

variable "FW2-UNTRUST-IP" {
  default = "10.88.11.10"
}

variable "FW2-TRUST-IP" {
  default = "10.88.12.10"
}

variable "Server1-IP" {
  default = "10.88.3.20"
}

variable "Server1-Name" {
  default = "Server1"
}

variable "Server2-IP" {
  default = "10.88.13.20"
}

variable "Server2-Name" {
  default = "Server2"
}

variable "linux_instance_type" {
  default = "ecs.n1.tiny"
}

variable "linux_password" {
  default = "PaloAlt0123"
}

variable "internal_lb_address" {
  default = "10.88.12.148"
}

variable "ssh_key_path" {}

variable "bootstrap" {}

variable "auth_code" {}

variable "key_name" {}
