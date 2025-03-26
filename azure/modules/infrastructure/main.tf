provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

locals {
  # Determine the number of controllers to create
  actual_controller_count = var.controller_count > 0 ? var.controller_count : length(var.controller_name)

  # Generate controller names
  generated_controller_names = [
    for i in range(local.actual_controller_count) :
    i < length(var.controller_name) ? var.controller_name[i] : "c${i}"
  ]

  # For resource naming
  resource_controller_names = [
    for i in range(local.actual_controller_count) :
    "${local.generated_controller_names[i]}-${var.resource_group_name}"
  ]

  # Format domain name labels to comply with Azure requirements
  # Must be lowercase, alphanumeric, start with letter, end with letter or number, max 63 chars
  dns_safe_controller_names = [
    for name in local.generated_controller_names :
    lower(replace(name, "_", "-"))
  ]
}

#--------------------------
# Resource Group
#--------------------------

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_resource_group" "existing_rg" {
  count = var.create_resource_group ? 0 : 1
  name  = var.resource_group_name
}

locals {
  resource_group_id       = var.create_resource_group ? azurerm_resource_group.rg[0].id : data.azurerm_resource_group.existing_rg[0].id
  resource_group_name     = var.create_resource_group ? azurerm_resource_group.rg[0].name : data.azurerm_resource_group.existing_rg[0].name
  resource_group_location = var.create_resource_group ? azurerm_resource_group.rg[0].location : data.azurerm_resource_group.existing_rg[0].location
}

#--------------------------
# Networking Resources
#--------------------------

resource "azurerm_virtual_network" "vnet" {
  count               = var.create_vnet ? 1 : 0
  name                = var.vnet_name
  address_space       = [var.address_space]
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
}

data "azurerm_virtual_network" "existing_vnet" {
  count               = var.create_vnet ? 0 : 1
  name                = var.vnet_name
  resource_group_name = local.resource_group_name
}

locals {
  vnet_id   = var.create_vnet ? azurerm_virtual_network.vnet[0].id : data.azurerm_virtual_network.existing_vnet[0].id
  vnet_name = var.create_vnet ? azurerm_virtual_network.vnet[0].name : data.azurerm_virtual_network.existing_vnet[0].name
}

resource "azurerm_subnet" "subnet" {
  count                = var.create_subnet ? 1 : 0
  name                 = var.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.vnet_name
  address_prefixes     = [var.subnet_prefix]
}

data "azurerm_subnet" "existing_subnet" {
  count                = var.create_subnet ? 0 : 1
  name                 = var.subnet_name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.vnet_name
}

locals {
  subnet_id = var.create_subnet ? azurerm_subnet.subnet[0].id : data.azurerm_subnet.existing_subnet[0].id
}

#--------------------------
# Network Security Group
#--------------------------

resource "azurerm_network_security_group" "nsg" {
  count               = var.create_nsg ? 1 : 0
  name                = var.nsg_name
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "HTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "WG"
    priority                   = 105
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowICMP"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Icmp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

data "azurerm_network_security_group" "existing_nsg" {
  count               = var.create_nsg ? 0 : 1
  name                = var.nsg_name
  resource_group_name = local.resource_group_name
}

locals {
  nsg_id = var.create_nsg ? azurerm_network_security_group.nsg[0].id : data.azurerm_network_security_group.existing_nsg[0].id
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  subnet_id                 = local.subnet_id
  network_security_group_id = local.nsg_id
}

#--------------------------
# Public IP Addresses
#--------------------------

# Look up existing public IPs if create_public_ips is false
data "azurerm_public_ip" "existing_pip" {
  count               = var.create_public_ips ? 0 : length(var.public_ip_addresses)
  name                = var.public_ip_addresses[count.index]
  resource_group_name = local.resource_group_name
}

# Create new public IPs if create_public_ips is true
resource "azurerm_public_ip" "public_ip" {
  count               = var.create_public_ips ? local.actual_controller_count : 0
  name                = "${local.generated_controller_names[count.index]}-pip"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name
  allocation_method   = var.allocation_method
  
  # Use a predictable pattern with resource group name for uniqueness
  # The name is sanitized to ensure it complies with Azure requirements
  domain_name_label   = "bowtie-${count.index}-${lower(replace(replace(var.resource_group_name, "/[^a-zA-Z0-9]/", ""), "bowtie", "bt"))}"

  tags = {
    Name = "${local.generated_controller_names[count.index]}-pip"
  }
}

#--------------------------
# DNS Records
#--------------------------

data "azurerm_dns_zone" "dns_zone" {
  count               = var.create_dns_records && var.dns_zone_resource_group != "" ? 1 : 0
  name                = var.dns_zone_name
  resource_group_name = var.dns_zone_resource_group
}

resource "azurerm_dns_a_record" "dns_record" {
  count               = var.create_dns_records && var.dns_zone_resource_group != "" ? local.actual_controller_count : 0
  name                = local.generated_controller_names[count.index]
  zone_name           = data.azurerm_dns_zone.dns_zone[0].name
  resource_group_name = var.dns_zone_resource_group
  ttl                 = var.dns_ttl
  records = [
    var.create_public_ips ? azurerm_public_ip.public_ip[count.index].ip_address : (
      count.index < length(var.public_ip_addresses) ? data.azurerm_public_ip.existing_pip[count.index].ip_address : azurerm_public_ip.public_ip[count.index].ip_address
    )
  ]
}

# Wait for DNS propagation
resource "time_sleep" "dns_propagation" {
  count      = var.create_dns_records && var.dns_zone_resource_group != "" ? 1 : 0
  depends_on = [azurerm_dns_a_record.dns_record]

  create_duration = "${var.dns_propagation_wait}s"
}

# Create a dependency connection
resource "null_resource" "dns_dependency" {
  count = var.create_dns_records && var.dns_zone_resource_group != "" ? 1 : 0

  triggers = {
    # This will change whenever the time_sleep resource changes
    dns_propagation_complete = var.create_dns_records ? time_sleep.dns_propagation[0].id : "no-dns"
  }
}

#--------------------------
# VM and NIC Configuration
#--------------------------

# Create a network interface for each VM
resource "azurerm_network_interface" "nic" {
  count               = local.actual_controller_count
  name                = "${local.generated_controller_names[count.index]}-nic"
  location            = local.resource_group_location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = local.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.create_public_ips ? azurerm_public_ip.public_ip[count.index].id : (
      count.index < length(var.public_ip_addresses) ? data.azurerm_public_ip.existing_pip[count.index].id : null
    )
  }
}

# Create Linux VMs
resource "azurerm_linux_virtual_machine" "vm" {
  count               = local.actual_controller_count
  name                = local.resource_controller_names[count.index]
  resource_group_name = local.resource_group_name
  location            = local.resource_group_location
  size                = var.vm_size
  admin_username      = var.admin_username
  source_image_id     = "/communityGalleries/bowtiecontroller-ee2d3cce-b6ae-4d47-a93b-b88591ea9108/images/controller/versions/latest"

  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  # Create instances only after DNS propagation if DNS is being used
  depends_on = [
    azurerm_public_ip.public_ip,
    null_resource.dns_dependency
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.admin_ssh_public_key_path) # this will be overwritten by cloud-init ssh key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  custom_data = base64encode(
    var.join_existing_cluster ? templatefile("${path.module}/cloud-init-join-cluster.tftpl", {
      controller_name         = local.generated_controller_names[count.index]
      dns_zone_name           = var.dns_zone_name
      site_id                 = var.site_id
      sync_psk                = var.sync_psk
      primary_controller_fqdn = var.join_existing_cluster_fqdn # Use the provided FQDN
      ssh_key                 = var.ssh_key
      sso_config              = var.sso_config
      }) : (
      count.index == 0 ? templatefile("${path.module}/cloud-init-first-instance.tftpl", {
        controller_name     = local.generated_controller_names[count.index]
        dns_zone_name       = var.dns_zone_name
        site_id             = var.site_id
        sync_psk            = var.sync_psk
        admin_email         = var.admin_email
        admin_password_hash = var.admin_password_hash
        ssh_key             = var.ssh_key
        sso_config          = var.sso_config
        }) : templatefile("${path.module}/cloud-init-join-cluster.tftpl", {
        controller_name         = local.generated_controller_names[count.index]
        dns_zone_name           = var.dns_zone_name
        site_id                 = var.site_id
        sync_psk                = var.sync_psk
        primary_controller_fqdn = "${local.generated_controller_names[0]}.${var.dns_zone_name}" # Auto-generated first controller FQDN
        ssh_key                 = var.ssh_key
        sso_config              = var.sso_config
      })
    )
  )

  tags = {
    Name = local.resource_controller_names[count.index]
  }
}

#--------------------------
# Health Check
#--------------------------

# First, wait for VM boot and service initialization
resource "time_sleep" "wait_for_bowtie_startup" {
  depends_on = [azurerm_linux_virtual_machine.vm]
  
  # Adjust this time as needed - 5 minutes should be sufficient for most VMs to boot
  # and for the Bowtie service to initialize
  create_duration = "120s"  # 5 minutes
}

# Then perform the health check
resource "null_resource" "health_check" {
  # Make the health check depend on the time_sleep resource
  depends_on = [time_sleep.wait_for_bowtie_startup]

  triggers = {
    # This will change whenever the VMs change
    vm_ids = join(",", [for vm in azurerm_linux_virtual_machine.vm : vm.id])
  }
}
