resource "google_compute_address" "default" {
  count        = length(var.external_ips) == 0 ? length(var.controller_name) : 0
  name         = "controller-${count.index}"
  region       = var.subnet_regions[count.index]
  network_tier = "STANDARD"
}

resource "google_compute_instance" "controllers" {
  count        = length(var.controller_name)
  name         = "controller-${count.index}"
  machine_type = var.machine_type
  zone         = length(var.subnet_regions) > 1 ? "${var.subnet_regions[count.index]}-c" : "${var.subnet_regions[0]}-c"
  
  network_interface {
    network    = var.vpc
    subnetwork = length(var.subnets) > 1 ? var.subnets[count.index] : var.subnets[0]

    access_config {
      nat_ip       = length(var.external_ips) > 0 ? var.external_ips[count.index] : length(google_compute_address.default) > count.index ? google_compute_address.default[count.index].address : null
      network_tier = "STANDARD"
    }
  }

  metadata = {
    user-data = count.index == 0 ? (
      <<-EOF
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
      ) : (
      <<-EOF
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
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }

  tags = ["bowtie"]

  boot_disk {
    initialize_params {
      image = "projects/bowtie-works/global/images/bowtie-controller-gce-${var.image_ver}"
      size  = 10
      type  = "pd-balanced"
    }
  }
}
