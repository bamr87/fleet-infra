terraform {
  required_version = ">= 1.6"
}

variable "cluster_name" {
  description = "Name of the fleet k3s cluster"
  type        = string
  default     = "fleet"
}

locals {
  namespaces = ["fleet-system", "fleet-apps"]
}

output "cluster_name" {
  value = var.cluster_name
}

output "namespaces" {
  value = local.namespaces
}
