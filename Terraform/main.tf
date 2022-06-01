terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

// Define Libvirt provider
provider "libvirt" {
  uri = "qemu+ssh://<REDACTED>@<REDACTED>:<REDACTED>/system?keyfile=/.ssh/<REDACTED>"
}

// Define GCP provider
provider "google" {
 credentials = file("/Terraform/Keys/<REDACTED>")
 project     = "gcloud-<REDACTED>"
 region      = "europe-west2"
}

// Add project wide SSH key
resource "google_compute_project_metadata" "my_ssh_key" {
  metadata = {
    ssh-keys = <<EOF
      <REDACTED>:ssh-<REDACTED>
    EOF
  }
}

