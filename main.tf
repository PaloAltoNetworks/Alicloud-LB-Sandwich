terraform {
  required_version = ">= 0.13"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.106.0"
    }
  }
}

# Configure the Alicloud Provider
provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
  version = "~> 1.106.0"
}

data "alicloud_zones" "fw-zone" {
  available_instance_type = var.instance-type
  available_disk_category = "cloud_efficiency"
}

data "alicloud_images" "vmseries" {
  owners       = "marketplace"
  name_regex   = "VM-Series VM Series 10.0.3"
  architecture = "x86_64"
  os_type      = "linux"
}

# Get Ubuntu image info
data "alicloud_images" "ubuntu_image" {
  name_regex  = "^ubuntu_20_04_x64"
  owners      = "system"
}

resource "random_id" "randomId" {
  byte_length = 4
}

