// Compute instances
resource "google_compute_instance" "cloud-vpn" {
 name = "cloud-vpn"
 machine_type = "e2-small"
 zone         = "europe-west2-c"
 can_ip_forward = true
 tags = ["cloud-vpn"]
 boot_disk {
   initialize_params {
     image = "ubuntu-2004-focal-v20220308"
   }
 }
 metadata = {ssh-keys = "<REDACTED>:ssh-<REDACTED>"
 }
//Create connection parameters, SSH, run the commands
 connection {
    type     = "ssh"
    user     = "<REDACTED>"
    private_key = "${file("./<REDACTED>")}" 
    host     = self.network_interface[0].access_config[0].nat_ip
  }
  provisioner "file" {
    source      = "/Automation-files/default-repos.list"
    destination = "/etc/apt/sources.list.d/default-ubuntu-repos.list"
  }
  provisioner "remote-exec" {
    inline = ["sudo apt-get update && sudo apt-get install wireguard -y"]
  }
  provisioner "file" {
    source      = "/Automation-files/vpn/wireguard/"
    destination = "/etc/wireguard/"
  }
  provisioner "remote-exec" {
    inline = ["sudo systemctl enable wg-quick@wg0 && sudo wg-quick up wg0 && sudo wg set wg0 peer <REDACTED> allowed-ips <REDACTED> && sudo wg set wg0 peer <REDACTED> allowed-ips <REDACTED> && wg-quick save wg0 && wg-quick down wg0 && wg-quick up wg0 && rm -rf /root/.ssh"]
  }
  network_interface {
    subnetwork_project ="gcloud-<REDACTED>"
    subnetwork = "main"
    network = "<REDACTED>"
    network_ip = google_compute_address.cloud_vpn.address
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}

resource "google_compute_instance" "cloud-store" {
 name = "cloud-store"
 machine_type = "e2-small"
 zone         = "europe-west2-c"
 tags = ["cloud-store"]
 boot_disk {
   initialize_params {
     image = "ubuntu-2004-focal-v20220308"
   }
 }
 network_interface {
   subnetwork_project ="gcloud-342810"
   subnetwork = "main"
   network = "<REDACTED>"
   network_ip = google_compute_address.cloud_store.address
 }
}

resource "null_resource" "rm-known_hosts" {
 provisioner "local-exec" {
   command = "rm -f /.ssh/known_hosts"
 }
}

resource "null_resource" "ansible-cloud-vpn" { 
 provisioner "local-exec" {
   command = "cd Ansible && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook /Ansible/playbooks/cloud-vpn.yml"
 }
 depends_on = [google_compute_instance.cloud-vpn]
}

resource "null_resource" "ansible-cloud-store" {
 provisioner "local-exec" {
   command = "sleep 90s && cd /Ansible && ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook /Ansible/playbooks/cloud-store.yml"
 }
 depends_on = [google_compute_instance.cloud-vpn, google_compute_instance.cloud-store, null_resource.ansible-cloud-vpn]
}

output "VPN_IP" {
  value = google_compute_instance.cloud-vpn.network_interface[0].access_config[0].nat_ip
}
