### Example configuration for deploying a new, single-peer, Bowtie site within an existing VPC and Subnet.

region  = "us-east-2" # The AWS region the resources will be created within.
profile = "example-profile" # The AWS profile to use for authentication.

vpc_id            = "vpc-07c194ea8b3bca0e7" # The ID of the VPC to deploy the controller within.
subnet_id         = "subnet-0145e6ad55de75312" # The ID of the subnet to deploy the controller within.
security_group_id = "sg-060e156fbb6b5764d" # The ID of the security group to associate with the controller.

instance_type   = "t2.large" # The instance type to be used for the controller.
owner_id        = ["055761336000"] # The owner ID to be used for fetching the AMI (Only required if using an AMI from AWS GovCloud see https://docs.bowtie.works/setup-controller.html#aws).
dns_zone_name   = "bowtie.example.com" # The DNS zone name to be used for the controller (combines with controller_name to create FQDN).
controller_name = ["c0"] # The name of the controller to be created (combines with dns_zone_name to create FQDN).
eip_addresses   = ["0.0.0.0"] # Replace with the EIP address to be associated with the controller.

ipv4_range      = "10.10.0.0/24" # The IPv4 range to be used for the Bowtie site.
site_id         = "00000000-0000-4000-8000-000000000000" # The site ID to be used for the Bowtie site (should match the site ID specified in cloud-init).
bowtie_username = "admin@bowtie.example.com" # The username to be used for the Bowtie site.
bowtie_password = "example_password" # The password to be used for the Bowtie site.
create_default_resources = true # Whether to create default resources for the Bowtie site.

### Example cloud-init file that should reside in /modules/compute/cloud-init-first-instance.yaml

# #cloud-config
# fqdn: c0.bowtie.example.com
# hostname: c0.bowtie.example.com
# preserve_hostname: false
# prefer_fqdn_over_hostname: true
# write_files:
# - path: /etc/bowtie-server.d/custom.conf
#   content: |
#     SITE_ID=00000000-0000-4000-8000-000000000000
#     BOWTIE_SYNC_PSK=11111111-1111-4111-9111-111111111111
# - path: /var/lib/bowtie/init-users
#   content: |
#     admin@bowtie.example.com:$argon2i$v=19$m=4096,t=3,p=1$YzQzMWI4NzItMjkxOC00YmQwLWE5YjQtOTNlMDQ1OGJkNmE1$H1/LvkX3DlsuIheeaZJ2lkM839wUdgiA7rrR6T9rpOc
# - path: /var/lib/bowtie/skip-gui-init
# - path: /etc/update-at
# users:
# - name: root
#   ssh_authorized_keys:
#   - ssh-ed25519 AAAA example-key
#   lock_passwd: false
