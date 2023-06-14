
resource "null_resource" "update_config" {
  provisioner "local-exec" {
    command     = "python3 ./scripts/config1.py"
    working_dir = "./"
  }

  depends_on = [
    module.fw1,
    module.fw2,
    alicloud_route_entry.default
  ]
}