locals {
  monitor_node_user_data = <<-EOF
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

  # monitor_node_user_data = "bW9uaXRvcl9ub2RlX3VzZXJfZGF0YSA9IDw8RU9GCiMhL3Vzci9iaW4vYmFzaAp3aGlsZSB0cnVlCmRvCiAgaWYgcGluZyAtcSAtYyAxIC1XIDEgOC44LjguOCA+L2Rldi9udWxsOyB0aGVuCgkgIGVjaG8gIk91dGJvdW5kIGFjY2VzcyBhdmFpYWJsZS4iCgkgIGJyZWFrCiAgZWxzZQoJICBlY2hvICJXYWl0aW5nIGZvciBPdXRib3VuZCBhY2Nlc3MuLi4iCgkgIHNsZWVwIDIwCiAgZmkKZG9uZQphcHQtZ2V0IHVwZGF0ZSAmJiAKYXB0LWdldCAteSB1cGdyYWRlICYmCmNkIC9yb290CndnZXQgLU8gYWxpeXVuLWNsaS1saW51eC0zLjAuNjQtYW1kNjQudGd6IGh0dHBzOi8vYWxpeXVuY2xpLmFsaWNkbi5jb20vYWxpeXVuLWNsaS1saW51eC0zLjAuNjQtYW1kNjQudGd6ICYmCnRhciB6eGYgYWxpeXVuLWNsaS1saW51eC0zLjAuNjQtYW1kNjQudGd6ICYmCmNobW9kICt4IGFsaXl1biAmJgptdiBhbGl5dW4gL3Vzci9sb2NhbC9iaW4vICYmCnJtIGFsaXl1bi1jbGktbGludXgtMy4wLjY0LWFtZDY0LnRneiAmJgp3Z2V0IC1PIGhhLXNjcmlwdC1hbGljbG91ZC5zaCBodHRwczovL3BhLXNjcmlwdHMub3NzLWNuLXNoYW5naGFpLmFsaXl1bmNzLmNvbS9oYS1zY3JpcHQtYWxpY2xvdWQuc2ggJiYKY2htb2QgK3ggaGEtc2NyaXB0LWFsaWNsb3VkLnNoICYmCmFsaXl1biBjb25maWd1cmUgc2V0IC0tbW9kZSBFY3NSYW1Sb2xlIC0tcmVnaW9uICR7dmFyLnJlZ2lvbn0gLS1yYW0tcm9sZS1uYW1lIE1vbml0b3JOb2RlUm9sZSAmJgouL2hhLXNjcmlwdC1hbGljbG91ZC5zaCAke3Zhci5GVzEtVFJVU1QtSVB9ICR7dmFyLkZXMi1UUlVTVC1JUH0gJHttb2R1bGUuZncxLmVuaS10cnVzdH0gJHttb2R1bGUuZncyLmVuaS10cnVzdH0gJHthbGljbG91ZF92cGMuZndfdnBjLnJvdXRlX3RhYmxlX2lkfSAmCmVjaG8gImRvbmUiCkVPRg=="


  # # VM-Series User Data - check this URL for other supported parameters
  # # https://docs.paloaltonetworks.com/vm-series/10-0/vm-series-deployment/set-up-the-vm-series-firewall-on-alibaba-cloud/deploy-the-vm-series-firewall-on-alibaba-cloud/create-and-configure-the-vm-series-firewall.html#id0ba23c65-f58b-4922-92cb-6e75e8eacf30


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
