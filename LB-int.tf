resource "alicloud_slb" "skillet-int-LB" {
  name                 = "Skillet-Internal-LB"
  specification        = "slb.s1.small"
  address_type         = "intranet"
  vswitch_id           = alicloud_vswitch.FW2-vswitch-trust.id
  address              = var.internal_lb_address
  instance_charge_type = "PostPaid"
}

resource "alicloud_slb_server_group" "server-pool-1" {
  load_balancer_id = alicloud_slb.skillet-int-LB.id
  name             = "server-pool-1"
  servers {
    server_ids = [module.server1.server-id, module.server2.server-id]
    port       = 80
    weight     = 100
  }

  depends_on = [
    module.server1,
    module.server2,
    alicloud_slb.skillet-int-LB
  ]
}

resource "alicloud_slb_listener" "int-http-listener" {
  load_balancer_id  = alicloud_slb.skillet-int-LB.id
  backend_port      = 80
  frontend_port     = 80
  protocol          = "tcp"
  bandwidth         = 5
  health_check      = "on"
  health_check_type = "tcp"
  server_group_id   = alicloud_slb_server_group.server-pool-1.id
}

