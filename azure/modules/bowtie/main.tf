terraform {
  required_providers {
    bowtie = {
      source  = "bowtieworks/bowtie"
      version = "0.6.0"
    }
    checkmate = {
      source  = "tetratelabs/checkmate"
      version = "1.5.0"
    }
  }
}

resource "null_resource" "dependency_waiter" {
  count = length(var.instance_names)
  triggers = {
    name = var.instance_names[count.index]
  }
}

resource "checkmate_http_health" "healthcheck" {
  # This is the url of the endpoint we want to check
  url = "https://${var.controller_name[0]}.${var.dns_zone_name}/-net/api/v0/ok"

  # Will perform an HTTP GET request
  method = "GET"

  # The overall test should not take longer than 5 minutes
  timeout = 1000 * 60 * 5 # ms, seconds, minutes

  # Wait 1 seconds between attempts
  interval = 1000

  # Expect a status 200 OK
  status_code = 200

  # We want 2 successes in a row
  consecutive_successes = 3

  # Wait until compute instances are created before healthchecking
  depends_on = [null_resource.dependency_waiter]
}

# Set the provider details
provider "bowtie" {
  host     = "https://${var.controller_name[0]}.${var.dns_zone_name}"
  username = var.bowtie_username
  password = var.bowtie_password
}

# Associate the given CIDR with the given site
resource "bowtie_site_range" "internal_resources" {
  depends_on  = [checkmate_http_health.healthcheck]
  site_id     = var.site_id
  name        = "Internal Resources"
  description = ""
  ipv4_range  = var.ipv4_range
}

# Enable support for IPv6 access From Chrome Browser
resource "bowtie_site_range" "chrome" {
  depends_on  = [checkmate_http_health.healthcheck]
  site_id     = var.site_id
  name        = "Google Chrome IPv6 Enable"
  description = ""
  ipv6_range  = "2001:4860:4860::8888"
}

# Enable support for IPv6 access From Brave Browser
resource "bowtie_site_range" "brave" {
  depends_on  = [checkmate_http_health.healthcheck]
  site_id     = var.site_id
  name        = "Brave & Other IPv6 Enable"
  description = ""
  ipv6_range  = "2001:7fd::1"
}

# Enable support for IPv6 access From Edge Browser
resource "bowtie_site_range" "edge" {
  depends_on  = [checkmate_http_health.healthcheck]
  site_id     = var.site_id
  name        = "Microsoft Edge IPv6 Enable"
  description = ""
  ipv6_range  = "2001:4860:4860::8888"
}

# Default Resources
resource "bowtie_resource" "all_ipv6" {
  depends_on = [checkmate_http_health.healthcheck]
  name       = "All IPv6"
  protocol   = "all"
  location = {
    cidr = "::/0"
  }
  ports = {
    range = [0, 65535]
  }
}

resource "bowtie_resource" "all_ipv4" {
  depends_on = [checkmate_http_health.healthcheck]
  name       = "All IPv4"
  protocol   = "all"
  location = {
    cidr = "0.0.0.0/0"
  }
  ports = {
    range = [0, 65535]
  }
}

# Default Resource Group
resource "bowtie_resource_group" "all_access" {
  depends_on = [checkmate_http_health.healthcheck]
  name       = "All Access"
  resources  = [bowtie_resource.all_ipv6.id, bowtie_resource.all_ipv4.id]
  inherited  = []
}
