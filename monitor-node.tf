resource "alicloud_instance" "MonitorServer" {
  image_id             = data.alicloud_images.ubuntu_image.images[0].id
  instance_type        = var.linux_instance_type
  system_disk_size     = 20
  system_disk_category = "cloud_efficiency"
  security_groups      = [alicloud_security_group.FW-MGMT-SG.id]
  instance_name        = "MonitorNode"
  vswitch_id           = alicloud_vswitch.Server1-vswitch.id
  private_ip           = "10.88.3.88"
  host_name            = "MonitorNode"

  password                      = var.linux_password
  description                   = "MonitorNode"
  security_enhancement_strategy = "Active"

  internet_max_bandwidth_out = 1
  instance_charge_type       = "PostPaid"

  user_data = local.monitor_node_user_data
}