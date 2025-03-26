output "site_ranges" {
  description = "The Bowtie site ranges created"
  value = {
    internal = bowtie_site_range.internal_resources.id
    chrome   = bowtie_site_range.chrome.id
    brave    = bowtie_site_range.brave.id
    edge     = bowtie_site_range.edge.id
  }
}

output "default_resources" {
  description = "The default resources created (if enabled)"
  value = var.create_default_resources ? {
    ipv4 = bowtie_resource.all_ipv4[0].id
    ipv6 = bowtie_resource.all_ipv6[0].id
  } : null
}

output "resource_groups" {
  description = "The resource groups created (if enabled)"
  value = var.create_default_resources ? {
    all_access = bowtie_resource_group.all_access[0].id
  } : null
}

output "dns_management" {
  description = "The DNS management configuration (if enabled)"
  value = var.create_default_resources ? {
    dns       = bowtie_dns.dns[0].id
    blocklist = bowtie_dns_block_list.swg[0].id
  } : null
}
