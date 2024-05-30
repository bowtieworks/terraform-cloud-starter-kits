output "instance_names" {
  description = "The names of the Compute instances"
  value       = [for instance in google_compute_instance.controllers : instance.name]
}
