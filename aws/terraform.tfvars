# Shared variables
# region = "" # specify a region to use one other than the default

# Network module
#### Fill out the below to create a new vpc and subnet #### 
create_vpc     = true
create_subnets = true
vpc_name       = "bowtie-vpc"
cidr_block     = "10.10.0.0/16"
subnet_names   = ["bowtie-vpc-subnet-1"]
subnet_cidrs   = ["10.10.10.0/24"]
subnet_azs     = ["us-east-1a"]

#### Fill out the below to instead deploy within an existing vpc and subnet ####
# vpc_id    = ""
# subnet_id = ""

# Compute module
instance_type   = "t2.medium"
dns_zone_name   = "aws.bowtie.example.com"
controller_name = ["c0", "c1"]
eip_addresses   = ["3.15.99.237", "3.23.252.185"]
# owner_id        = ["055769116956"] # use if deploying within aws govcloud

#### Fill out the below if deploying to an existing cluster ####
# join_existing_cluster    = true
# join_controller_hostname = "existing-cluster.bowtie.example.com"

# Bowtie module
ipv4_range     = "10.10.0.0/16"
