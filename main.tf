locals {
  health_check_port = var.health_check["port"]
}

resource "google_compute_router" "router" {
  name    = "load-balancer-module-router"
  network = "default"
  region  = "us-central1"
  project = "gcp-terraform-env"
}

resource "google_service_account" "instance_group" {
  account_id = "instance-group"
  disabled   = false
  project    = "gcp-terraform-env"
}

resource "google_compute_router_nat" "main" {
  enable_endpoint_independent_mapping = true
  icmp_idle_timeout_sec               = 30
  min_ports_per_vm                    = 64
  name                                = "load-balancer-module-nat"
  nat_ip_allocate_option              = "AUTO_ONLY"
  project                             = "gcp-terraform-env"
  region                              = "us-central1"
  router                              = "load-balancer-module-router"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  tcp_established_idle_timeout_sec    = 1200
  tcp_transitory_idle_timeout_sec     = 30
  udp_idle_timeout_sec                = 30
}


data "template_file" "instance_startup_script" {
  template = file("${path.module}/templates/hello.sh.tpl")

  vars = {
    PROXY_PATH = ""
  }
}

resource "google_compute_instance" "default" {
  project                 = "gcp-terraform-env"
  machine_type            = "n1-standard-1"
  name                    = "default-instance"
  zone                    = "us-central1-a"
  metadata_startup_script = data.template_file.instance_startup_script.rendered

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }
  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}

resource "google_compute_firewall" "default-hc-fw" {
  name     = "basic-load-balancer-default-hc"
  project  = "gcp-terraform-env"
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
  project  = "gcp-terraform-env"
  name     = "basic-load-balancer-default-vm-service"
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

resource "google_compute_forwarding_rule" "default" {
  project               = "gcp-terraform-env"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  name                  = "basic-load-balancer-default"
  port_range            = "80"
  region                = "us-central1"
  target                = google_compute_target_pool.default.self_link
}

resource "google_compute_target_pool" "default" {
  project          = "gcp-terraform-env"
  name             = "basic-load-balancer-default"
  region           = "us-central1"
  session_affinity = "NONE"
  instances        = [google_compute_instance.default.self_link]

  health_checks = var.disable_health_check ? [] : [google_compute_http_health_check.default.0.self_link]
}

resource "google_compute_http_health_check" "default" {
  count   = var.disable_health_check ? 0 : 1
  project = "gcp-terraform-env"
  name    = "basic-load-balancer-default-hc"

  check_interval_sec  = var.health_check["check_interval_sec"]
  healthy_threshold   = var.health_check["healthy_threshold"]
  timeout_sec         = var.health_check["timeout_sec"]
  unhealthy_threshold = var.health_check["unhealthy_threshold"]

  port         = local.health_check_port == null ? var.service_port : local.health_check_port
  request_path = var.health_check["request_path"]
  host         = var.health_check["host"]
}

resource "google_compute_instance_group" "webservers" {
  name        = "terraform-webservers"
  description = "Terraform test instance group"
  zone        = "us-central1-a"
  project     = "gcp-terraform-env"

  instances = [
    google_compute_instance.default.id,
  ]

  named_port {
    name = "http"
    port = "80"
  }
}