region  = "us-east-2"       # The AWS region the resources will be created within.
profile = "example-profile" # The AWS profile to use for authentication.

vpc_id            = "vpc-07c194ea8b3bca0e7"    # The ID of the VPC to deploy the controller within.
subnet_id         = "subnet-0145e6ad55de75312" # The ID of the subnet to deploy the controller within.
security_group_id = "sg-060e156fbb6b5764d"     # The ID of the security group to associate with the controller.

instance_type   = "t2.large"           # The instance type to be used for the controller.
owner_id        = ["055761336000"]     # The owner ID to be used for fetching the AMI (Only required if using an AMI from AWS GovCloud see https://docs.bowtie.works/setup-controller.html#aws).
dns_zone_name   = "bowtie.example.com" # The DNS zone name to be used for the controller (combines with controller_name to create FQDN).
controller_name = ["c0"]               # The name of the controller to be created (combines with dns_zone_name to create FQDN).
eip_addresses   = ["0.0.0.0"]          # Replace with the EIP address to be associated with the controller.

ipv4_range               = "10.10.0.0/24"                         # The IPv4 range to be used for the Bowtie site.
site_id                  = "00000000-0000-4000-8000-000000000000" # The site ID to be used for the Bowtie site (should match the site ID specified in cloud-init).
bowtie_username          = "admin@bowtie.example.com"             # The username to be used for the Bowtie site.
bowtie_password          = "example_password"                     # The password to be used for the Bowtie site.
create_default_resources = true                                   # Whether to create default resources for the Bowtie site.