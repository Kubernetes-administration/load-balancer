project               = "gcp-terraform-env"
zone                  = "us-west1-a"
network               = "default"
service_port          = 80
ip_protocol           = "TCP"
load_balancing_scheme = "EXTERNAL"
protocol              = "HTTP"
port_name             = "http"
enable_cdn            = true
balancing_mode        = "UTILIZATION"
max_rate_per_instance = "80"
target_tags           = ["configured-http-server"]
allowed_ips = [
  "0.0.0.0/0",
]
port_range = "80"
region     = "us-west1"