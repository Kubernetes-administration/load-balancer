project               = "gcp-terraform-env"
zone                  = "us-west1-a"
region                = "us-west1"
network               = "default"
service_port          = 80
ip_protocol           = "TCP"
load_balancing_scheme = "EXTERNAL"
protocol              = "HTTP"
enable_cdn            = true
balancing_mode        = "UTILIZATION"
max_rate_per_instance = "80"
target_tags           = ["configured-http-server"]
allowed_ips = [
  "0.0.0.0/0",
]
compute_instance = "default-instance"