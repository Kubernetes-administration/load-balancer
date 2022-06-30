variable "project" {
  type        = string
  description = "The project scope"
  default     = "gcp-terraform-env"
}

variable "region" {
  type        = string
  description = "The region"
  default     = "us-west1"
}

variable "zone" {
  type        = string
  description = "zone"
  default     = "us-west1-a"
}