data "azurerm_public_ip" "existing_public_ip" {
  resource_group_name = var.resource_group_name
  count               = length(var.public_ips)
  name                = var.public_ips[count.index]
}

resource "azurerm_network_interface" "network_interface" {
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  count               = length(var.controller_name)
  name                = "c${count.index}-nic"

  ip_configuration {
    name                          = "c${count.index}-ipconfig"
    subnet_id                     = length(var.subnet_ids) > 1 ? var.subnet_ids[count.index] : var.subnet_ids[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = data.azurerm_public_ip.existing_public_ip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "virtual_machine" {
  resource_group_name             = var.resource_group_name
  location                        = var.resource_group_location
  count                           = length(var.controller_name)
  name                            = "c${count.index}-vm"
  size                            = var.size
  admin_username                  = "azureuser"
  disable_password_authentication = true
  custom_data = count.index == 0 ? base64encode(<<-EOF
#cloud-config
fqdn: ${var.controller_name[0]}.${var.dns_zone_name}
hostname: ${var.controller_name[0]}.${var.dns_zone_name}
preserve_hostname: false
prefer_fqdn_over_hostname: true

write_files:
- path: /etc/bowtie-server.d/custom.conf
  content: |
    SITE_ID=${var.site_id}
    BOWTIE_SYNC_PSK=${var.sync_psk}
- path: /var/lib/bowtie/init-users
  content: |
    ${var.user_credentials}
- path: /var/lib/bowtie/skip-gui-init
- path: /etc/update-at

users:
- name: root
  ssh_authorized_keys:
    - ${var.public_ssh_key}
  lock_passwd: true
EOF
    ) : base64encode(<<-EOF
#cloud-config
fqdn: ${var.controller_name[count.index]}.${var.dns_zone_name}
hostname: ${var.controller_name[count.index]}.${var.dns_zone_name}
preserve_hostname: false
prefer_fqdn_over_hostname: true

write_files:
- path: /etc/bowtie-server.d/custom.conf
  content: |
    SITE_ID=${var.site_id}
    BOWTIE_SYNC_PSK=${var.sync_psk}
- path: /var/lib/bowtie/should-join.conf
  content: |
    entrypoint = "https://${var.controller_name[0]}.${var.dns_zone_name}"
- path: /var/lib/bowtie/skip-gui-init
- path: /etc/update-at

users:
- name: root
  ssh_authorized_keys:
    - ${var.public_ssh_key}
  lock_passwd: true
EOF
  )
  source_image_id       = "/communityGalleries/bowtiecontroller-ee2d3cce-b6ae-4d47-a93b-b88591ea9108/images/controller/versions/latest"
  network_interface_ids = [azurerm_network_interface.network_interface[count.index].id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub") # this will be overwritten by cloud-init ssh key
  }
}
