# Deploying Bowtie Controllers in AWS Using Terraform

This repository provides a solution for deploying a high-availability cluster of Bowtie controllers in AWS using Terraform. You can use it either as a "1-click" deployment option by replacing the variables listed, or as a reference guide for the infrastructure needed to support Bowtie controllers in AWS.

## Deployment Components

- AWS infrastructure (VPC, subnets, security groups)
- EC2 controller instances
- Elastic IP addresses
- Route53 DNS records (optional)
- Bowtie site configuration

## Deployment Steps

1. Clone this repository

2. Configure `terraform.tfvars` with:
   - AWS authentication
   - AWS resource group information 
   - Network details 

3. Set required environment variables:
   - Bowtie Username (for API authentication)
   - Bowtie Password (for API authentication)

4. Initialize, validate, and deploy:
   - Run `terraform init` to prepare the environment
   - Run `terraform plan` to validate the expected deployment
   - Run `terraform apply` to deploy

## Deployment Options

### Fresh Deployment

For a new deployment in a new VPC:

```hcl
create_vpc = true
vpc_name = "bowtie-prod"
controller_count = 2
create_eips = true
```

### Using Existing Infrastructure

To deploy within existing AWS infrastructure:

```hcl
create_vpc = false
vpc_id = "vpc-12345abcdef"
create_subnets = false
subnet_id = "subnet-12345abcdef"
create_security_group = false
security_group_id = "sg-12345abcdef"
```

### Using Existing Elastic IPs

If you already have Elastic IPs allocated:

```hcl
create_eips = false
eip_addresses = ["203.0.113.10", "203.0.113.11"]
```

### Adding DNS Entries

To automatically create DNS records in Route53:

```hcl
create_dns_records = true
route53_zone_id = "Z1234567890ABCD"
```

## High Availability Deployment

For high availability deployments:

```hcl
controller_count = 3  # Creates a 3-node cluster
```

In HA mode:
- The first controller becomes the primary node
- Subsequent controllers automatically join the primary node
- All controllers share the same site ID and sync key

## Cloud-Init Configuration

The deployment uses cloud-init to configure the controllers at boot time. This configuration includes:

- Setting the hostname and FQDN
- Configuring the site ID and sync key
- Setting up the admin user
- Configuring SSH access
- (Optionally) Setting up SSO integration

It's recommended to use [our cloud-init generation script](https://github.com/bowtieworks/cloud-init-gen) to generate the information needed in order to fully seed the deployment.

Reach out to taylor@bowtie.works if you have any questions.