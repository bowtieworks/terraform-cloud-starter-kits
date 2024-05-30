# Shared variables 
project = "bowtie"
region  = "us-east1"

# Network module
create_vpc     = true # set to false to use a pre-existing VPC, identifed by name
create_subnets = true # set to false to use pre-existing subnets, identified by name 
vpc_name       = "example-vpc"
subnet_names   = ["example-vpc-subnet-1", "example-vpc-subnet-2"]
subnet_cidrs   = ["10.10.1.0/24", "10.10.2.0/24"]
subnet_regions = ["us-east1", "us-west1"]

# Compute module
machine_type    = "e2-medium"
network_tier    = "STANDARD"
image_ver       = "24-05-004" # see https://api.bowtie.works/platforms/GCP for latest version 
dns_zone_name   = "gcp.bowtie.example.com"
controller_name = ["c0", "c1"]
external_ips    = ["35.211.195.10", "35.212.197.140"]

# Bowtie module
ipv4_range = "10.0.0.0/16"
