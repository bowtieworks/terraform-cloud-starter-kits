resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  count                   = var.create_vpc ? 1 : 0
}

data "google_compute_network" "vpc_data" {
  name = var.create_vpc ? google_compute_network.vpc[0].name : var.vpc_name
}

resource "google_compute_subnetwork" "subnets" {
  count         = var.create_subnets ? length(var.subnet_names) : 0
  name          = var.subnet_names[count.index]
  ip_cidr_range = var.subnet_cidrs[count.index]
  region        = var.subnet_regions[count.index]
  network       = data.google_compute_network.vpc_data.self_link
}

data "google_compute_subnetwork" "subnets_data" {
  count  = var.create_subnets ? 0 : length(var.subnet_names)
  name   = var.subnet_names[count.index]
  region = var.subnet_regions[count.index]
}
