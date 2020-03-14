variable "vpc_id" {
  type        = string
  description = "VPC to create security groups in."
}

variable "nomad_api_client_sgs" {
  type        = list(string)
  description = "List of additional security groups that source nomad API traffic"
  default     = []
}

variable "consul_api_client_sgs" {
  type        = list(string)
  description = "List of additional security groups that source consul API traffic"
  default     = []
}

variable "vault_api_client_sgs" {
  type        = list(string)
  description = "List of additional security groups that source vault API traffic"
  default     = []
}
