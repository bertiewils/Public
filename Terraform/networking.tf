//For static external IP's
resource "google_compute_address" "static" {
  name = "ipv4-address"
}

//Create the VPC
resource "google_compute_network" "vpc_network" {
  project                 = "gcloud-<REDACTED>"
  name                    = "<REDACTED>"
  auto_create_subnetworks = false
  mtu                     = 1500
}

//Create main network for VPC
resource "google_compute_subnetwork" "main_network" {
  name          = "main"
  ip_cidr_range = "<REDACTED>/24"
  region        = "europe-west2"
  network       = google_compute_network.vpc_network.id
}

//Reserve internal static IP's
resource "google_compute_address" "cloud_vpn" {
  subnetwork = "main"
  name = "cloud-vpn"
  address_type  = "INTERNAL"
  address       = "<REDACTED>"
  depends_on = [google_compute_subnetwork.main_network]
}
resource "google_compute_address" "cloud_store" {
  subnetwork = "main"
  name = "cloud-store"
  address_type  = "INTERNAL"
  address       = "<REDACTED>"
  depends_on = [google_compute_subnetwork.main_network]
}

//Create the cloud router
resource "google_compute_router" "router" {
  name    = "cloud-router"
  #network = google_compute_network.router.name
  network = google_compute_network.vpc_network.name
  bgp {
    asn               = <REDACTED>
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
  }
}

//Create cloud NAT
resource "google_compute_router_nat" "nat" {
  name                               = "cloud-router-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

//Create VPC routes
resource "google_compute_route" "vpn-tunnel-route" {
  name        = "vpn-tunnel-route"
  dest_range  = "<REDACTED>/24"
  network     = google_compute_network.vpc_network.name
  next_hop_ip = "<REDACTED>"
  priority    = 1
  depends_on = [google_compute_subnetwork.main_network]
}
