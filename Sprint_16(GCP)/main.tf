# Provider
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  project = var.project
}

resource "google_compute_network" "network" {
  name = var.network_name
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.network.name
  region        = var.region
}

resource "google_compute_instance" "instance" {
  name         = var.instance_name
  machine_type = var.instance_type
  zone         = var.zone
  tags         = var.network_tags

  boot_disk {
    initialize_params {
      image = "projects/${var.image_project}/global/images/${var.image_family}"
    }
  }

  network_interface {
    network    = google_compute_network.network.name
    subnetwork = google_compute_subnetwork.subnet.name

    access_config {}
  }
  metadata = {
    environment = var.environment
  }
}

resource "google_compute_firewall" "firewall" {
  name    = "allow-http-https-ssh"
  network = google_compute_network.network.name

  allow {
    protocol = "tcp"
    ports    = var.allowed_ports
  }

  source_ranges = ["0.0.0.0/0"]
}
