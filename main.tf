# # google_compute_router.router will be created
# resource "google_compute_router" "router" {
#   name    = "load-balancer-module-router"
#   network = "default"
#   region  = "us-central1"
#   project = "gcp-terraform-env"
# }

# # google_service_account.instance-group will be created
# resource "google_service_account" "instance_group" {
#   account_id = "instance-group"
#   disabled   = false
#   project    = "gcp-terraform-env"
# }

# # module.cloud_nat.google_compute_router_nat.main will be created
# resource "google_compute_router_nat" "main" {
#   enable_endpoint_independent_mapping = true
#   icmp_idle_timeout_sec               = 30
#   min_ports_per_vm                    = 64
#   name                                = "load-balancer-module-nat"
#   nat_ip_allocate_option              = "AUTO_ONLY"
#   project                             = "gcp-terraform-env"
#   region                              = "us-central1"
#   router                              = "load-balancer-module-router"
#   source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"
#   tcp_established_idle_timeout_sec    = 1200
#   tcp_transitory_idle_timeout_sec     = 30
#   udp_idle_timeout_sec                = 30
# }

# # module.cloud_nat.random_string.name_suffix will be created
# resource "random_string" "name_suffix" {
#   length      = 6
#   lower       = true
#   min_lower   = 0
#   min_numeric = 0
#   min_special = 0
#   min_upper   = 0
#   #   number      = true
#   numeric = true
#   special = false
#   upper   = false
# }

# data "template_file" "instance_startup_script" {
#   template = file("${path.module}/templates/gceme.sh.tpl")

#   vars = {
#     PROXY_PATH = ""
#   }
# }

# # module.instance_template.google_compute_instance_template.tpl will be created
# resource "google_compute_instance_template" "tpl" {
#   can_ip_forward          = false
#   machine_type            = "n1-standard-1"
#   metadata_startup_script = data.template_file.instance_startup_script.rendered
#   name_prefix             = "default-instance-template-"
#   project                 = "gcp-terraform-env"

#   disk {
#     auto_delete  = true
#     boot         = true
#     disk_size_gb = 100
#     disk_type    = "pd-standard"
#     source_image = "https://www.googleapis.com/compute/v1/projects/debian-cloud/global/images/debian-9-stretch-v20220621"
#     type         = "PERSISTENT"
#   }

#   network_interface {
#     network = "default"
#   }

#   scheduling {
#     automatic_restart = true
#     preemptible       = false
#   }

#   service_account {
#     scopes = [
#       "https://www.googleapis.com/auth/cloud-platform",
#     ]
#   }
# }

# # resource "google_compute_firewall" "default-hc-fw" {
# #   name     = "basic-load-balancer-custom-hc-hc"
# #   network  = "default"
# #   priority = 1000
# #   source_ranges = [
# #     "209.85.152.0/22",
# #     "209.85.204.0/22",
# #     "35.191.0.0/16",
# #   ]

# #   allow {
# #     ports = [
# #       "8080",
# #     ]
# #     protocol = "tcp"
# #   }
# # }

# # module.load_balancer_custom_hc.google_compute_firewall.default-hc-fw[0] will be created
# # resource "google_compute_firewall" "default-lb-fw" {
# #   name     = "basic-load-balancer-custom-hc-vm-service"
# #   network  = "default"
# #   priority = 1000
# #   source_ranges = [
# #     "0.0.0.0/0",
# #   ]

# #   allow {
# #     ports = [
# #       "8080",
# #     ]
# #     protocol = "tcp"
# #   }
# # }

# # module.load_balancer_custom_hc.google_compute_firewall.default-lb-fw will be created
# # resource "google_compute_firewall" "default-lb-fw" {
# #   name     = "basic-load-balancer-custom-hc-vm-service"
# #   network  = "default"
# #   priority = 1000
# #   source_ranges = [
# #     "0.0.0.0/0",
# #   ]

# #   allow {
# #     ports = [
# #       "8080",
# #     ]
# #     protocol = "tcp"
# #   }
# # }

# # module.load_balancer_custom_hc.google_compute_forwarding_rule.default will be created
# # resource "google_compute_forwarding_rule" "default" {
# #   ip_protocol           = "TCP"
# #   load_balancing_scheme = "EXTERNAL"
# #   name                  = "basic-load-balancer-custom-hc"
# #   port_range            = "8080"
# #   region                = "us-central1"
# # }

# # module.load_balancer_custom_hc.google_compute_http_health_check.default[0] will be created
# # resource "google_compute_http_health_check" "default" {
# #   check_interval_sec  = 1
# #   healthy_threshold   = 4
# #   host                = "1.2.3.4"
# #   name                = "basic-load-balancer-custom-hc-hc"
# #   port                = 8080
# #   request_path        = "/mypath"
# #   timeout_sec         = 1
# #   unhealthy_threshold = 5
# # }

# # module.load_balancer_custom_hc.google_compute_target_pool.default will be created
# # resource "google_compute_target_pool" "default" {
# #   name             = "basic-load-balancer-custom-hc"
# #   region           = "us-central1"
# #   session_affinity = "NONE"
# # }

# # module.load_balancer_default.google_compute_firewall.default-hc-fw[0] will be created
# resource "google_compute_firewall" "default-hc-fw" {
#   name     = "basic-load-balancer-default-hc"
#   project  = "gcp-terraform-env"
#   network  = "default"
#   priority = 1000
#   source_ranges = [
#     "209.85.152.0/22",
#     "209.85.204.0/22",
#     "35.191.0.0/16",
#   ]

#   allow {
#     ports = [
#       "80",
#     ]
#     protocol = "tcp"
#   }
# }




# # module.load_balancer_default.google_compute_firewall.default-lb-fw will be created
# resource "google_compute_firewall" "default-lb-fw" {
#   project  = "gcp-terraform-env"
#   name     = "basic-load-balancer-default-vm-service"
#   network  = "default"
#   priority = 1000
#   source_ranges = [
#     "0.0.0.0/0",
#   ]

#   allow {
#     ports = [
#       "80",
#     ]
#     protocol = "tcp"
#   }
# }

# # module.load_balancer_default.google_compute_forwarding_rule.default will be created
# resource "google_compute_forwarding_rule" "default" {
#   #   provider              = google-beta
#   project               = "gcp-terraform-env"
#   ip_protocol           = "TCP"
#   load_balancing_scheme = "EXTERNAL"
#   name                  = "basic-load-balancer-default"
#   port_range            = "80"
#   region                = "us-central1"
#   target                = google_compute_target_pool.default.self_link
# }

# # module.load_balancer_default.google_compute_http_health_check.default[0] will be created
# resource "google_compute_http_health_check" "default" {
#   project             = "gcp-terraform-env"
#   check_interval_sec  = 5
#   healthy_threshold   = 2
#   name                = "basic-load-balancer-default-hc"
#   port                = 80
#   request_path        = "/"
#   timeout_sec         = 5
#   unhealthy_threshold = 2
# }

# # module.load_balancer_default.google_compute_target_pool.default will be created
# resource "google_compute_target_pool" "default" {
#   project          = "gcp-terraform-env"
#   name             = "basic-load-balancer-default"
#   region           = "us-central1"
#   session_affinity = "NONE"
#   instances        = []
# }

# # module.load_balancer_no_hc.google_compute_firewall.default-lb-fw will be created
# # resource "google_compute_firewall" "default-lb-fw" {
# #   name     = "basic-load-balancer-no-hc-vm-service"
# #   network  = "default"
# #   priority = 1000
# #   source_ranges = [
# #     "0.0.0.0/0",
# #   ]

# #   allow {
# #     ports = [
# #       "80",
# #     ]
# #     protocol = "tcp"
# #   }
# # }

# # module.load_balancer_no_hc.google_compute_forwarding_rule.default will be created
# # resource "google_compute_forwarding_rule" "default" {
# #   ip_protocol           = "TCP"
# #   load_balancing_scheme = "EXTERNAL"
# #   name                  = "basic-load-balancer-no-hc"
# #   port_range            = "80"
# #   region                = "us-central1"
# # }

# # module.load_balancer_no_hc.google_compute_target_pool.default will be created
# # resource "google_compute_target_pool" "default" {
# #   health_checks    = []
# #   name             = "basic-load-balancer-no-hc"
# #   region           = "us-central1"
# #   session_affinity = "NONE"
# # }

# # module.managed_instance_group.google_compute_region_instance_group_manager.mig will be created
# resource "google_compute_region_instance_group_manager" "mig" {
#   base_instance_name = "mig-simple"
#   project            = "gcp-terraform-env"
#   distribution_policy_zones = [
#     "us-central1-a",
#     "us-central1-b",
#     "us-central1-c",
#     "us-central1-f",
#   ]
#   name                      = "mig-simple-mig"
#   region                    = "us-central1"
#   target_size               = 1
#   wait_for_instances        = false
#   wait_for_instances_status = "STABLE"

#   named_port {
#     name = "http"
#     port = 80
#   }

#   timeouts {
#     create = "5m"
#     delete = "15m"
#     update = "5m"
#   }

#   #   + update_policy {
#   #       + instance_redistribution_type = (known after apply)
#   #       + max_surge_fixed              = (known after apply)
#   #       + max_surge_percent            = (known after apply)
#   #       + max_unavailable_fixed        = (known after apply)
#   #       + max_unavailable_percent      = (known after apply)
#   #       + min_ready_sec                = (known after apply)
#   #       + minimal_action               = (known after apply)
#   #       + replacement_method           = (known after apply)
#   #       + type                         = (known after apply)
#   #     }

#   version {
#     name              = "mig-simple-mig-version-0"
#     instance_template = google_compute_instance_template.tpl.id
#   }
# }