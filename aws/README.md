# Deploying Bowtie Controllers in AWS Using Terraform

This repository provides a solution for deploying a high-availability cluster of Bowtie controllers in AWS using Terraform. You can use it either as a "1-click" deployment option by replacing the variables listed, or as a reference guide for the infrastructure needed to support Bowtie controllers in AWS.

## What This Deployment Creates

In addition to standing up a new Bowtie site, the deployment process also creates and configures the following AWS resources:

- VPC
- Subnet
- Route Table
- Internet Gateway
- Security Group
- EC2 Instances

## Prerequisites

Before beginning deployment, complete the following steps:

1. **Create Elastic IP Addresses**
   - Create as many [elastic IP addresses](https://us-east-2.console.aws.amazon.com/ec2/home?region=us-east-2#Addresses:) as the number of instances you plan to deploy
   - These should be created in the same AWS region where you'll deploy your instances

2. **Plan Your DNS Configuration**
   - Decide on the hostname for each controller instance
   - Set up the corresponding DNS entries for each hostname
   - Note: When setting the parameters in your tfvars file, you'll split the FQDN between `dns_zone_name` and `controller_name`
   - Example: For FQDN `c0.aws.bowtie.example.com`, use:
     - `dns_zone_name`: `aws.bowtie.example.com`
     - `controller_name`: `c0`

3. **Create a Cloud-Init File**
   - This file seeds your deployment with initial configuration parameters
   - Can include settings like admin credentials, SSO configuration, SSH access keys, and controller update preferences
   - An example can be found in our [public documentation](https://docs.bowtie.works/setup-controller.html#seeding-configuration)
   - Or use [our cloud-init generation script](https://github.com/bowtieworks/cloud-init-gen) to create one (recommended option)

## Deployment Steps

1. Clone this repository

2. Configure `terraform.tfvars` with:
   - AWS authentication
   - AWS resource group information 
   - Network details 
   - See the [examples](./examples/) directory for sample configurations covering various deployment types

4. Provide the necessary `cloud-init` files in the [compute](./modules/compute) module:
   - For a deploying a new, single controller: Place one file at `module/compute/cloud-init-first-instance.yaml`
   - For joining an existing cluster: Place one file at `module/compute/cloud-init-join-cluster.yaml`
   - For high-availability deployment: Place two files:
     - First controller: `module/compute/cloud-init-first-instance.yaml`
     - Subsequent controllers: `module/compute/cloud-init-join-cluster.yaml`
   - You can use the default file locations or specify your own paths

5. Set required environment variables:
   - Bowtie Username (for API authentication)
   - Bowtie Password (for API authentication)
   - The `site_id` from your cloud-init file(s)

6. Initialize, validate, and deploy:
   - Run `terraform init` to prepare the environment
   - Run `terraform plan` to validate the expected deployment
   - Run `terraform apply` to deploy

## Additional Notes

- See [examples](./examples/) for deploying within an existing VPC/subnet or creating new ones
- The number of instances deployed depends on the number of controller names listed
- When joining an existing cluster:
   - Ensure the `sync_psk` matches the existing cluster's key
   - Set the `join_existing_cluster` flag to `true`
- After deployment, visit one of your controller hostnames in a web browser to:
   - Configure access policies
   - Add additional private resources
