resource "alicloud_slb" "external-LB" {
  load_balancer_name                 = "External-LB"
  load_balancer_spec        = "slb.s1.small"
  address_type         = "internet"
  internet_charge_type = "PayByTraffic"
  # instance_charge_type = "PostPaid"

  #  master_zone_id = "${data.alicloud_zones.fw-zone.zones.2.id}"
  #  slave_zone_id = "${data.alicloud_zones.fw-zone.zones.1.id}"
}

resource "alicloud_slb_server_group" "vm-fw-pool-1" {
  load_balancer_id = alicloud_slb.external-LB.id
  name             = "vm-fw-pool-1"
}

resource "alicloud_slb_server_group_server_attachment" "fw1_attachment" {
    server_group_id = alicloud_slb_server_group.vm-fw-pool-1.id
    server_id = module.fw1.eni-untrust
    port       = 80
    weight     = 100
    type       = "eni"
    
    depends_on = [
      module.fw1,
      alicloud_slb.external-LB
    ]
}

resource "alicloud_slb_server_group_server_attachment" "fw2_attachment" {
    server_group_id = alicloud_slb_server_group.vm-fw-pool-1.id
    server_id = module.fw2.eni-untrust
    port       = 80
    weight     = 100
    type       = "eni"
    
    depends_on = [
      module.fw2,
      alicloud_slb.external-LB
    ]
}

resource "alicloud_slb_listener" "ext-http-listener" {
  load_balancer_id  = alicloud_slb.external-LB.id
  backend_port      = 80
  frontend_port     = 80
  protocol          = "tcp"
  bandwidth         = 5
  health_check      = "on"
  health_check_type = "tcp"
  server_group_id   = alicloud_slb_server_group.vm-fw-pool-1.id

  depends_on = [
    alicloud_slb_server_group_server_attachment.fw1_attachment,
    alicloud_slb_server_group_server_attachment.fw2_attachment
    ]
}

