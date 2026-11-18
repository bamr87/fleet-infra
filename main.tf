terraform {
  required_version = ">= 1.6"
}

variable "cluster_name" {
  description = "Name of the fleet k3s cluster: a lowercase RFC 1123 label of at most 63 characters"
  type        = string
  default     = "fleet"

  validation {
    condition     = length(var.cluster_name) <= 63 && can(regex("^[a-z0-9](?:[-a-z0-9]*[a-z0-9])?$", var.cluster_name))
    error_message = "The cluster_name must be a lowercase RFC 1123 label of at most 63 characters: a-z, 0-9 and '-', starting and ending with a letter or digit."
  }
}

# The source of truth for the fleet's namespace names. The `namespace` value in
# charts/fleet-base/values.yaml must be one of them: tests/main.tftest.hcl fails
# when it is not. Creating these namespaces on a cluster waits on FINFRA-003/004.
locals {
  namespaces = ["fleet-system", "fleet-apps"]
}

output "cluster_name" {
  description = "Name of the fleet k3s cluster (the validated cluster_name variable)"
  value       = var.cluster_name
}

output "namespaces" {
  description = "The fleet's namespace names, the source of truth for the chart's namespace value"
  value       = local.namespaces
}
