locals {
monitor_node_user_data = <<EOF
#!/usr/bin/bash
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
apt-get update && 
apt-get -y upgrade &&
cd /root
wget -O aliyun-cli-linux-3.0.64-amd64.tgz https://aliyuncli.alicdn.com/aliyun-cli-linux-3.0.64-amd64.tgz &&
tar zxf aliyun-cli-linux-3.0.64-amd64.tgz &&
chmod +x aliyun &&
mv aliyun /usr/local/bin/ &&
rm aliyun-cli-linux-3.0.64-amd64.tgz &&
wget -O ha-script-alicloud.sh https://pa-scripts.oss-cn-shanghai.aliyuncs.com/ha-script-alicloud.sh &&
chmod +x ha-script-alicloud.sh &&
aliyun configure set --mode EcsRamRole --region ${var.region} --ram-role-name MonitorNodeRole &&
./ha-script-alicloud.sh ${var.FW1-TRUST-IP} ${var.FW2-TRUST-IP} ${module.fw1.eni-trust} ${module.fw2.eni-trust} ${alicloud_vpc.fw_vpc.route_table_id} &
echo "done"
EOF


# VM-Series User Data - check this URL for other supported parameters
# https://docs.paloaltonetworks.com/vm-series/10-0/vm-series-deployment/set-up-the-vm-series-firewall-on-alibaba-cloud/deploy-the-vm-series-firewall-on-alibaba-cloud/create-and-configure-the-vm-series-firewall.html#id0ba23c65-f58b-4922-92cb-6e75e8eacf30

fw1_user_data = <<EOF
type=dhcp-client
hostname=${var.instance1-name}
dhcp-send-hostname=yes
dhcp-send-client-id=yes
dhcp-accept-server-hostname=yes
dhcp-accept-server-domain=yes
authcodes=${var.auth_code}
EOF


fw2_user_data = <<EOF
type=dhcp-client
hostname=${var.instance2-name}
dhcp-send-hostname=yes
dhcp-send-client-id=yes
dhcp-accept-server-hostname=yes
dhcp-accept-server-domain=yes
authcodes=${var.auth_code}
EOF

}
