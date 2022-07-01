locals {
  health_check_port = var.health_check["port"]
}

resource "google_compute_instance_group" "instance_group" {
  name    = "${var.project}-instance-group"
  zone    = var.zone
  project = var.project

  instances = [
    data.google_compute_instance.compute_instance.self_link,
  ]

  named_port {
    name = lower(var.protocol)
    port = var.service_port
  }
}

data "google_compute_instance" "compute_instance" {
  project = var.project
  name    = var.compute_instance
  zone    = var.zone
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name        = "${var.project}-forwarding-rule"
  project     = var.project
  ip_protocol = var.ip_protocol
  port_range  = var.service_port
  target      = google_compute_target_http_proxy.target_http_proxy.id
  labels      = var.labels
}

resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "${var.project}-target-http-proxy"
  project = var.project
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "${var.project}-url-map"
  project         = var.project
  default_service = google_compute_backend_service.backend_service.id
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "${var.project}-backend-service"
  protocol              = var.protocol
  port_name             = lower(var.protocol)
  load_balancing_scheme = var.load_balancing_scheme
  enable_cdn            = var.enable_cdn
  project               = var.project
  health_checks         = var.disable_health_check ? [] : [google_compute_health_check.health_check.0.self_link]
  backend {
    group                 = google_compute_instance_group.instance_group.id
    balancing_mode        = var.balancing_mode
    max_rate_per_instance = var.max_rate_per_instance
  }
}

resource "google_compute_health_check" "health_check" {
  count              = var.disable_health_check ? 0 : 1
  project            = var.project
  name               = "${var.project}-health-check"
  check_interval_sec = var.health_check["check_interval_sec"]
  healthy_threshold  = var.health_check["healthy_threshold"]
  timeout_sec        = var.health_check["timeout_sec"]
  http_health_check {
    port         = local.health_check_port == null ? var.service_port : local.health_check_port
    request_path = var.health_check["request_path"]
    host         = var.health_check["host"]
  }
}

resource "google_compute_firewall" "load_balancer_firewall" {
  count         = var.disable_health_check ? 0 : 1
  project       = var.project
  name          = "${var.project}-firewall"
  network       = var.network
  source_ranges = var.allowed_ips
  allow {
    ports    = [local.health_check_port == null ? 80 : local.health_check_port]
    protocol = lower(var.ip_protocol)
  }
}
