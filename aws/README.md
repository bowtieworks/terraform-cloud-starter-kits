## Deploying Bowtie controllers in AWS using Terraform

This repository serves an example for deploying a high-avilability cluster of controllers in AWS using Terraform. It can either act as a "1-click" deploy option by replacing the variables listed with one's own respective values, or, it may be used a reference guide for the infrastructure needed to support standing up Bowtie controllers in AWS. The deployment process includes the following infrastructure creation and association:

- VPC
- subnets
- security groups
- port rules
- instances
- Bowtie site deployment and route modifications

#### Prerequisites

This repository operates on the assumption that one or more [elastic IP addresses](https://us-east-2.console.aws.amazon.com/ec2/home?region=us-east-2#Addresses:) have already been created under the `region` in which the instances will be deployed within. Approaching the installation in this way allows for the hostnames that are to be used to have their DNS settings prepared prior to the controller initialization. 

Due to this, a few prerequisites should be completed prior to deployment: 

1. Create as many `elastic IP address` objects as instances expected to be deployed. The configuration will be assigning a public IP address to each instance
2. Decide on the hostname to assign to each controller instance and then setup the corresponding DNS entries
    - Note that the fqdn will be split up between a `dns_zone_name` and a `controller_name` when building your terraform configuration file. For example, if the fqdn is `c0.aws.bowtie.example.com` then the `dns_zone_name` will be `aws.bowtie.example.com` while the `controller_name` will be `c0`.

Additionally, it is recommended that before starting the deployment, a `cloud-init` file should be created. This will allow for seeding the deployment with information such as the initial admin user credentials, an SSO configuration file, an ssh key for shell access, turning on automatic controller updates, and more. An example `cloud-init` file found in our [public documentation](https://docs.bowtie.works/setup-controller.html#seeding-configuration), however, Bowtie also provides [a cli for building a well-formed `cloud-init` file](https://github.com/bowtieworks/cloud-init-gen). Once the `cloud-init` file is in hand, follow the below steps to proceed with the deployment. 

#### Deployment steps

1. Clone repository
2. Fill out the variables listed `terraform.tfvars` according to your AWS resource group information, network specifications, and naming conventions
    - Be sure to include the IP addresses that are to be used in the `eip_addresses` field
3. Supply the `cloud-init` files in the [compute](./modules/compute) module
    - If deploying in a high-availbility mode, two `cloud-init` files will be needed. One for the first controller, and another for the second. The variables `var.cloud_init_first_instance` and `var.cloud_init_join_cluster` represent the paths to these respective files in the module. You can use the default file locations, or specify your own.
    - For example, if deploying to a new cluster (first deployment), and not in a HA mode, then a singular `cloud-init` file may be placed at `module/compute/cloud-init-first-instance.yaml`
    - If deploying to a pre-existing cluster, then a singular `cloud-init` may be placed at `module/compute/cloud-init-join-cluster.yaml`
    - If deploying to a new cluster, but in an HA mode, then one file would be placed at `module/compute/cloud-init-first-instance.yaml`, while a second `cloud-init`, which will handle joining the second instance to the first, would be placed it `module/compute/cloud-init-join-cluster.yaml`
3. Apply the necessary environment variables, this includes:
    - Plaintext Bowtie Username in order to authenticate with the Bowtie API
    - Plaintext Bowtie Password in order to authenticate with the Bowtie API
    - The `site_id` from the respective `cloud-init` files
4. Run `terraform init` to prepare the environment
5. Run `terraform plan` to validate the expected deployment
6. When ready, run `terraform apply` to deploy

#### Additional Notes

- If run as is, the repository will deploy all of the necessary infrastructure within AWS to support a high-availability Bowtie deployment, however, in many cases much of that infrastructure may already be present. For example, if its preferred to use an existing vpc, simply provide the `vpc_id` and `subnet_id`, and the terraform code will deploy the controllers within the existing infrastructure
- The number of instances deployed are dependent on the number of contoller names listed
- If planning to join an existing cluster of controllers, be sure that the `sync_psk` matches the existing cluster's key and that the `join_existing_cluster` flag is set to `true`
- Once finished with the terraform deployment, we recommend heading to one of the controller hostnames in your web browser to configure your access policies and begin adding additional private resources
