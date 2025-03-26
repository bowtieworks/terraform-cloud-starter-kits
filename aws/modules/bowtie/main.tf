terraform {
  required_providers {
    bowtie = {
      source  = "bowtieworks/bowtie"
      version = "0.6.0"
    }
  }
}

# Associate the given CIDR with the given site
resource "bowtie_site_range" "internal_resources" {
  site_id     = var.site_id
  name        = "Internal Resources"
  description = ""
  ipv4_range  = var.ipv4_range
}

# Enable support for IPv6 access From Chrome Browser
resource "bowtie_site_range" "chrome" {
  site_id     = var.site_id
  name        = "Google Chrome IPv6 Enable"
  description = ""
  ipv6_range  = "2001:4860:4860::8888"
}

# Enable support for IPv6 access From Brave Browser
resource "bowtie_site_range" "brave" {
  site_id     = var.site_id
  name        = "Brave & Other IPv6 Enable"
  description = ""
  ipv6_range  = "2001:7fd::1"
}

# Enable support for IPv6 access From Edge Browser
resource "bowtie_site_range" "edge" {
  site_id     = var.site_id
  name        = "Microsoft Edge IPv6 Enable"
  description = ""
  ipv6_range  = "2001:4860:4860::8888"
}

# Default Resources
resource "bowtie_resource" "all_ipv6" {
  count    = var.create_default_resources ? 1 : 0
  name     = "All IPv6"
  protocol = "all"
  location = {
    cidr = "::/0"
  }
  ports = {
    range = [0, 65535]
  }
}

resource "bowtie_resource" "all_ipv4" {
  count    = var.create_default_resources ? 1 : 0
  name     = "All IPv4"
  protocol = "all"
  location = {
    cidr = "0.0.0.0/0"
  }
  ports = {
    range = [0, 65535]
  }
}

# Default Resource Group
resource "bowtie_resource_group" "all_access" {
  count     = var.create_default_resources ? 1 : 0
  name      = "All Access"
  resources = [bowtie_resource.all_ipv6[0].id, bowtie_resource.all_ipv4[0].id]
  inherited = []
}

# Managed Domain
resource "bowtie_dns" "dns" {
  count = var.create_default_resources ? 1 : 0
  name  = var.dns_zone_name
  servers = [{
    addr = "1.1.1.1"
  }]

  excludes = flatten([
    for controller in var.controller_name : {
      name = "${controller}.${var.dns_zone_name}"
    }
  ])
}

# DNS Block list
resource "bowtie_dns_block_list" "swg" {
  count    = var.create_default_resources ? 1 : 0
  name     = "Threat Intelligence Feed"
  upstream = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/domains/tif.txt"
  override_to_allow = [
    "permitted.example.com"
  ]
}
