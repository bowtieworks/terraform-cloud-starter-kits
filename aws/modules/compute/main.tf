data "aws_eip" "eip_data" {
  count     = length(var.eip_addresses)
  public_ip = var.eip_addresses[count.index]
}

data "aws_ami" "controller" {
  most_recent = true
  owners      = var.owner_id
}

resource "aws_instance" "instance" {
  count                  = length(var.controller_name)
  ami                    = data.aws_ami.controller.id
  instance_type          = var.instance_type
  subnet_id              = length(var.subnet_ids) > 1 ? var.subnet_ids[count.index] : var.subnet_ids[0]
  vpc_security_group_ids = var.vpc_security_group_ids

  user_data = var.join_existing_cluster ? (<<-EOF
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
    entrypoint = "https://${var.join_controller_hostname}"
- path: /var/lib/bowtie/skip-gui-init
- path: /etc/update-at

users:
- name: root
  ssh_authorized_keys:
    - ${var.public_ssh_key}
  lock_passwd: true
EOF
  ) : (count.index == 0 ? (<<-EOF
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
  ) : (<<-EOF
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
  ))

  tags = {
    Name = "c${count.index}-instance"
  }
}


resource "aws_eip_association" "eip_assoc" {
  count         = length(var.controller_name)
  instance_id   = aws_instance.instance[count.index].id
  allocation_id = data.aws_eip.eip_data[count.index].id

  depends_on = [aws_instance.instance]
}
