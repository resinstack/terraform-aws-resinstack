variable "vpc_id" {
  type        = string
  description = "ID of a VPC to create security groups in"
}

variable "vpc_subnets" {
  type        = list(string)
  description = "List of subnets the ALB should be present in."
}

variable "direct_access_security_group" {
  type        = string
  description = "ID of a security group to allow access to the ALB"
}

variable "nomad_target_sgs" {
  type        = list(string)
  description = "List of security groups that contain nomad targets"
  default     = []
}

variable "consul_target_sgs" {
  type        = list(string)
  description = "List of security groups that contain consul targets"
  default     = []
}

variable "vault_target_sgs" {
  type        = list(string)
  description = "List of security groups that contain vault targets"
  default     = []
}
