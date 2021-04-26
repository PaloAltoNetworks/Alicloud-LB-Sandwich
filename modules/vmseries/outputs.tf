output "fw_mgmt_eip" {
  value = alicloud_instance.vmseries.public_ip
}

output "fw_untrust_eip" {
  value = alicloud_eip.fw-eip.ip_address
}

output "eni-trust" {
  value = alicloud_network_interface.fw-eni2.id
}

output "eni-untrust" {
  value = alicloud_network_interface.fw-eni1.id
}
