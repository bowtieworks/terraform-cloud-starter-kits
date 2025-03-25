#-----------------------------------------------------
# AWS Configuration 
#-----------------------------------------------------
region  = "us-east-2"        # AWS region where resources will be deployed
profile = "default"          # AWS CLI profile to use for authentication

#-----------------------------------------------------
# Network Configuration
#-----------------------------------------------------
# Option 1: Create a new VPC (recommended for new deployments)
create_vpc       = true      # Set to true to create a new VPC
vpc_name         = "bowtie-demo"  # Name for the new VPC (also used as resource prefix)
cidr_block       = "10.10.0.0/16" # CIDR block for the new VPC

# Option 2: Use an existing VPC (uncomment and set vpc_id if using existing VPC)
# create_vpc     = false
# vpc_id         = "vpc-12345abcdef" # ID of your existing VPC

#-----------------------------------------------------
# Subnet Configuration
#-----------------------------------------------------
# Option 1: Create new subnets (used with new VPC)
create_subnets   = true
subnet_names     = ["subnet-1"]
subnet_cidrs     = ["10.10.1.0/24"]
subnet_azs       = ["us-east-2a"]  # Must match your region above

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
instance_type    = "t2.large"  # EC2 instance type for controllers
# iam_instance_profile = "your-profile-name"  # Optional: IAM instance profile

# Deployment Pattern
controller_count = 2           # Total number of controllers to deploy
# controller_name  = ["primary", "secondary"]  # Optional: custom names for controllers
                                               # If not provided, will use "c0", "c1", etc.

#-----------------------------------------------------
# EIP Configuration
#-----------------------------------------------------
# Option 1: Create new Elastic IPs (recommended)
create_eips      = true

# Option 2: Use existing Elastic IPs (uncomment if using existing EIPs)
# create_eips     = false
# eip_addresses   = ["1.2.3.4", "5.6.7.8"]

#-----------------------------------------------------
# DNS Configuration
#-----------------------------------------------------
dns_zone_name    = "bowtie.example.com"  # Domain suffix for your controllers

# Option: Create Route53 DNS records (requires Route53 hosted zone)
create_dns_records = false
# route53_zone_id   = "Z1234567890ABCD"  # Your Route53 hosted zone ID
# dns_ttl           = 300                 # TTL for DNS records in seconds

#-----------------------------------------------------
# Bowtie Configuration
#-----------------------------------------------------
# Required fields
site_id          = "00000000-0000-4000-8000-000000000000" # Unique site identifier
sync_psk         = "11111111-1111-4111-9111-111111111111" # Pre-shared key for sync
admin_email      = "admin@example.com"                    # Admin email 
admin_password_hash = "$argon2i$v=19$m=4096,t=3,p=1$YzQzMWI4NzItMjkxOC00YmQwLWE5YjQtOTNlMDQ1OGJkNmE1$H1/LvkX3DlsuIheeaZJ2lkM839wUdgiA7rrR6T9rpOc" # Hashed password
ssh_key          = "ssh-ed25519 AAAA example-key"         # SSH key for instance access

# Bowtie API credentials (used to configure resources)
bowtie_username  = "admin@example.com"  # Should match admin_email above
bowtie_password  = "example_password"   # Plain text password for API access

# Network settings
ipv4_range       = "10.10.0.0/24"       # IPv4 range for internal resources

# Resource configuration
create_default_resources = true          # Create default resources in Bowtie

# Optional: SSO Configuration
# Uncomment and edit the following for SSO integration
# You need to use proper string formatting with newlines (\n) for multi-line values
# sso_config = "type: gitlab\nid: gitlab\nname: GitLab\nconfig:\n  clientID: 5958e\n  clientSecret: gloas-456f7\n  redirectURI: $DEX_ORIGIN/dex/callback"