variable "base_path" {
  type        = string
  description = "Path to write files to"
}

variable "vault_key_id" {
  type        = string
  description = "ID of the KMS used for Vault unseal."
  default     = ""
}

variable "cluster_tag" {
  type        = string
  description = "Tag associated with the cluster."
}

variable "vault_server" {
  type        = bool
  description = "Add Vault server metadata."
  default     = false
}

variable "nomad_server" {
  type        = bool
  description = "Add Nomad server metadata."
  default     = false
}

variable "consul_server" {
  type        = bool
  description = "Add Consul server metadata."
  default     = false
}

variable "nomad_client" {
  type        = bool
  description = "Add Nomad client metadata."
  default     = false
}

variable "consul_agent" {
  type        = bool
  description = "Add non-server Consul metadata"
  default     = false
}
