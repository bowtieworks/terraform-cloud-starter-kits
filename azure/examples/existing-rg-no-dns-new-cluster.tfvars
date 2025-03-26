#-----------------------------------------------------
# Azure Configuration 
#-----------------------------------------------------
subscription_id = "00000000-0000-0000-0000-000000000000"
tenant_id       = "00000000-0000-0000-0000-000000000000"
location        = "eastus"
#-----------------------------------------------------
# Resource Group Configuration
#-----------------------------------------------------
create_resource_group = false
resource_group_name   = "bowtie-demo"
#-----------------------------------------------------
# Network Configuration
#-----------------------------------------------------
create_vnet   = true
vnet_name     = "bowtie-vnet"
address_space = "10.10.0.0/16"
create_subnet = true
subnet_name   = "bowtie-subnet"
subnet_prefix = "10.10.1.0/24"
create_nsg    = true
nsg_name      = "bowtie-nsg"
#-----------------------------------------------------
# VM Configuration
#-----------------------------------------------------
vm_size           = "Standard_D2s_v3"
admin_ssh_public_key_path = "/Users/account_name/.ssh/example_rsa.pub"  # This will be overwritten by cloud-init ssh-key
controller_count  = 2
create_public_ips = false
public_ip_addresses = ["pip_1", "pip_2"]
#-----------------------------------------------------
# DNS Configuration
#-----------------------------------------------------
dns_zone_name      = "bowtie.example.com"
create_dns_records = true
#-----------------------------------------------------
# Bowtie Configuration
#-----------------------------------------------------
bowtie_username          = "admin@example.com"
bowtie_password          = "example_password"
ipv4_range               = "10.10.0.0/24"
create_default_resources = true
#-----------------------------------------------------
# Cloud-Init Configuration
#-----------------------------------------------------
site_id             = "00000000-0000-4000-8000-000000000000"
sync_psk            = "11111111-1111-4111-9111-111111111111"
admin_email         = "admin@example.com"
admin_password_hash = "$argon2i$v=19$m=4096,t=3,p=1$YzQzMWI4NzItMjkxOC00YmQwLWE5YjQtOTNlMDQ1OGJkNmE1$H1/LvkX3DlsuIheeaZJ2lkM839wUdgiA7rrR6T9rpOc"
ssh_key             = "ssh-ed25519 AAAA example-key"
sso_config          = <<EOT
  type: gitlab
  id: gitlab
  name: GitLab
  config:
    clientID: ****
    clientSecret: ****
    redirectURI: $DEX_ORIGIN/dex/callback
EOT