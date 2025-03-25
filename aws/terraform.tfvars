region  = "us-east-2"
profile = "example-profile"

#-----------------------------------------------------
# Network Configuration
#-----------------------------------------------------
# Option 1: Create a new VPC (recommended for new deployments)
create_vpc = true
vpc_name   = "example-vpc"
cidr_block = "10.10.0.0/16"

# Option 2: Use an existing VPC (uncomment and set vpc_id if using existing VPC)
# create_vpc     = false
# vpc_id         = "vpc-12345abcdef" # ID of your existing VPC

#-----------------------------------------------------
# Subnet Configuration
#-----------------------------------------------------
# Option 1: Create new subnets (used with new VPC)
create_subnets = true
subnet_names   = ["subnet-1"]
subnet_cidrs   = ["10.10.1.0/24"]
subnet_azs     = ["us-east-2a"] # Must match your region above

# Option 2: Use an existing subnet (uncomment if using existing subnet)
# create_subnets = false
# subnet_id      = "subnet-12345abcdef"

#-----------------------------------------------------
# Security Configuration
#-----------------------------------------------------
# Option 1: Create a new security group (recommended)
create_security_group = true

# Option 2: Use existing security group (uncomment if using existing security group)
# create_security_group = false
# security_group_id     = "sg-12345abcdef"

#-----------------------------------------------------
# Instance Configuration
#-----------------------------------------------------
instance_type = "t2.large" # EC2 instance type for controllers
# iam_instance_profile = "your-profile-name"  # Optional: IAM instance profile

# Deployment Pattern
controller_count = 2 # Total number of controllers to deploy
# controller_name  = ["primary", "secondary"]  # Optional: custom names for controllers
# If not provided, will use "c0", "c1", etc.

#-----------------------------------------------------
# EIP Configuration
#-----------------------------------------------------
# Option 1: Create new Elastic IPs (recommended)
create_eips = true

# Option 2: Use existing Elastic IPs (uncomment if using existing EIPs)
# create_eips     = false
# eip_addresses   = ["1.2.3.4", "5.6.7.8"]

#-----------------------------------------------------
# DNS Configuration
#-----------------------------------------------------
dns_zone_name = "bowtie.example.com" # Domain suffix for your controllers

# Option: Create Route53 DNS records (requires Route53 hosted zone)
create_dns_records = true
route53_zone_id    = "Z09536192Y713OXSQRZ5D" # Your Route53 hosted zone ID
dns_ttl            = 300

#-----------------------------------------------------
# Bowtie Configuration
#-----------------------------------------------------
# Required fields
site_id             = "00000000-0000-4000-8000-000000000000"
sync_psk            = "11111111-1111-4111-9111-111111111111"
admin_email         = "admin@bowtie.example.com"
admin_password_hash = "$argon2i$v=19$m=4096,t=3,p=1$YzQzMWI4NzItMjkxOC00YmQwLWE5YjQtOTNlMDQ1OGJkNmE1$H1/LvkX3DlsuIheeaZJ2lkM839wUdgiA7rrR6T9rpOc"
ssh_key             = "ssh-ed25519 AAAA example-key"

# Bowtie API credentials (used to configure resources)
bowtie_username = "admin@bowtie.example.com"
bowtie_password = "example_password"

# Network settings
ipv4_range = "10.10.0.0/24"

# Resource configuration
create_default_resources = true
