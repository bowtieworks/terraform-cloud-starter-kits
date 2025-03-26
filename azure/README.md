# Deploying Bowtie Controllers in Azure Using Terraform

This repository provides a solution for deploying a high-availability cluster of Bowtie controllers in Azure using Terraform. You can use it either as a "1-click" deployment option by replacing the variables listed, or as a reference guide for the infrastructure needed to support Bowtie controllers in Azure.

## Deployment Components

- Azure resource group
- Virtual network and subnet
- Network security group
- Virtual machines
- Public IP addresses
- Azure DNS records (optional)
- Bowtie site configuration

## Deployment Steps

1. Clone this repository

2. Configure `terraform.tfvars` with:
   - Azure authentication 
   - Resource group information
   - Network details
   - See [examples](./examples/) for sample tfvar files that cover various deployment types

3. Set required environment variables:
   - Bowtie Username (for API authentication)
   - Bowtie Password (for API authentication)
   - Azure credentials (if not using Azure CLI authentication)

4. Initialize, validate, and deploy:
   - Run `terraform init` to prepare the environment
   - Run `terraform plan` to validate the expected deployment
   - Run `terraform apply` to deploy

## Deployment Options

### Fresh Deployment

For a new deployment in a new resource group and virtual network:

```hcl
create_resource_group = true
resource_group_name = "bowtie-prod"
controller_count = 2
create_public_ips = true
```

### Using Existing Infrastructure

To deploy within existing Azure infrastructure:

```hcl
create_resource_group = false
resource_group_name = "existing-rg"
create_vnet = false
vnet_name = "existing-vnet"
create_subnet = false
subnet_name = "existing-subnet"
create_nsg = false
nsg_name = "existing-nsg"
```

### Using Existing Public IPs

If you already have Public IPs allocated:

```hcl
create_public_ips = false
public_ip_addresses = ["existing-pip1", "existing-pip2"]
```

### Adding DNS Entries

To automatically create DNS records in Azure DNS:

```hcl
create_dns_records = true
dns_zone_resource_group = "dns-rg"
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

## Joining an Existing Cluster

To add controllers to an existing cluster:

```hcl
join_existing_cluster = true
join_existing_cluster_fqdn = "c0.bowtie.example.com"  # FQDN of existing primary controller
controller_count = 1  # Number of controllers to add
```

When joining an existing cluster:
- The new controllers will automatically join the existing primary controller
- Admin credentials are not required (only needed for new cluster initialization)
- Must use the same site ID and sync PSK as the existing cluster

## Cloud-Init Configuration

The deployment uses cloud-init to configure the controllers at boot time. This configuration includes:

- Setting the hostname and FQDN
- Configuring the site ID and sync key
- Setting up the admin user
- Configuring SSH access
- (Optionally) Setting up SSO integration

It's recommended to use [our cloud-init generation script](https://github.com/bowtieworks/cloud-init-gen) to generate the information needed in order to fully seed the deployment.

Reach out to taylor@bowtie.works if you have any questions.