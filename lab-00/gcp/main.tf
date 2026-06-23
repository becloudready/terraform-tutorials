terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Variables
variable "gcp_project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP Region"
  default     = "northamerica-central1"
}

variable "environment" {
  default = "dev"
}

# VPC Network
resource "google_compute_network" "main" {
  name                    = "vpc-${var.environment}-01"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "main" {
  name          = "subnet-${var.environment}-01"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.gcp_region
  network       = google_compute_network.main.id
}

# Firewall Rule
resource "google_compute_firewall" "main" {
  name    = "fw-${var.environment}-01"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Compute Instance
resource "google_compute_instance" "main" {
  name         = "vm-${var.environment}-01"
  machine_type = "e2-micro"
  zone         = "${var.gcp_region}-a"

  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-8-v20240604"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.main.id

    access_config {
      # Ephemeral public IP
    }
  }

  tags = ["${var.environment}", "http-server", "https-server"]

  metadata = {
    enable-oslogin = "true"
  }
}

# Output
output "gcp_instance_public_ip" {
  value       = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
  description = "Public IP address of the GCP instance"
}

output "gcp_instance_id" {
  value       = google_compute_instance.main.id
  description = "ID of the GCP instance"
}

output "gcp_instance_self_link" {
  value       = google_compute_instance.main.self_link
  description = "Self link of the GCP instance"
}
