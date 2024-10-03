# Shared variables
region = "us-east-2" # specify a region to use other than default

# Network module
#### Use the below to create a new vpc and subnet #### 
create_vpc     = true
create_subnets = true
vpc_name       = "example-bowtie-vpc"
cidr_block     = "10.10.0.0/16"
subnet_names   = ["subnet-us-east-2"]
subnet_cidrs   = ["10.10.10.0/24"]
subnet_azs     = ["us-east-2a"]

#### Use the below to deploy within an existing vpc and subnet ####
# vpc_id    = "<vpc-id>"
# subnet_id = "<subnet-id>"

# Compute module
instance_type        = "t2.large"
iam_instance_profile = "example-iam-role"
dns_zone_name        = "aws.bowtie.example.com"
controller_name      = ["c0", "c1"]
eip_addresses        = ["<IP>", "<IP>"]
owner_id             = ["055761336000"]

#### Use the below if joining to an existing deployment ####
# join_existing_cluster    = true

# Bowtie module
ipv4_range      = "10.10.0.0/16"
site_id         = "<UUIDv4>"
bowtie_username = "admin@example.com"
bowtie_password = "example_password"