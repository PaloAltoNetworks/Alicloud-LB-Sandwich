terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.206.0"
    }
  }
}

# Configure the Alicloud Provider
provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}


# Create Untrust Interface
resource "alicloud_network_interface" "fw-eni1" {
  network_interface_name            = "${var.name}-eni1"
  vswitch_id      = var.untrust_vswitch
  primary_ip_address      = var.untrust_ip
  security_group_ids = var.untrust_sg
}

# Create Trust Interface
resource "alicloud_network_interface" "fw-eni2" {
  network_interface_name            = "${var.name}-eni2"
  vswitch_id      = var.trust_vswitch
  primary_ip_address      = var.trust_ip
  security_group_ids = var.trust_sg
}

resource "alicloud_eip" "fw-eip" {
  address_name                 = "${var.name}-eip"
  description          = "EIP assigned to ${var.name} Untrust interface"
  bandwidth            = "1"
  internet_charge_type = "PayByTraffic"
}

resource "alicloud_eip_association" "eip_asso" {
  allocation_id = alicloud_eip.fw-eip.id
  instance_id   = alicloud_network_interface.fw-eni1.id
  instance_type = "NetworkInterface"

  depends_on = [
    alicloud_eip.fw-eip,
    alicloud_network_interface.fw-eni1,
    alicloud_network_interface_attachment.fw-untrust
  ]
}

# Launch Instance with Mgmt Interface
resource "alicloud_instance" "vmseries" {
  availability_zone          = var.zone
  security_groups            = var.mgmt_sg
  instance_type              = var.instance_type
  system_disk_size           = 60
  # system_disk_category       = "cloud_efficiency"
  system_disk_category       = var.disk_category
  system_disk_name           = "${var.name}-disk0"
  image_id                   = var.image_id
  instance_name              = var.name
  vswitch_id                 = var.mgmt_vswitch
  internet_max_bandwidth_out = 10
  private_ip                 = var.mgmt_ip
  host_name                  = var.name
  key_name                   = var.key_name

  user_data = var.bootstrap == "yes" ? var.fw_user_data : ""
}

# Attach Untrust interface to Instance
resource "alicloud_network_interface_attachment" "fw-untrust" {
  instance_id          = alicloud_instance.vmseries.id
  network_interface_id = alicloud_network_interface.fw-eni1.id

  depends_on = [
    alicloud_instance.vmseries,
    alicloud_network_interface.fw-eni1,
  ]
}

# Attach Trust interface to Instance
resource "alicloud_network_interface_attachment" "fw-trust" {
  instance_id          = alicloud_instance.vmseries.id
  network_interface_id = alicloud_network_interface.fw-eni2.id

  depends_on = [
    alicloud_instance.vmseries,
    alicloud_network_interface.fw-eni2,
    alicloud_network_interface_attachment.fw-untrust,
  ]
}
