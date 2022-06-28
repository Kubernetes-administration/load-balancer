
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
  default = 80
}