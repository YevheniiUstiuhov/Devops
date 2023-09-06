output "instance_public_ip" {
  value = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
}

output "instance_image_id" {
  value = var.image_project
}

output "instance_type" {
  value = google_compute_instance.instance.machine_type
}

output "instance_network" {
  value = google_compute_instance.instance.network_interface[0].network
}

output "instance_subnet" {
  value = google_compute_instance.instance.network_interface[0].subnetwork
}

output "instance_zone" {
  value = google_compute_instance.instance.zone
}