resource "alicloud_slb" "skillet-ext-LB" {
  name                 = "Skillet-External-LB"
  specification        = "slb.s1.small"
  address_type         = "internet"
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"

  #  master_zone_id = "${data.alicloud_zones.fw-zone.zones.2.id}"
  #  slave_zone_id = "${data.alicloud_zones.fw-zone.zones.1.id}"
}

resource "alicloud_slb_server_group" "vm-fw-pool-1" {
  load_balancer_id = alicloud_slb.skillet-ext-LB.id
  name             = "vm-fw-pool-1"
  servers {
    server_ids = [module.fw1.eni-untrust, module.fw2.eni-untrust]
    port       = 80
    weight     = 100
    type       = "eni"
  }

  depends_on = [
    module.fw1,
    module.fw2,
    alicloud_slb.skillet-ext-LB
  ]
}

resource "alicloud_slb_listener" "ext-http-listener" {
  load_balancer_id  = alicloud_slb.skillet-ext-LB.id
  backend_port      = 80
  frontend_port     = 80
  protocol          = "tcp"
  bandwidth         = 5
  health_check      = "on"
  health_check_type = "tcp"
  server_group_id   = alicloud_slb_server_group.vm-fw-pool-1.id
}

