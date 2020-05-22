variable "enable_key_rotation" {
  type        = bool
  description = "Enable annual key rotation for KMS keys"
  default     = false
}

variable "cluster_tag" {
  type        = string
  description = "Tag to be used across all resources to namespace clusters."
  default     = "default"
}
