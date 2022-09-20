variable "enable_key_rotation" {
  type        = bool
  description = "Enable annual key rotation for KMS keys"
  default     = false
}

variable "enable_awssm" {
  type        = bool
  description = "Enable AWS SM Secrets"
  default     = false
}

variable "cluster_tag" {
  type        = string
  description = "Tag to be used across all resources to namespace clusters."
  default     = "default"
}

variable "machine_roles" {
  type        = map(set(string))
  description = "Map of role name to role policy identifiers"
  default     = {}
}
