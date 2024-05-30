# Shared variables
region = "us-east-2"

# Network module
create_vpc     = true # set to false to use a pre-existing VPC, identifed by name
create_subnets = true # set to false to use pre-existing subnets, identified by name 
vpc_name       = "example-vpc"
cidr_block     = "10.0.0.0/16"
subnet_names   = ["example-vpc-subnet-1", "example-vpc-subnet-2"]
subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
subnet_azs     = ["us-east-2a", "us-east-2b"]

# Compute module
ami             = "ami-048916a9d7c612211" # see https://api.bowtie.works/platforms/AWS for ami list
instance_type   = "t2.medium"
dns_zone_name   = "aws.bowtie.example.com"
controller_name = ["c0", "c1"]
eip_addresses   = ["3.15.99.237", "3.23.252.185"]

# Bowtie module
ipv4_range = "10.0.0.0/16"
