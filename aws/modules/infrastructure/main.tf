provider "aws" {
  region  = var.region
  profile = var.profile
}

terraform {
  required_providers {
    checkmate = {
      source  = "tetratelabs/checkmate"
      version = "1.5.0"
    }
  }
}

locals {
  # Create a resource prefix from the VPC name
  vpc_name_effective = var.vpc_name != "" ? var.vpc_name : (
    var.vpc_id != "" ? var.vpc_id : "bowtie"
  )

  # Determine the number of controllers to create
  actual_controller_count = var.controller_count > 0 ? var.controller_count : length(var.controller_name)

  # Generate controller names - two sets:
  # 1. Host names (for DNS and cloud-init) - e.g., c0.example.com
  # 2. Resource names (for AWS resources) - e.g., c0-vpc-name

  # For hostnames and DNS - simple controller names
  generated_controller_names = [
    for i in range(local.actual_controller_count) :
    i < length(var.controller_name) ? var.controller_name[i] : "c${i}"
  ]

  # For resource naming (EC2 instances, EIPs, etc.) - prefix controller name before vpc name
  resource_controller_names = [
    for i in range(local.actual_controller_count) :
    "${local.generated_controller_names[i]}-${local.vpc_name_effective}"
  ]

  # Validate subnet configuration
  subnet_validation_error = length(var.subnet_azs) > 0 && length(var.subnet_azs) != length(var.subnet_names) ? file("ERROR: If specifying subnet_azs, you must provide one for each subnet in subnet_names.") : null
}

#--------------------------
# VPC and Network Resources
#--------------------------

resource "aws_vpc" "vpc" {
  count      = var.create_vpc ? 1 : 0
  cidr_block = var.cidr_block

  tags = {
    Name = local.vpc_name_effective
  }
}

data "aws_vpc" "existing_vpc" {
  count = var.create_vpc ? 0 : (var.vpc_id != "" ? 1 : 0)

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_subnet" "subnets" {
  count             = var.create_subnets ? length(var.subnet_names) : 0
  vpc_id            = var.create_vpc ? aws_vpc.vpc[0].id : data.aws_vpc.existing_vpc[0].id
  cidr_block        = var.subnet_cidrs[count.index]
  availability_zone = var.subnet_azs[count.index]

  tags = {
    Name = "${var.subnet_names[count.index]}-${local.vpc_name_effective}"
  }
}

data "aws_subnet" "existing_subnet" {
  count = var.subnet_id != "" ? 1 : 0

  filter {
    name   = "subnet-id"
    values = [var.subnet_id]
  }
}

resource "aws_internet_gateway" "igw" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  tags = {
    Name = "igw-${local.vpc_name_effective}"
  }
}

resource "aws_route_table" "rt" {
  count  = var.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

  tags = {
    Name = "rt-${local.vpc_name_effective}"
  }
}

resource "aws_route_table_association" "subnet_rt_assoc" {
  count = var.create_subnets ? length(var.subnet_names) : 0

  subnet_id      = aws_subnet.subnets[count.index].id
  route_table_id = aws_route_table.rt[0].id
}

#--------------------------
# Security Group
#--------------------------

resource "aws_security_group" "sg" {
  count       = var.create_security_group ? 1 : 0
  name        = "${local.vpc_name_effective}-sg"
  description = "Security group for Bowtie controllers"
  vpc_id      = var.create_vpc ? aws_vpc.vpc[0].id : var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1 # -1 means all ICMP types
    to_port     = -1 # -1 means all ICMP codes
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-${local.vpc_name_effective}"
  }
}

data "aws_security_group" "sg_data" {
  id = var.create_security_group ? aws_security_group.sg[0].id : var.security_group_id
}

#--------------------------
# EC2 Instances & EIPs
#--------------------------

# Look up existing EIPs if create_eips is false and eip_addresses are provided
data "aws_eip" "eip_data" {
  count     = var.create_eips ? 0 : length(var.eip_addresses)
  public_ip = var.eip_addresses[count.index]
}

# Create new EIPs if create_eips is true
resource "aws_eip" "controller_eips" {
  count  = var.create_eips ? local.actual_controller_count : 0
  domain = var.eip_domain

  tags = {
    Name = "${local.generated_controller_names[count.index]}-${local.vpc_name_effective}-eip"
  }
}

#--------------------------
# DNS Records
#--------------------------

resource "aws_route53_record" "controller_records" {
  count   = var.create_dns_records && var.route53_zone_id != "" ? local.actual_controller_count : 0
  zone_id = var.route53_zone_id
  name    = "${local.generated_controller_names[count.index]}.${var.dns_zone_name}"
  type    = "A"
  ttl     = var.dns_ttl
  records = [
    var.create_eips ? aws_eip.controller_eips[count.index].public_ip : (
      count.index < length(var.eip_addresses) ? var.eip_addresses[count.index] : aws_eip.controller_eips[count.index].public_ip
    )
  ]
}

# Wait for DNS propagation
resource "time_sleep" "dns_propagation" {
  count      = var.create_dns_records && var.route53_zone_id != "" ? 1 : 0
  depends_on = [aws_route53_record.controller_records]

  create_duration = "${var.dns_propagation_wait}s"
}

# Create a dependency connection
resource "null_resource" "dns_dependency" {
  count = var.create_dns_records && var.route53_zone_id != "" ? 1 : 0

  triggers = {
    # This will change whenever the time_sleep resource changes
    dns_propagation_complete = var.create_dns_records ? time_sleep.dns_propagation[0].id : "no-dns"
  }
}

data "aws_ami" "controller" {
  most_recent = true
  owners      = var.owner_id
}

resource "aws_instance" "instance" {
  count                  = local.actual_controller_count
  ami                    = data.aws_ami.controller.id
  iam_instance_profile   = var.iam_instance_profile
  instance_type          = var.instance_type
  subnet_id              = var.create_subnets ? aws_subnet.subnets[0].id : var.subnet_id
  vpc_security_group_ids = [data.aws_security_group.sg_data.id]

  # Create instances only after DNS propagation if DNS is being used
  depends_on = [
    aws_eip.controller_eips,
    null_resource.dns_dependency
  ]

  user_data = var.join_existing_cluster ? templatefile("${path.module}/${var.cloud_init_join_cluster}", {
    controller_name         = local.generated_controller_names[count.index]
    dns_zone_name           = var.dns_zone_name
    site_id                 = var.site_id
    sync_psk                = var.sync_psk
    primary_controller_fqdn = var.join_existing_cluster_fqdn
    ssh_key                 = var.ssh_key
    sso_config              = var.sso_config
    }) : (
    count.index == 0 ? templatefile("${path.module}/${var.cloud_init_first_instance}", {
      controller_name     = local.generated_controller_names[count.index]
      dns_zone_name       = var.dns_zone_name
      site_id             = var.site_id
      sync_psk            = var.sync_psk
      admin_email         = var.admin_email
      admin_password_hash = var.admin_password_hash
      ssh_key             = var.ssh_key
      sso_config          = var.sso_config
      }) : templatefile("${path.module}/${var.cloud_init_join_cluster}", {
      controller_name         = local.generated_controller_names[count.index]
      dns_zone_name           = var.dns_zone_name
      site_id                 = var.site_id
      sync_psk                = var.sync_psk
      primary_controller_fqdn = "${local.generated_controller_names[0]}.${var.dns_zone_name}" # Auto-generated first controller FQDN
      ssh_key                 = var.ssh_key
      sso_config              = var.sso_config
    })
  )

  tags = {
    Name = "${local.generated_controller_names[count.index]}-${local.vpc_name_effective}-instance"
  }
}

# Associate instances with either existing or newly created EIPs
resource "aws_eip_association" "eip_assoc" {
  count       = local.actual_controller_count
  instance_id = aws_instance.instance[count.index].id
  allocation_id = var.create_eips ? aws_eip.controller_eips[count.index].id : (
    count.index < length(var.eip_addresses) ? data.aws_eip.eip_data[count.index].id : aws_eip.controller_eips[count.index].id
  )

  depends_on = [
    aws_instance.instance,
    aws_eip.controller_eips
  ]
}

#--------------------------
# Health Check for API Availability
#--------------------------

resource "checkmate_http_health" "healthcheck" {
  # Use the hostname since DNS is properly set up
  url = "https://${local.generated_controller_names[0]}.${var.dns_zone_name}/-net/api/v0/ok"

  # Will perform an HTTP GET request
  method = "GET"

  # Increase timeouts and interval for better reliability
  timeout  = 1000 * 60 * 3
  interval = 10000

  # Expect a status 200 OK
  status_code = 200

  # Only require 2 successes to speed things up
  consecutive_successes = 2

  # Attempt to continue even if the health check fails
  # This prevents blocking on first deployment when the controller needs time to initialize
  create_anyway_on_check_failure = true

  # Depend on the EIP association to ensure that happens first
  depends_on = [aws_eip_association.eip_assoc]
}
