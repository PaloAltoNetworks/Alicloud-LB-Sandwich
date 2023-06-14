import requests
import xml.etree.ElementTree as ET
import urllib3
from python_terraform import Terraform
import time
import paramiko
from contextlib import closing


def wait_until_channel_endswith(channel, endswith, wait_in_seconds=15):
    timeout = time.time() + wait_in_seconds
    read_buffer = b''
    while not read_buffer.endswith(endswith):
        if channel.recv_ready():
           read_buffer += channel.recv(4096)
        elif time.time() > timeout:
            raise TimeoutError(f"Timeout while waiting for '{endswith}' on the channel")
        else:
            time.sleep(1)

def fw_init(host, username, ssh_key_file, new_password):
    with closing(paramiko.SSHClient()) as ssh_connection:
        ssh_connection.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh_connection.load_system_host_keys()
        k = paramiko.RSAKey.from_private_key_file(ssh_key_file)
        timeout = int(600)
        timeout_start = time.time()

        while time.time() < timeout_start + timeout:
            time.sleep(1)
            try:
                ssh_connection.connect(hostname=host, username=username, pkey=k)
                break
            except Exception as e:
                print(e)
                print("Waiting for vm-series to be available ...")

        time.sleep(120)
        ssh_channel = ssh_connection.invoke_shell()

        wait_until_channel_endswith(ssh_channel, b'> ')
        ssh_channel.send(f'configure\n')
        print("sent configure")

        wait_until_channel_endswith(ssh_channel, b'# ')
        ssh_channel.send(f'set mgt-config users admin password\n')
        print("sent mgt-config command")

        wait_until_channel_endswith(ssh_channel, b'Enter password   : ')
        ssh_channel.send(f'{new_password}\n')
        print("entered password")

        wait_until_channel_endswith(ssh_channel, b'Confirm password : ')
        ssh_channel.send(f'{new_password}\n')
        print("confirmed password")

        wait_until_channel_endswith(ssh_channel, b'# ')
        ssh_channel.send(f'commit\n')
        print("sent commit")

        # longer timeout of 60s to cater to commit time
        wait_until_channel_endswith(ssh_channel, b'# ', 120)
        print("changed admin password")


urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

working_dir = "./"
tf = Terraform(working_dir=working_dir)
outputs = tf.output()
fw1_mgmt = outputs['FW-1-Mgmt']['value']
fw2_mgmt = outputs['FW-2-Mgmt']['value']
username = "admin"
new_password = outputs['password_new']['value']
ssh_key_path = outputs['ssh_key_path']['value']

fw_init(fw1_mgmt, username, ssh_key_path, new_password)
fw_init(fw2_mgmt, username, ssh_key_path, new_password)

# Get new API Key
url = "https://%s/api/?type=keygen&user=%s&password=%s" % (fw1_mgmt, username, new_password)
response = requests.get(url, verify=False)
fw1_api_key = ET.XML(response.content)[0][0].text
#print(fw1_api_key)

url = "https://%s/api/?type=keygen&user=%s&password=%s" % (fw2_mgmt, username, new_password)
response = requests.get(url, verify=False)
fw2_api_key = ET.XML(response.content)[0][0].text
#print(fw2_api_key)

# Upload base config
url = "https://%s/api/?type=import&category=configuration&key=%s" % (fw1_mgmt, fw1_api_key)
config_file = {'file': open('./configs/fw1-cfg.xml', 'rb')}
response = requests.post(url, files=config_file, verify=False)
print(response.text)


url = "https://%s/api/?type=import&category=configuration&key=%s" % (fw2_mgmt, fw2_api_key)
config_file = {'file': open('./configs/fw2-cfg.xml', 'rb')}
response = requests.post(url, files=config_file, verify=False)
print(response.text)

# Load the config
url = "https://%s/api/?type=op&cmd=<load><config><from>fw1-cfg.xml</from></config></load>&key=%s" % (fw1_mgmt, fw1_api_key)
response = requests.get(url, verify=False)
print(response.text)

url = "https://%s/api/?type=op&cmd=<load><config><from>fw2-cfg.xml</from></config></load>&key=%s" % (fw2_mgmt, fw2_api_key)
response = requests.get(url, verify=False)
print(response.text)

# Commit config
url = " https://%s/api/?key=%s&type=commit&cmd=<commit></commit>" % (fw1_mgmt, fw1_api_key)
response = requests.get(url, verify=False)
print(response.text)

url = " https://%s/api/?key=%s&type=commit&cmd=<commit></commit>" % (fw2_mgmt, fw2_api_key)
response = requests.get(url, verify=False)
print(response.text)

print("Base config has been uploaded to the VM-Series")
