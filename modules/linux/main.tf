terraform {
  required_version = ">= 0.13"
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.106.0"
    }
  }
}

# Configure the Alicloud Provider
provider "alicloud" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
  version = "~> 1.106.0"
}


resource "alicloud_instance" "Server" {
  image_id             = var.image_id
  instance_type        = var.linux_instance_type
  system_disk_size     = 20
  system_disk_category = "cloud_efficiency"
  security_groups      = var.server_sg
  instance_name        = var.name
  vswitch_id           = var.server_vswitch
  private_ip           = var.server_ip
  host_name            = var.name

  password                      = var.password
  description                   = var.name
  security_enhancement_strategy = "Active"

  internet_max_bandwidth_out = 0
  instance_charge_type       = "PostPaid"

  user_data = <<EOF
#!/bin/bash
while true
do
  if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
	  echo "Outbound access avaiable."
	  break
  else
	  echo "Waiting for Outbound access..."
	  sleep 20
  fi
done
sudo apt-get update && 
sudo apt-get -y upgrade &&
sudo apt-get install -y apache2 php libapache2-mod-php &&
sudo rm -f /var/www/html/index.html &&
sudo wget -O /var/www/html/index.php https://pa-scripts.oss-cn-shanghai.aliyuncs.com/showheaders.php &&
sudo service apache2 restart &&
sudo echo "done"
EOF

}