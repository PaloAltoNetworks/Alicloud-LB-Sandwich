resource "alicloud_slb" "internal-LB" {
  load_balancer_name                 = "Internal-LB"
  load_balancer_spec        = "slb.s1.small"
  address_type         = "intranet"
  vswitch_id           = alicloud_vswitch.FW2-vswitch-trust.id
  address              = var.internal_lb_address
}

resource "alicloud_slb_server_group" "server-pool-1" {
  load_balancer_id = alicloud_slb.internal-LB.id
  name             = "server-pool-1"

  depends_on = [
    module.server1,
    module.server2,
    alicloud_slb.internal-LB
  ]
}

resource "alicloud_slb_server_group_server_attachment" "server1_attachment" {
    server_group_id = alicloud_slb_server_group.server-pool-1.id
    server_id = module.server1.server-id
    port       = 80
    weight     = 100
    depends_on = [
      module.server1,
      alicloud_slb.internal-LB
  ]
}

resource "alicloud_slb_server_group_server_attachment" "server2_attachment" {
    server_group_id = alicloud_slb_server_group.server-pool-1.id
    server_id = module.server2.server-id
    port       = 80
    weight     = 100
    depends_on = [
      module.server2,
      alicloud_slb.internal-LB
  ]
}

resource "alicloud_slb_listener" "int-http-listener" {
  load_balancer_id  = alicloud_slb.internal-LB.id
  backend_port      = 80
  frontend_port     = 80
  protocol          = "tcp"
  bandwidth         = 5
  health_check      = "on"
  health_check_type = "tcp"
  server_group_id   = alicloud_slb_server_group.server-pool-1.id

  depends_on = [
    alicloud_slb_server_group_server_attachment.server1_attachment,
    alicloud_slb_server_group_server_attachment.server2_attachment
    ]
}

