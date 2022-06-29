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

resource "google_compute_global_forwarding_rule" "default" {
  name    = "l7-xlb-forwarding-rule"
  project = "gcp-terraform-env"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
}

resource "google_compute_target_http_proxy" "default" {
  name    = "l7-xlb-target-http-proxy"
  project = "gcp-terraform-env"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name    = "l7-xlb-url-map"
  project = "gcp-terraform-env"
  default_service = google_compute_backend_service.default.id
}

resource "google_compute_backend_service" "default" {
  name = "l7-xlb-backend-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 10
  enable_cdn            = true
  project               = "gcp-terraform-env"
  health_checks         = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_instance_group.default.id
    balancing_mode  = "UTILIZATION"
    max_rate_per_instance = "80"
  }
}

resource "google_compute_instance_group" "default" {
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


resource "google_compute_firewall" "default" {
  name          = "l7-xlb-fw-allow-hc"
  project       = "gcp-terraform-env"
  network       = "default"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  allow {
    protocol = "tcp"
  }
  target_tags = ["allow-health-check"]
}
resource "google_compute_health_check" "default" {
  project            = "gcp-terraform-env"
  name               = "rbs-health-check"
  check_interval_sec = 1
  timeout_sec        = 1
  http_health_check {
    port = "80"
  }
}
