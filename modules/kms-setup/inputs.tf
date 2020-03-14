variable "enable_key_rotation" {
  type        = bool
  description = "Automatically rotate the KMS master key annualy"
  default     = false
}

variable "additional_policies" {
  type        = list(string)
  description = "Additional policy ARNs to attach to the role"
  default     = []
}
