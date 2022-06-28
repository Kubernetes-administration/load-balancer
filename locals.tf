locals {
  health_check = {
    check_interval_sec  = 1
    healthy_threshold   = 4
    timeout_sec         = 1
    unhealthy_threshold = 5
    port                = 8080
    request_path        = "/mypath"
    host                = "1.2.3.4"
  }
}
