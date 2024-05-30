output "vpc_id" {
  value = data.google_compute_network.vpc_data.self_link
}

output "subnet_ids" {
  value = var.create_subnets ? [for s in google_compute_subnetwork.subnets : s.self_link] : [for s in data.google_compute_subnetwork.subnets_data : s.self_link]
}

output "subnet_regions" {
  value = var.create_subnets ? [for s in google_compute_subnetwork.subnets : s.region] : [for s in data.google_compute_subnetwork.subnets_data : s.region]
}
