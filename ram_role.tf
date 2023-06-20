resource "alicloud_ram_role" "MonitorNodeRole" {
  name     = "MonitorNodeRole-${random_id.randomId.hex}"
  document = <<EOF
  {
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "ecs.aliyuncs.com"
          ]
        }
      }
    ],
    "Version": "1"
  }
  EOF

  description = "This is an Instance Role for the Monitor Node to configure Route Tables"
}

data "alicloud_ram_policies" "ecs_policy" {
  name_regex = "AliyunECSFullAccess"
  type       = "System"
}

data "alicloud_ram_policies" "vpc_policy" {
  name_regex = "AliyunVPCFullAccess"
  type       = "System"
}

resource "alicloud_ram_role_policy_attachment" "ecs_pol_attach" {
  policy_name = data.alicloud_ram_policies.ecs_policy.policies[0].name
  policy_type = data.alicloud_ram_policies.ecs_policy.policies[0].type
  role_name   = alicloud_ram_role.MonitorNodeRole.name
}

resource "alicloud_ram_role_policy_attachment" "vpc_pol_attach" {
  policy_name = data.alicloud_ram_policies.vpc_policy.policies[0].name
  policy_type = data.alicloud_ram_policies.vpc_policy.policies[0].type
  role_name   = alicloud_ram_role.MonitorNodeRole.name
}

resource "alicloud_ram_role_attachment" "attach" {
  role_name    = alicloud_ram_role.MonitorNodeRole.name
  instance_ids = [alicloud_instance.MonitorServer.id]

  depends_on = [alicloud_instance.MonitorServer]
}
