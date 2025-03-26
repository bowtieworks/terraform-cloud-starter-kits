#-----------------------------------------------------
# AWS Configuration 
#-----------------------------------------------------
region  = "us-east-2"
profile = "default"
#-----------------------------------------------------
# Network Configuration
#-----------------------------------------------------
create_vpc            = true
vpc_name              = "bowtie-demo"
cidr_block            = "10.10.0.0/16"
create_subnets        = true
subnet_names          = ["subnet-1"]
subnet_cidrs          = ["10.10.1.0/24"]
subnet_azs            = ["us-east-2a"]
create_security_group = true
#-----------------------------------------------------
# Instance Configuration
#-----------------------------------------------------
instance_type    = "t2.large"
controller_count = 1
create_eips      = true
#-----------------------------------------------------
# DNS Configuration
#-----------------------------------------------------
dns_zone_name      = "bowtie.example.com"
create_dns_records = true
route53_zone_id    = "Z1234567890ABCD"
dns_ttl            = 300
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
admin_email         = "admin@example.com"
admin_password_hash = "$argon2i$v=19$m=4096,t=3,p=1$YzQzMWI4NzItMjkxOC00YmQwLWE5YjQtOTNlMDQ1OGJkNmE1$H1/LvkX3DlsuIheeaZJ2lkM839wUdgiA7rrR6T9rpOc"
site_id             = "00000000-0000-4000-8000-000000000000"
sync_psk            = "11111111-1111-4111-9111-111111111111"
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
