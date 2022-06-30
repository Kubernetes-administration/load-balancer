project         = "gcp-terraform-env"
http_named_port = "http"
zone            = "us-west1-a"
network         = "default"
service_port    = 80
ports           = ["80"]
protocol        = "tcp"
source_ranges = [
  "209.85.152.0/22",
  "209.85.204.0/22",
  "35.191.0.0/16",
]
ip_protocol              = "TCP"
load_balancing_scheme    = "EXTERNAL"
backend_service_protocol = "HTTP"
port_name                = "http"
enable_cdn               = true
balancing_mode           = "UTILIZATION"
max_rate_per_instance    = "80"
target_tags              = ["configured-http-server"]
allowed_ips = [
  "0.0.0.0/0",
]
port_range = "80"
region     = "us-west1"