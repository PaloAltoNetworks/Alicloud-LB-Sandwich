module "fw1" {
  source = "./modules/vmseries/"
  name = var.instance1-name
  
  mgmt_vswitch = alicloud_vswitch.FW1-vswitch-mgmt.id
  mgmt_sg = [alicloud_security_group.FW-MGMT-SG.id]
  mgmt_ip = var.FW1-MGMT-IP

  untrust_vswitch = alicloud_vswitch.FW1-vswitch-untrust.id
  untrust_sg = [alicloud_security_group.FW-DATA-SG.id]
  untrust_ip = var.FW1-UNTRUST-IP

  trust_vswitch = alicloud_vswitch.FW1-vswitch-trust.id
  trust_sg = [alicloud_security_group.FW-DATA-SG.id]
  trust_ip = var.FW1-TRUST-IP

  zone = data.alicloud_zones.fw-zone.zones[0].id

  instance_type = var.instance-type

  image_id = data.alicloud_images.vmseries.images[0].id

  key_name = var.key_name
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region

  bootstrap = var.bootstrap
  fw_user_data = local.fw1_user_data

}


module "fw2" {
  source = "./modules/vmseries/"
  name = var.instance2-name
  
  mgmt_vswitch = alicloud_vswitch.FW2-vswitch-mgmt.id
  mgmt_sg = [alicloud_security_group.FW-MGMT-SG.id]
  mgmt_ip = var.FW2-MGMT-IP

  untrust_vswitch = alicloud_vswitch.FW2-vswitch-untrust.id
  untrust_sg = [alicloud_security_group.FW-DATA-SG.id]
  untrust_ip = var.FW2-UNTRUST-IP

  trust_vswitch = alicloud_vswitch.FW2-vswitch-trust.id
  trust_sg = [alicloud_security_group.FW-DATA-SG.id]
  trust_ip = var.FW2-TRUST-IP

  zone = data.alicloud_zones.fw-zone.zones[1].id

  instance_type = var.instance-type

  image_id = data.alicloud_images.vmseries.images[0].id

  key_name = var.key_name
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region

  bootstrap = var.bootstrap
  fw_user_data = local.fw2_user_data
}

