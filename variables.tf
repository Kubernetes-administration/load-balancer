
variable "health_check" {
  description = "Health check to determine whether instances are responsive and able to do work"
  type = object({
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    port                = number
    request_path        = string
    host                = string
  })
  default = {
    check_interval_sec  = null
    healthy_threshold   = null
    timeout_sec         = null
    unhealthy_threshold = null
    port                = null
    request_path        = null
    host                = null
  }
}

variable "disable_health_check" {
  type        = bool
  description = "Disables the health check on the target pool."
  default     = false
}

variable "service_port" {
  type        = number
  description = "TCP port your service is listening on."
}

variable "project" {
  type        = string
  description = "The project to deploy to, if not set the default provider project is used."
}

variable "region" {
  type        = string
  description = "Region used for GCP resources."
}

variable "zone" {
  type        = string
  description = "zone"
}

variable "network" {
  type        = string
  description = "value"
}

variable "ip_protocol" {
  type        = string
  description = "value"
}

variable "enable_cdn" {
  type        = bool
  description = "value"
}

variable "balancing_mode" {
  type        = string
  description = "value"
}

variable "max_rate_per_instance" {
  type        = string
  description = "value"
}

variable "target_tags" {
  type        = list(string)
  description = "value"
}

variable "allowed_ips" {
  type        = list(any)
  description = "value"
}

variable "port_range" {
  type        = string
  description = "value"
}

variable "protocol" {
  type        = string
  description = "value"
}

variable "load_balancing_scheme" {
  type        = string
  description = "value"
}

variable "labels" {
  description = "The labels to attach to resources created by this module."
  default     = {}
  type        = map(string)
}

variable "ip_address" {
  description = "IP address of the external load balancer, if empty one will be assigned."
  default     = null
}

variable "compute_instance" {
  type        = string
  description = "Exiting instance"
}

variable "port_name" {
  type        = string
  description = "value"
}