#-----------------------------------------------------
# AWS Configuration 
#-----------------------------------------------------
region  = "us-east-2"
profile = "default"
#-----------------------------------------------------
# Network Configuration
#-----------------------------------------------------
create_vpc            = false
vpc_id                = "vpc-12345abcdef"
create_subnets        = false
subnet_id             = "subnet-12345abcdef"
create_security_group = false
security_group_id     = "sg-12345abcdef"
#-----------------------------------------------------
# Instance Configuration
#-----------------------------------------------------
instance_type    = "t2.large"
controller_count = 1
create_eips      = true
#-----------------------------------------------------
# DNS Configuration
#-----------------------------------------------------
dns_zone_name      = "new-site.bowtie.example.com"
create_dns_records = true
route53_zone_id    = "Z1234567890ABCD"
dns_ttl            = 300
#-----------------------------------------------------
# Bowtie Configuration
#-----------------------------------------------------
join_existing_cluster      = true
join_existing_cluster_fqdn = "c0.bowtie.example.com"
bowtie_username            = "admin@example.com"
bowtie_password            = "example_password"
ipv4_range                 = "10.10.0.0/24"
create_default_resources   = false
#-----------------------------------------------------
# Cloud-Init Configuration
#-----------------------------------------------------
site_id    = "00000000-0000-4000-8000-000000000000"
sync_psk   = "11111111-1111-4111-9111-111111111111"
ssh_key    = "ssh-ed25519 AAAA example-key"
sso_config = <<EOT
  type: gitlab
  id: gitlab
  name: GitLab
  config:
    clientID: ****
    clientSecret: ****
    redirectURI: $DEX_ORIGIN/dex/callback
EOT
