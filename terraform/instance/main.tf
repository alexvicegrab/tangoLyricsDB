// Configure the Google Cloud provider
provider "google" {
  credentials = "${file("../../../GCP_TangoTranslation_creds.json")}"
  project     = "${var.project}"
  region      = "us-west1"  # Available with Always Free
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "vm" {
  name         = "${var.project}-vm"
  machine_type = "${var.vm_size}"
  zone         = "${var.location}"

  boot_disk {
    initialize_params {
      image = "ubuntu-1604-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }

  metadata {
    sshKeys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
