output "backend_service" {
  description = "The `self_link` to the backend service resource created."
  value       = google_compute_backend_service.backend_service.self_link
}

output "external_ip" {
  description = "The external ip address of the forwarding rule."
  value       = google_compute_global_forwarding_rule.global_forwarding_rule.ip_address
}