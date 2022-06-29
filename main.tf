locals {
  health_check_port = var.health_check["port"]
}

resource "google_compute_instance_group" "default" {
  name    = "${var.project}-instance-group"
  zone    = "${var.region}-a"
  project = var.project

  instances = [
    data.google_compute_instance.compute_instance.self_link,
  ]

  named_port {
    name = "http"
    port = "80"
  }
}


data "google_compute_instance" "compute_instance" {
  project = var.project
  name    = var.compute_instance
  zone    = var.zone
}

resource "google_compute_firewall" "default-hc-fw" {
  name     = "${var.project}-load-balancer"
  project  = var.project
  network  = "default"
  priority = 1000
  source_ranges = [
    "209.85.152.0/22",
    "209.85.204.0/22",
    "35.191.0.0/16",
  ]

  allow {
    ports = [
      "80",
    ]
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "default-lb-fw" {
  project  = var.project
  name     = "${var.project}-load-balancer-vm-service"
  network  = "default"
  priority = 1000
  source_ranges = [
    "0.0.0.0/0",
  ]

  allow {
    ports = [
      "80",
    ]
    protocol = "tcp"
  }
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "${var.project}-forwarding-rule"
  project               = var.project
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "${var.project}-target-http-proxy"
  project = var.project
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "${var.project}-url-map"
  project         = var.project
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name                  = "${var.project}-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  enable_cdn            = true
  project               = var.project
  health_checks         = [google_compute_health_check.default.id]
  backend {
    group                 = google_compute_instance_group.default.id
    balancing_mode        = "UTILIZATION"
    max_rate_per_instance = "80"
  }
}

resource "google_compute_firewall" "default" {
  name          = "${var.project}-fw-allow-hc"
  project       = var.project
  network       = "default"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}
resource "google_compute_health_check" "default" {
  project            = var.project
  name               = "${var.project}-health-check"
  check_interval_sec = 1
  timeout_sec        = 1
  http_health_check {
    port = "80"
  }
}
