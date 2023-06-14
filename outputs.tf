output "FW-1-MGMT" {
  value = "Access the firewall MGMT via:  https://${module.fw1.fw_mgmt_eip}"
}

output "FW-2-MGMT" {
  value = "Access the firewall MGMT via:  https://${module.fw2.fw_mgmt_eip}"
}

output "FW-1-Mgmt" {
  value = module.fw1.fw_mgmt_eip
}

output "FW-2-Mgmt" {
  value = module.fw2.fw_mgmt_eip
}

output "FW-1-Untrust" {
  value = module.fw1.fw_untrust_eip
}

output "FW-2-Untrust" {
  value = module.fw2.fw_untrust_eip
}

output "App-Access" {
  value = "Access App via:  http://${alicloud_slb.external-LB.address}"
}

output "Server1_fw1_access" {
  value = "Access Server1 via FW1:  ssh root@${module.fw1.fw_untrust_eip} -p 1001"
}

output "Server2_fw1_access" {
  value = "Access Server2 via FW1:  ssh root@${module.fw1.fw_untrust_eip} -p 1002"
}

output "Server1_fw2_access" {
  value = "Access Server1 via FW2:  ssh root@${module.fw2.fw_untrust_eip} -p 1001"
}

output "Server2_fw2_access" {
  value = "Access Server2 via FW2:  ssh root@${module.fw2.fw_untrust_eip} -p 1002"
}

output "MonitorNode_access" {
  value = "Access MonitorNode:  ssh root@${alicloud_instance.MonitorServer.public_ip}"
}

output "password_new" {
  value     = var.linux_password
  sensitive = true
}

output "ssh_key_path" {
  value     = var.ssh_key_path
  sensitive = true
}

