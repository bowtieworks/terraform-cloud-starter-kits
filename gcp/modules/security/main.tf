resource "google_compute_firewall" "allow_ingress" {
  name          = "allow-ingress"
  network       = var.vpc_name
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22", "443"]
  }

  allow {
    protocol = "udp"
    ports    = ["443"]
  }

  allow {
    protocol = "icmp"
  }

  target_tags = ["bowtie"]
}

resource "google_compute_firewall" "allow_egress" {
  name      = "allow-egress"
  network   = var.vpc_name
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  allow {
    protocol = "udp"
    ports    = ["53", "443"]
  }

  allow {
    protocol = "icmp"
  }

  target_tags = ["bowtie"]
}
