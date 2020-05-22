variable "pool_name" {
  type        = string
  description = "The name of the machine pool.  This will be used on all resources associated with this pool."
}

variable "machine_count_min" {
  type        = number
  description = "Minimum number of machines to run"
}

variable "machine_count_desired" {
  type        = number
  description = "Desired number of machines to run"
}

variable "machine_count_max" {
  type        = number
  description = "Maximum number of machines to run"
}

variable "machine_size" {
  type        = string
  description = "Size of machine to use."
  default     = "t3.medium"
}

variable "ami" {
  type        = string
  description = "AMI containing the resinstack image for this group."
}

variable "vpc_subnets" {
  type        = list(string)
  description = "List of VPC subnets to launch machines in."
}

variable "user_data" {
  type        = string
  description = "LinuxKit formatted metadata string."
}

variable "instance_profile" {
  type        = string
  description = "The profile to assign to each machine."
  default     = ""
}

variable "key_name" {
  type        = string
  description = "The name of a key-pair to associate to the machines.  Note that this feature requires your images to have been built with the SSH server included, which is a non-default option."
}

variable "security_groups" {
  type        = list(string)
  description = "List of security groups to apply to machines."
}

variable "lb_target_groups" {
  type        = list(string)
  description = "List of target group ARNs for this machine pool."
  default     = []
}

variable "termination_policies" {
  type        = list(string)
  description = "List of termination policies.  The default is optimized for updating machines via replacement."
  default = [
    "OldestLaunchTemplate",
    "AllocationStrategy",
    "ClosestToNextInstanceHour",
    "OldestInstance",
  ]
}

variable "cluster_tag" {
  type        = string
  description = "Tag to be used across all resources to namespace clusters."
  default     = "default"
}
