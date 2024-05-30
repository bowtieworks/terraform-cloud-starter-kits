## Deploying Bowtie controllers in Azure using Terraform

This repository serves an example for deploying a high-avilability cluster of controllers in Azure using Terraform. It can either act as a "1-click" deploy option by replacing the variables listed with one's own respective values, or, it may be used a reference guide for the infrastructure needed to support standing up Bowtie controllers in Azure. The deployment process includes the following infrastructure creation and association:

- resource groups
- vnets
- subnets
- network security group
- port rules
- virtual machines
- Bowtie site deployment and route modifications

#### Prerequisites

This repository operates on the assumption that one or more [public IP address objects](https://portal.azure.com/#view/HubsExtension/BrowseResource/resourceType/Microsoft.Network%2FPublicIpAddresses) have already been created under the `Resource Group` in which the instances will be deployed within. Approaching the installation in this way allows for the hostnames that are to be used to have their DNS settings prepared prior to the controller initialization. 

Due to this, a few prerequisites should be completed prior to deployment: 

1. Create a `Resource Group` if one is not already prepared
2. Create as many `public IP address` objects as instances expected to be deployed. The configuration will be assigning a public IP address to each instance
    - Note the `name` of each object, as this will be used below
3. Decide on the hostname to assign to each controller instance and then setup the corresponding DNS entries
    - Note that the fqdn will be split up between a `dns_zone_name` and a `controller_name` when building your terraform configuration file. For example, if the fqdn is `c0.az.bowtie.example.com` then the `dns_zone_name` will be `az.bowtie.example.com` while the `controller_name` will be `c0`.

#### Deployment steps

If opting to use this repository for deployment rather than as reference guide, follow the below steps:

1. Clone repository
2. Fill out the variables listed `terraform.tfvars` according to your Azure resource group information, network specifications, and naming conventions
    - Be sure to include the names of the `public IP address` objects that will be provisioned to each instance
3. Apply the necessary environment variables, this includes:
    - Initial admin user credentials (See [Seeding Configuration](https://docs.bowtie.works/setup-controller.html#seeding-configuration) for an example on how to generate them)
    - Plaintext Bowtie Username in order to authenticate with the Bowtie API
    - Plaintext Bowtie Password in order to authenticate with the Bowtie API
    - `BOWTIE_SYNC_PSK` (We recommend using `uuidgen` to create a new uuidv4; **must be lowercase**)
4. Run `terraform init` to prepare the environment
5. Run `terraform plan` to validate the expected deployment
6. When ready, run `terraform apply` to deploy

#### Additional Notes

- If run as is, the repository will deploy all of the necessary infrastructure within Azure to support a high-availability Bowtie deployment, however, in many cases much of that infrastructure may already be present. For example, if its preferred to use an existing Vnet, set the `create_vnet` flag to `false`, and specify the name of the Vnet to use in the `vnet_name` name field  
- The number of instances deployed are dependent on the number of controller names listed
- If planning to join an existing cluster of controllers, be sure that the `sync_psk` matches the existing cluster's key and that the `entrypoint` in the `should_join.conf` file matches at least one hostname in the existing cluster
- Once finished with the terraform deployment, we recommend heading to one of the controller hostnames in your web browser to configure your access policies and begin adding additional private resources
