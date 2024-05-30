# Shared variables
resource_group_name     = "bowtie-tf"
resource_group_location = "eastus"

# Network module
create_vnet             = true # set to false to use a pre-existing vnet, identified by name
vnet_name               = "example-vnet"
vnet_address_space      = ["10.0.0.0/16"]
subnet_address_prefixes = ["10.0.1.0/24", "10.0.2.0/24"]

# Virtual_machine module
size            = "Standard_D2as_v4"
dns_zone_name   = "az.bowtie.example.com"
controller_name = ["c0", "c1"]
public_ips      = ["c0-pip", "c1-pip"]

# Bowtie module
ipv4_range = "10.0.0.0/16"
