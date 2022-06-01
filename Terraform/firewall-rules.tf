resource "google_compute_firewall" "media-wiki" {
  project     = "<REDACTED>"
  name        = "internal-wiki"
  network     = "<REDACTED>"
  description = "Creates firewall rule for internal media wiki access"
  allow {
    protocol  = "tcp"
    ports     = ["<REDACTED>"]
  }
  target_tags = ["cloud-store"]
  source_ranges = ["<REDACTED>/24"]
  depends_on = [google_compute_network.vpc_network]
}
resource "google_compute_firewall" "ssh" {
  project     = "<REDACTED>"
  name        = "internal-ssh"
  network     = "<REDACTED>"
  description = "Creates firewall rule for internal ssh access"
  allow {
    protocol  = "tcp"
    ports     = ["<REDACTED>"]
  }
  source_ranges = ["<REDACTED>/24"]
  depends_on = [google_compute_network.vpc_network]
}
resource "google_compute_firewall" "external-vpn" {
  project     = "<REDACTED>"
  name        = "external-vpn"
  network     = "<REDACTED>"
  description = "Creates firewall rule for external vpn access"
  allow {
    protocol  = "tcp"
    ports     = ["<REDACTED>"]
  }
  target_tags = ["cloud-vpn"]
  source_ranges = ["<REDACTED>/24"]
  depends_on = [google_compute_network.vpc_network]
}
resource "google_compute_firewall" "external-ssh-cloud-vpn" {
  project     = "<REDACTED>"
  name        = "external-ssh"
  network     = "<REDACTED>"
  description = "Creates firewall rule for external ssh access"
  allow {
    protocol  = "tcp"
    ports     = ["<REDACTED>"]
  }
  target_tags = ["cloud-vpn"]
  source_ranges = ["<REDACTED>/24"]
  depends_on = [google_compute_network.vpc_network]
}
